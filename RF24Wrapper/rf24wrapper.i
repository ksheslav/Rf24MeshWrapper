%module RF24Wrapper
%import "/usr/include/linux/types.h"
%include "stdint.i"
%include "typemaps.i"
%{
#include "../RF24/RF24.h"
#include "../RF24/RF24_config.h"
#include "../RF24/nRF24L01.h"
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

%include "../RF24/RF24.h"
%include "../RF24/RF24.h"
%include "../RF24/RF24_config.h"
