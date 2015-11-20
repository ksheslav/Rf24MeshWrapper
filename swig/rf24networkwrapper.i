%module RF24NetworkWrapper
%import "/usr/include/linux/types.h"
%include "stdint.i"
%include "typemaps.i"
%include "cpointer.i"
%{
#include "../RF24Network/RF24Network.h"
%}

%typemap(jni) const void* buf, void *buf, const uint8_t *address    "jbyteArray"
%typemap(jstype) const void* buf, void *buf, const uint8_t *address "byte[]"
%typemap(jtype) const void* buf, void *buf, const uint8_t *address  "byte[]"
%typemap(javain) const void* buf, void *buf, const uint8_t *address "$1_name"

%typemap(in)    const void* buf, void *buf, const uint8_t *address  {
    $1 = ($1_ltype) JCALL2(GetPrimitiveArrayCritical, jenv, $input, 0);
}

%typemap(freearg)   const void* buf, void *buf, const uint8_t *address  {
    JCALL3(ReleasePrimitiveArrayCritical, jenv, $input, $1, 0);
}

%apply bool &OUTPUT { bool &tx_ok, bool &tx_fail,bool &rx_ready};

%apply uint8_t *OUTPUT {uint8_t* pipe_num};

%typemap(memberin) uint8_t* {
       (unsigned char*)$input ;
}
%include "../RF24Network/RF24Network.h"
