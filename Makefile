JAVA_HEADERS=/usr/lib/jvm/java-8-oracle/include
CXX=arm-linux-gnueabihf-g++
CC=arm-linux-gnueabihf-gcc
#JAVA_HEADERS=/usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt/include
# RF24 
NRF240l_H=RF24/nRF24L01.h
RF24_CONF=RF24/RF24_config.h
RF24_CPP=RF24/RF24.cpp
RF24_H=RF24/RF24.h
WRAP_RF24=jni/rf24wrapper.cpp
WRAP_RF24_O=out/rf24wrapper_wrap.so
RPI_UTILITY=RF24/utility/RPi

# RF24Network 
WRAP_RF24_NETWORK=jni/rf24networkwrapper.cpp
WRAP_RF24_NETWORK_O=out/rf24networkwrapper_wrap.so
RF24_NETWORK_H=RF24Network/RF24Network.h

# RF24rk 
WRAP_RF24_MESH=jni/rf24meshwrapper.cpp
WRAP_RF24_MESH_O=out/rf24meshwrapper_wrap.so
RF24_MESH_H=RF24Mesh/RF24Mesh.h

WRAP_RF24_ALL=jni/all.cpp
WRAP_RF24_ALL_O=out/all_wrap.so


CCFLAGS=-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s

PREFIX=/usr/local
LIBDIR=$(PREFIX)/lib
# lib name 
LIB=rf24all
# shared library name
LIBNAME=$(LIB).so

# Where to put the header files
HEADER_DIR=${PREFIX}/include/RF24


swig_rf24:
	mkdir -p RF24Wrapper/src/nrf24/engineering/
	swig3.0 -v -c++ -java -outdir RF24Wrapper/src/nrf24/engineering/ \
			-o $(WRAP_RF24)  \
			-package nrf24.engineering swig/rf24wrapper.i

swig_rf24_network:
	mkdir -p RF24NetworkWrapper/src/nrf24network/engineering/
	swig3.0 -v -c++ -java -outdir RF24NetworkWrapper/src/nrf24network/engineering/ \
			-o $(WRAP_RF24_NETWORK)  \
			-package nrf24network.engineering swig/rf24networkwrapper.i

swig_rf24_mesh:
	mkdir -p RF24MeshWrapper/src/nrf24mesh/engineering/
	swig3.0 -v -c++ -java -outdir RF24MeshWrapper/src/nrf24mesh/engineering/ \
			-o $(WRAP_RF24_MESH)  \
			-package nrf24mesh.engineering swig/rf24meshwrapper.i

swig: swig_rf24 swig_rf24_network swig_rf24_mesh

swig_all:
	mkdir -p SmartHome/src/nrf24/smarthome/
	swig3.0 -v -c++ -java -outdir SmartHome/src/nrf24/smarthome/ \
			-o $(WRAP_RF24_ALL)  \
			-package nrf24.smarthome swig/all.i


compile_rf24:
	mkdir -p out/
	#make RF24
	make -C RF24/ RF24.o
	#make bcm
	make -C RF24/ bcm2835.o
	#make bcm
	make -C RF24/ spi.o
	#make g++
	$(CXX) -fPIC -c $(CCFLAGS) $(WRAP_RF24) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux \
						-I./RF24 \
						-o $(WRAP_RF24_O) \
						-include $(RF24_H)
	#make gcc
	$(CC) -shared -lstdc++ $(CCFLAGS)  $(WRAP_RF24_O)  RF24/spi.o RF24/RF24.o RF24/bcm2835.o \
			-o out/rf24wrapper.so

compile_rf24_network:
	mkdir -p out/
	make -C RF24Network/ RF24Network.o
	#make RF24Network
	$(CXX) -fPIC $(CCFLAGS) -std=c++0x -c $(WRAP_RF24_NETWORK) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux \
						-I./RF24Network \
						-I./RF24 \
						-o $(WRAP_RF24_NETWORK_O) \
						-include $(RF24_NETWORK_H) 
	$(CC) -g -shared -lstdc++ $(CCFLAGS)  $(WRAP_RF24_NETWORK_O)  RF24/spi.o RF24/RF24.o RF24/bcm2835.o \
			-o out/rf24networkwrapper.so

lib:
	@echo "[Installing Libs]"
	@if ( test ! -d $(PREFIX)/lib ) ; then mkdir -p $(PREFIX)/lib ; fi
	@install -m 0755 ./out/${LIBNAME} ${LIBDIR}
	@ln -sf ${LIBDIR}/${LIBNAME} ${LIBDIR}/${LIB}.so.1
	@ln -sf ${LIBDIR}/${LIBNAME} ${LIBDIR}/${LIB}.so
	@ldconfig

compile_rf24_mesh:
	mkdir -p out/
	#make RF24Mesh
	make -C RF24/ RF24.o
	#make bcm
	make -C RF24/ bcm2835.o
	#make rcm
	make -C RF24/ spi.o
	make -C RF24Mesh/ RF24Mesh.o
	$(CXX) -fPIC -c $(CCFLAGS) $(WRAP_RF24_ALL) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux \
						-I./RF24 \
						-I./RF24Network \
						-I./RF24Mesh \
						-o $(WRAP_RF24_ALL_O) \
						-include $(RF24_NETWORK_H) $(RF24_H) $(RF24_MESH_H)


	$(CC) -g -shared -lstdc++ $(CCFLAGS)  $(WRAP_RF24_MESH_O)  RF24Mesh/RF24Mesh.o $(WRAP_RF24_NETWORK_O)  RF24/spi.o RF24/RF24.o RF24/bcm2835.o RF24/spi.o   \
			-o out/rf24meshwrapper.so

comnpile_with_dependencies:
	mkdir -p out/
	#make RF24
	make -C RF24/ RF24.o
	#make bcm
	make -C RF24/ bcm2835.o
	#make spi
	make -C RF24/ spi.o
	#make Mesh
	make -C RF24Network/ RF24Network.o
	#make Mesh
	make -C RF24Mesh/ RF24Mesh.o
	
	$(CXX) -fPIC -c $(CCFLAGS) $(WRAP_RF24_ALL) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux \
						-I./RF24 \
						-I./RF24Network \
						-I./RF24Mesh \
						-o $(WRAP_RF24_ALL_O) 
						
	$(CC) -g -shared -lstdc++ $(CCFLAGS)  $(WRAP_RF24_ALL_O)  RF24/RF24.o RF24Network/RF24Network.o RF24Mesh/RF24Mesh.o \
			-o out/$(LIBNAME)


compile_all: compile_rf24 compile_rf24_network compile_rf24_mesh

all: swig compile_all
# conmpile_main:
	# javac -d bin/ RF24Wrapper/src/nrf24/engineering/*.java src/rf24/wrapper/Main.java


# start_app:
	# java  -Djava.class.path=bin/ rf24.wrapper.Main
