#JAVA_HEADERS=/usr/lib/jvm/java-8-oracle/include
JAVA_HEADERS=/usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt/include
NRF240l_H=RF24/nRF24L01.h
RF24_CONF=RF24/RF24_config.h
RF24_CPP=RF24/RF24.cpp
RF24_H=RF24/RF24.h
WRAP=RF24Wrapper/rf24wrapper_wrap.cpp
WRAP_O=RF24Wrapper/rf24wrapper_wrap.o
RPI_UTILITY=RF24/utility/RPi
swig:
	swig -v -c++ -java -outdir RF24Wrapper/src/ \
			-o $(WRAP)  \
			-package nrf24.engineering RF24Wrapper/rf24wrapper.i


compile_native:
	#make RF24
	make -C RF24/ RF24.o
	#make bcm
	make -C RF24/ bcm2835.o
	#make g++
	g++ -fPIC -c $(WRAP) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux \
						-I./RF24 \
						-o $(WRAP_O) \
						-include $(RF24_H)
	#make gcc
	gcc -shared -lstdc++ $(WRAP_O) RF24/RF24.o RF24/bcm2835.o \
			-o RF24Wrapper/rf24wrapper.so
