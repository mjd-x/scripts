#!/bin/bash

# Color settings
YELLOW_COLOR="\033[1;33m"
RED_COLOR="\033[0;31m"
OFF_COLOR="\033[0m"

FILE=${1}
ABS_FILE_PATH=$(realpath ${FILE})

echo -e "Creating manifest..."
dpkg-query --show --admindir="/var/lib/dpkg" > ${ABS_FILE_PATH}
echo -e "${YELLOW_COLOR}Manifest saved to ${ABS_FILE_PATH}.${OFF_COLOR}"
exit 0

