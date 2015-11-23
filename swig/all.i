%module RF24Wrapper
%import "/usr/include/linux/types.h"
%include "stdint.i"
%include "typemaps.i"
%include "arrays_java.i"
%{
#include "../RF24/RF24.h"
#include "../RF24Network/RF24Network.h"
#include "../RF24Mesh/RF24Mesh.h"
%}

%typemap(jni) const void* , void *, const uint8_t *    "jbyteArray"
%typemap(jstype) const void*, void *, const uint8_t * "byte[]"
%typemap(jtype)   const void*, void *, const uint8_t * "byte[]"
%typemap(javain) const void*, void *, const uint8_t * "$1_name"
%typemap(jni)  uint32_t *, const uint32_t *    "long"
%typemap(jstype) uint32_t *, const uint32_t *    "long"
%typemap(jtype) uint32_t *, const uint32_t *    "long"
%typemap(javain) uint32_t *, const uint32_t *    "$1_name"


%typemap(in) uint32_t *, const uint32_t *, const void*, void *, const uint8_t * {
    $1 = ($1_ltype) JCALL2(GetPrimitiveArrayCritical, jenv, $input, 0);
}

%typemap(freearg) uint32_t *, const uint32_t *, const void*, void *, const uint8_t * {
    JCALL3(ReleasePrimitiveArrayCritical, jenv, $input, $1, 0);
}

%apply bool &OUTPUT { bool &tx_ok, bool &tx_fail,bool &rx_ready};

%apply uint8_t *OUTPUT {uint8_t* pipe_num};

%include "../RF24/RF24.h"
%include "../RF24Network/RF24Network.h"
%include "../RF24Mesh/RF24Mesh.h"
