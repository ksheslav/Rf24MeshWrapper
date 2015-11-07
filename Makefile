#JAVA_HEADERS=/usr/lib/jvm/java-8-oracle/include
JAVA_HEADERS=/usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt/include
NRF240l_H=RF24/nRF24L01.h
RF24_CONF=RF24/RF24_config.h
RF24_CPP=RF24/RF24.cpp
RF24_H=RF24/RF24.h
WRAP=RF24Wrapper/rf24wrapper_wrap.cxx
WRAP_O=RF24Wrapper/rf24wrapper_wrap.o
RPI_UTILITY=RF24/utility/RPi
RF24=RF24/
swig:
	swig -v -c++ -java -outdir	RF24Wrapper/src/ \
			-package nrf24.engineering RF24Wrapper/rf24wrapper.i


compile_native:
	make -C RF24/ RF24.o
	make -C RF24/ bcm2835.o
	g++ -fPIC -c $(WRAP) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux
						-I$(RPI_UTILITY) \
	 					-I$(RF24_CPP) \
						-include $(RF24_H) $(NRF240l_H)  $(RF24_CONF $RF24)
	gcc -shared -lstdc++ $(WRAP_O) $(RF24)/RF24.o $(RF24)/bcm2835.o \
			-o RF24Wrapper/RF24WrapperJava/src/rf24wrapper.so
