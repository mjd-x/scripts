#!/bin/bash

# Color settings
YELLOW_COLOR="\033[1;33m"
RED_COLOR="\033[0;31m"
OFF_COLOR="\033[0m"

# Execute it as root user
if [ "${USER}" != root ]; then
  echo -e "${RED_COLOR}ERROR: must be root! Exiting...${OFF_COLOR}"
  exit 1
fi

# based on https://gist.github.com/shamil/62935d9b456a6f9877b5
IMAGE="$1"
MOUNTPOINT=${2:-"./cloudimg"}
ABS_MOUNT_PATH=$(realpath ${MOUNTPOINT})

umount_qcow2() {
  umount "${ABS_MOUNT_PATH}"
  qemu-nbd --disconnect "${DEVICE}"
  sleep 2
  rmmod nbd
  echo -e "${YELLOW_COLOR}Image unmounted${OFF_COLOR}"
  exit 0
}

trap umount_qcow2 SIGINT

mkdir -p "${ABS_MOUNT_PATH}"
modprobe nbd max_part=8
qemu-nbd --connect "/dev/nbd0" ${IMAGE}
DEVICE=$(fdisk /dev/nbd0 -l | grep Linux | awk '{print $1}')
mount "${DEVICE}" "${ABS_MOUNT_PATH}"
echo -e "${YELLOW_COLOR}Image mounted to ${ABS_MOUNT_PATH}${OFF_COLOR}"
echo "Press Ctrl-C to unmount."

# wait until user stops process to unmount
read -r -d '' _