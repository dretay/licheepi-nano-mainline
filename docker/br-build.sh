#!/bin/sh
set -e

BR_RELEASE='2026.02.2'
PACKAGE=buildroot-${BR_RELEASE}.tar.gz
BR_ROOT=buildroot-${BR_RELEASE}

WORK=/workdir/work            # mounted volume: persistent, but NOT executable
SRC=/tmp/brsrc                    # container-local ext4: executable, ephemeral
BUILD=${SRC}/${BR_ROOT}

mkdir -p ${WORK} ${SRC}
cd ${WORK}

if [ ! -e ${PACKAGE} ]; then
    echo "Downloading : https://buildroot.org/downloads/${PACKAGE}"
    wget -q -c https://buildroot.org/downloads/${PACKAGE}
fi

rm -rf ${BUILD}               # always extract fresh; no half-trees, no guards
tar -C ${SRC} -axf ${PACKAGE}
chmod -R u+rwX,go+rX ${BUILD}

cd ${BUILD}
echo "Building ..."
make O=${SRC}/output BR2_DL_DIR=${WORK}/dl BR2_EXTERNAL=${WORK}/br-config licheepi_nano_defconfig
make O=${SRC}/output BR2_DL_DIR=${WORK}/dl BR2_EXTERNAL=${WORK}/br-config -j$(nproc)

# copy artifacts back to the host-visible mount
rm -rf ${WORK}/output
cp -a ${SRC}/output/images ${WORK}/output
ln -sf output/sdcard.img ${WORK}/sdcard.img
