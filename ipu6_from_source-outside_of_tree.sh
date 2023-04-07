#! /bin/bash

# NOTE: dependencies pkg-config, libexpat1-dev, dh-autoreconf
#                    + whatever's specified in the docs (libdrm-dev)
#

# IPU6 drivers
git clone https://github.com/intel/ipu6-drivers.git

# See https://github.com/intel/ipu6-drivers#2-build-outside-kernel-source-tree
cd ipu6-drivers
git clone https://github.com/intel/ivsc-driver.git
cp -r ivsc-driver/backport-include ivsc-driver/drivers ivsc-driver/include .
rm -rf ivsc-driver

make -j`nproc` && sudo make modules_install && sudo depmod -a
cd ..

# IPU6 camera bins
git clone https://github.com/intel/ipu6-camera-bins.git

# https://github.com/intel/ipu6-camera-bins#deployment
# Note: Alder Lake
sudo cp -r ipu6-camera-bins/ipu6ep/include/* /usr/include/
sudo cp -r --remove-destination ipu6-camera-bins/ipu6ep/lib/* /usr/lib/

# IPU6 camera HAL
git clone https://github.com/intel/ipu6-camera-hal.git

# https://github.com/intel/ipu6-camera-hal#build-instructions
cd ipu6-camera-hal
# cd config/linux/ipu6ep
# ffmpeg -i <input_file> -pix_fmt nv12 privacy_image_<sensor_name>-uf_<width>_<height>.yuv

export IPU6_VER=ipu6ep
mkdir -p ./build/out/install/usr && cd ./build/

cmake -DCMAKE_BUILD_TYPE=Release \
-DIPU_VER=${IPU6_VER} \
-DENABLE_VIRTUAL_IPU_PIPE=OFF \
-DUSE_PG_LITE_PIPE=ON \
-DUSE_STATIC_GRAPH=OFF \
-DCMAKE_INSTALL_PREFIX=/usr ..
# if don't want install to /usr, use -DCMAKE_INSTALL_PREFIX=./out/install/usr, export PKG_CONFIG_PATH="$workdir/build/out/install/usr/lib/pkgconfig"

make -j`nproc`
sudo make install

sudo cp ../config/linux/rules.d/*.rules /lib/udev/rules.d/
cd ../..

# icamera

git clone https://github.com/intel/icamerasrc.git

# We need this branch!
cd icamerasrc
git checkout icamerasrc_slim_api
git pull

# https://github.com/intel/icamerasrc/tree/icamerasrc_slim_api#build-instructions
export CHROME_SLIM_CAMHAL=ON
# for libdrm.pc
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"
./autogen.sh
# !!!!!!! [1] !!!!!!!!
sed -i 's/, camerasrc->num_vc//' src/gstcamerasrc.cpp
make -j8
# binary install
sudo make install
# build rpm package and then install
make rpm
sudo rpm -ivh --force --nodeps rpm/icamerasrc-*.rpm




# [1]
# Manual fix here (removing 2nd parameter)
#
# mv -f .deps/libgsticamerasrc_la-gstcampushsrc.Tpo .deps/libgsticamerasrc_la-gstcampushsrc.Plo
# mv -f .deps/libgsticamerasrc_la-utils.Tpo .deps/libgsticamerasrc_la-utils.Plo
# mv -f .deps/libgsticamerasrc_la-gstcameradeinterlace.Tpo .deps/libgsticamerasrc_la-gstcameradeinterlace.Plo
# gstcamerasrc.cpp: In function ‘gboolean gst_camerasrc_start(GstCamBaseSrc*)’:
# gstcamerasrc.cpp:2839:27: error: too many arguments to function ‘int icamera::camera_device_open(int)’
#  2839 |   ret = camera_device_open(camerasrc->device_id, camerasrc->num_vc);
#       |         ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In file included from gstcamerasrc.cpp:62:
# /usr/include/libcamhal/api/ICamera.h:210:5: note: declared here
#   210 | int camera_device_open(int camera_id);
#       |     ^~~~~~~~~~~~~~~~~~
# mv -f .deps/libgsticamerasrc_la-gstcameraformat.Tpo .deps/libgsticamerasrc_la-gstcameraformat.Plo
# make[3]: *** [Makefile:623: libgsticamerasrc_la-gstcamerasrc.lo] Error 1
# make[3]: *** Waiting for unfinished jobs....
# mv -f .deps/libgsticamerasrc_la-gstcamerasrcbufferpool.Tpo .deps/libgsticamerasrc_la-gstcamerasrcbufferpool.Plo
# mv -f .deps/libgsticamerasrc_la-gstcambasesrc.Tpo .deps/libgsticamerasrc_la-gstcambasesrc.Plo
# make[3]: Leaving directory '/home/judit/ubuntu/icamerasrc/src'
# make[2]: *** [Makefile:684: all-recursive] Error 1
# make[2]: Leaving directory '/home/judit/ubuntu/icamerasrc/src'
# make[1]: *** [Makefile:519: all-recursive] Error 1
# make[1]: Leaving directory '/home/judit/ubuntu/icamerasrc'
# make: *** [Makefile:428: all] Error 2


