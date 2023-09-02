#!/bin/sh

PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="amd64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="386"
            ;;
        linux/amd64)
            ARCH="amd64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download binary file
SING_BOX_FILE="sing-box-linux-${ARCH}.zip"

echo "Downloading binary file: ${SING_BOX_FILE}"
VERSION=$(wget -qO- https://raw.githubusercontent.com/pocomx/peace/master/version/sing-box.txt | head -1 | tr -d [:space:])
wget -O $PWD/sing-box.zip https://github.com/pocomx/peace/releases/download/${VERSION}/${SING_BOX_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${SING_BOX_FILE}" && exit 1
fi
echo "Download binary file: ${SING_BOX_FILE} completed"

echo "Prepare to use"
unzip sing-box.zip && rm -rfv sing-box.zip
chmod +x *-linux-${ARCH}
mv sing-box-linux-${ARCH} /usr/bin/sing-box
mv geosite.db geoip.db /usr/bin/
echo "Done"