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

# RF24Network 
WRAP_RF24_MESH=jni/rf24meshwrapper.cpp
WRAP_RF24_MESH_O=out/rf24meshwrapper_wrap.so
RF24_MESH_H=RF24Mesh/RF24Mesh.h

CCFLAGS=-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s
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
compile_rf24_mesh:
	mkdir -p out/
	#make RF24Mesh
	make -C RF24Mesh/ RF24Mesh.o
	$(CXX) -fPIC -c $(CCFLAGS) $(WRAP_RF24_MESH) \
	 					-I$(JAVA_HEADERS) \
						-I$(JAVA_HEADERS)/linux \
						-I./RF24Mesh \
						-o $(WRAP_RF24_MESH_O) \
						-include $(RF24_NETWORK_H)
	$(CC) -g -shared -lstdc++ $(CCFLAGS)  $(WRAP_RF24_MESH_O)  RF24Mesh/RF24Mesh.o \
			-o out/rf24meshwrapper.so

compile_all: compile_rf24 compile_rf24_network compile_rf24_mesh

all: swig compile_all
# conmpile_main:
	# javac -d bin/ RF24Wrapper/src/nrf24/engineering/*.java src/rf24/wrapper/Main.java


# start_app:
	# java  -Djava.class.path=bin/ rf24.wrapper.Main
