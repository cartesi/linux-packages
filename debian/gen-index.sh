#!/bin/bash
set -e
cd /apt
rm -f ${REPO_NAME}/InRelease ${REPO_NAME}/Release.gpg
find /apt/${REPO_NAME} -name '*.deb' -size -1000c -delete 2>/dev/null || true
dpkg-scanpackages --multiversion ${REPO_NAME} > ${REPO_NAME}/Packages
gzip -k -f /apt/${REPO_NAME}/Packages
apt-ftparchive \
      -o APT::FTPArchive::Release::Origin="Cartesi" \
      -o APT::FTPArchive::Release::Label="Cartesi APT Repository" \
      -o APT::FTPArchive::Release::Suite="stable" \
      release ${REPO_NAME} > ${REPO_NAME}/Release
echo "deb ${REPO_URL} ${REPO_NAME}/" > /apt/${REPO_NAME}/sources.list
