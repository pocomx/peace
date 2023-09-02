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
XRAY_FILE="xray-linux-${ARCH}.zip"

echo "Downloading binary file: ${XRAY_FILE}"
VERSION=$(wget -qO- https://raw.githubusercontent.com/pocomx/peace/main/version/xray.txt | head -1 | tr -d [:space:])
wget -O $PWD/xray.zip https://github.com/pocomx/peace/releases/download/${VERSION}/${XRAY_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE}" && exit 1
fi
echo "Download binary file: ${XRAY_FILE} completed"

echo "Prepare to use"
unzip xray.zip && rm -rfv xray.zip
chmod +x xray-linux-${ARCH}
mv xray-linux-${ARCH} /usr/bin/xray
mv geosite.dat geoip.dat /usr/local/share/xray/
echo "Done"