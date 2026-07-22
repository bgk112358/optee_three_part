/*
 * Public header for paho SSLSocket external config callback.
 *
 * Include this (instead of the internal SSLSocket.h) to register
 * a callback that injects credentials from HSM / TEE into paho's
 * SSL_CTX before the TLS handshake.
 */
#ifndef PAHO_SSLSOCKET_CONFIG_H
#define PAHO_SSLSOCKET_CONFIG_H

#include <openssl/ssl.h>

typedef int (*SSLSocket_externalConfigCallback)(SSL_CTX *ctx);

void SSLSocket_setExternalConfigCallback(SSLSocket_externalConfigCallback cb);

#endif
