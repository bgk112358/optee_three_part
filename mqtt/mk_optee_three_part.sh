# 依赖aarch64的libcrypto + libssl
# 需要先构建openssl (../openssl/out)
#
# paho.mqtt.c-1.3.16 使用 CMake 构建，不是 autotools。
# Cross-compile → install to $DIRPATH/out → copy to buildroot.

FILEPATH=$(readlink -f "$0")
DIRPATH=$(dirname "$FILEPATH")

optee_dir="/home/test0923/workspace/optee400"

echo $FILEPATH
echo $DIRPATH

export PATH="$optee_dir/toolchains/aarch64/bin:$PATH"
export CROSS_COMPILE_HOST=aarch64-linux-gnu
export ARCH=arm

# OpenSSL cross-built artifacts (reference: ../openssl/mk_*.sh)
OPENSSL_DIR="$DIRPATH/../openssl/out"

cd paho.mqtt.c-1.3.16

rm -rf build
mkdir build && cd build

# ---- CMake configure ----
# PAHO_WITH_SSL=TRUE  → build libpaho-mqtt3as.so + libpaho-mqtt3cs.so
# OpenSSL paths must be explicit; CMake's find_package(OpenSSL) won't
# find the cross-compiled libs on its own.
cmake .. \
    -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_INSTALL_PREFIX="$DIRPATH/out" \
    -DPAHO_WITH_SSL=TRUE \
    -DPAHO_BUILD_SHARED=TRUE \
    -DPAHO_BUILD_STATIC=FALSE \
    -DPAHO_BUILD_SAMPLES=FALSE \
    -DPAHO_BUILD_DOCUMENTATION=FALSE \
    -DOPENSSL_ROOT_DIR="$OPENSSL_DIR" \
    -DOPENSSL_INCLUDE_DIR="$OPENSSL_DIR/include" \
    -DOPENSSL_SSL_LIBRARY="$OPENSSL_DIR/lib/libssl.so" \
    -DOPENSSL_CRYPTO_LIBRARY="$OPENSSL_DIR/lib/libcrypto.so"

# ---- Build + Install ----
make -j$(nproc)
make install

cd -   # back to paho.mqtt.c-1.3.16

cd "$DIRPATH"

echo "Copy "$FILEPATH" three part bin to $optee_dir/out-br/-------------------"
cp -au ./out/lib/*.so*  $optee_dir/out-br/target/usr/lib/
