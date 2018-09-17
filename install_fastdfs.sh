#!/bin/sh
yum install gettext gettext-devel libXft libXft-devel libXpm libXpm-devel automake autoconf libXtst-devel gtk+-devel gcc gcc-c++zlib-devel libpng-devel gtk2-devel glib-devel pcre* git -y 
rm -rf /usr/local/fastdfs
mkdir -p /usr/local/fastdfs
cd /usr/local/fastdfs
##download libfastcommon包
wget http://172.16.13.181/packages/libfastcommon-1.0.39.tar.gz
tar -xvf libfastcommon-1.0.39.tar.gz
cd libfastcommon-1.0.39
./make.sh
./make.sh install
cd /usr/local/fastdfs
wget http://172.16.13.181/packages/fastdfs-5.11.tar.gz
tar -xvf fastdfs-5.11.tar.gz
cd fastdfs-5.11
sed -i 's#/usr/local/bin#/usr/bin#g' init.d/fdfs_storaged
sed -i 's#/usr/local/bin/#/usr/bin#g' init.d/fdfs_trackerd 
./make.sh
./make.sh install
cp conf/http.conf conf/mime.types /etc/fdfs/
cd /etc/fdfs/
cp tracker.conf.sample tracker.conf
cp storage.conf.sample storage.conf
cd /usr/local/fastdfs
wget http://172.16.13.181/packages/ngx_openresty-1.7.4.1.tar.gz
tar -xzvf ngx_openresty-1.7.4.1.tar.gz
cd ngx_openresty-1.7.4.1
./configure
make
make install
wget http://172.16.13.181/packages/GraphicsMagick-1.3.17.tar.gz
tar -xzvf GraphicsMagick-1.3.17.tar.gz
cd GraphicsMagick-1.3.17
./configure
make
make install
cd /usr/local/fastdfs
wget http://172.16.13.181/packages/ffmpeg-4.0.2.tar.bz2
tar -xjf ffmpeg-4.0.2.tar.bz2
cd ffmpeg-4.0.2
./configure --prefix=/usr/local/ffmpeg
make
make install
cd /usr/local/openresty/nginx/conf
rm -rf nginx.conf
wget http://172.16.13.181/packages/nginx.conf
mkdir lua
cd lua
wget http://172.16.13.181/packages/fastdfs.lua
wget http://172.16.13.181/packages/restyfastdfs.lua
mkdir -p /data/fastdfs
ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/sbin/nginx
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 22122 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 23000 -j ACCEPT
