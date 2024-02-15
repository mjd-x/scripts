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

CURRENT_KERNEL=$(uname -r)
echo -e "${YELLOW_COLOR}Current kernel: ${CURRENT_KERNEL}${OFF_COLOR}"

KERNEL_PACKAGES="kernels"

(dpkg --list | egrep -i --color 'linux-image|linux-headers|linux-modules' | awk '{ print $2 }') > kernels

while IFS= read LINE; do
    if [[ $LINE != *$CURRENT_KERNEL*  ]] &&  [[ $LINE != *hwe* ]] ; then
        echo -e "${RED_COLOR}Removing ${LINE}${OFF_COLOR}"
	apt purge -yqq $LINE
    fi
done < $KERNEL_PACKAGES

echo -e "${RED_COLOR}Purged every old kernel${OFF_COLOR}"
rm $KERNEL_PACKAGES
exit 0
