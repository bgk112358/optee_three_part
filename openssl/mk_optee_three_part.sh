FILEPATH=$(readlink -f "$0")
DIRPATH=$(dirname "$FILEPATH")
 
# optee_dir="/home/test0923/workspace/optee400"
 
echo $FILEPATH
echo $DIRPATH

export OPENSSL_ENGINES=/lib

# 在 AG519M 的SDK里/opt/ql-ol-crosstool/sysroots/x86_64-oesdk-linux/usr/bin/目录包含了perl基本库，这个库支持包不全，直接删掉, sudo mv perl perl.bak，perl会改用本地的perl
# 在 AG519M 的环境变量里，会有两条前缀的重叠，可通过注释/opt/ql-ol-crosstool/ql-ol-crosstool-env-init 里的一个变量# export CROSS_COMPILE=...
cd openssl-1.1.1b
./Configure linux-armv4 --prefix=$DIRPATH/out
 
# --openssldir=/usr
# old="ENGINESDIR=\$(libdir)\/engines-1.1"
# new="ENGINESDIR=\/usr\/lib\/engine-1.1"
# sed -i "s/$old/$new/g" Makefile
 
make -j4
make install
cd -
 
# echo "Copy "$FILEPATH" three part bin to $optee_dir/out-br/-------------------"
# cp -aux ./out/lib/*.so*  $optee_dir/out-br/target/usr/lib/
# cp -aux ./out/bin/*      $optee_dir/out-br/target/usr/bin
