FILEPATH=$(readlink -f "$0")
DIRPATH=$(dirname "$FILEPATH")
 
optee_dir="/home/test0923/workspace/optee400"
 
echo $FILEPATH
echo $DIRPATH
 
export PATH="$optee_dir/toolchains/aarch64/bin:$PATH"
export CROSS_COMPILE_HOST=aarch64-linux-gnu-
export ARCH=arm
 
export OPENSSL_ENGINES=/lib
 
cd openssl-1.1.1b
./config no-asm --prefix=$DIRPATH/out \
                --cross-compile-prefix=aarch64-linux-gnu-
sed -i 's/-m64/ /g' Makefile
 
# --openssldir=/usr
# old="ENGINESDIR=\$(libdir)\/engines-1.1"
# new="ENGINESDIR=\/usr\/lib\/engine-1.1"
# sed -i "s/$old/$new/g" Makefile
 
make -j16
make install
cd -
 
echo "Copy "$FILEPATH" three part bin to $optee_dir/out-br/-------------------"
cp -aux ./out/lib/*.so*  $optee_dir/out-br/target/usr/lib/
cp -aux ./out/bin/*      $optee_dir/out-br/target/usr/bin
