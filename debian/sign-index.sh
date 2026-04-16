#!/bin/bash
set -e
gpg -abs -o - /apt/${REPO_NAME}/Release > /apt/${REPO_NAME}/Release.gpg
gpg --clearsign -o - /apt/${REPO_NAME}/Release > /apt/${REPO_NAME}/InRelease
