# List of packages to compile for any architecture
PACKAGES_ANYARCH=\
cartesi-machine-linux-image \
cartesi-machine-rootfs-image \
cartesi-machine-emulator \
xgenext2fs

# List of packages to compile for riscv64
PACKAGES_RISCV64=\
cartesi-machine-guest-linux-headers \
cartesi-machine-guest-tools

# Target architecture to compile packages
TARGET_ARCH?=$(shell uname -m)

# Docker platform architecture (maps uname -m names to Docker platform names)
DOCKER_ARCH_x86_64=amd64
DOCKER_ARCH_aarch64=arm64
DOCKER_ARCH_riscv64=riscv64
DOCKER_ARCH=$(DOCKER_ARCH_$(TARGET_ARCH))

# Docker base image used for building packages
BASE_IMAGE=alpine:3.23
IMAGE=cartesi/apk-builder-$(DOCKER_ARCH)

# Repository path to save built packages
REPO_PATH=$(abspath ../cdn)/apk
REPO_NAME=stable
KEY_NAME=cartesi-apk-key
REMOTE_APK_REPO_URL?=https://cartesi.github.io/linux-packages/apk

# Package list to build
PACKAGES=$(PACKAGES_ANYARCH)
ifeq ($(TARGET_ARCH),riscv64)
PACKAGES+=$(PACKAGES_RISCV64)
endif

all: ## Generate a key (if needed) and build all packages
	@$(MAKE) --no-print-directory image
	@$(MAKE) --no-print-directory key
	@$(MAKE) --no-print-directory packages-all

packages-all: ## Build packages for all architectures (x86_64/aarch64/riscv64)
	@$(MAKE) --no-print-directory image TARGET_ARCH=x86_64
	@$(MAKE) --no-print-directory packages TARGET_ARCH=x86_64
	@$(MAKE) --no-print-directory image TARGET_ARCH=aarch64
	@$(MAKE) --no-print-directory packages TARGET_ARCH=aarch64
	@$(MAKE) --no-print-directory image TARGET_ARCH=riscv64
	@$(MAKE) --no-print-directory packages TARGET_ARCH=riscv64

packages: $(patsubst %,%.apk,$(PACKAGES)) ## Build packages for given TARGET_ARCH

%.apk: ## Build a package for given TARGET_ARCH
	@$(MAKE) --no-print-directory exec COMMAND="\
	cd $* && \
	build-apk.sh && \
	chown -R $(shell id -u):$(shell id -g) /root/packages/work"

re-sign: ## Re-sign packages and index for given TARGET_ARCH (uses x86_64 builder image) and KEY_NAME
	@$(MAKE) --no-print-directory exec COMMAND="\
	cd /root/packages/work/$(TARGET_ARCH) && \
	find ./*.apk -exec re-sign-apk.sh {} /root/.abuild/$(KEY_NAME).rsa \; && \
	rm APKINDEX.tar.gz && \
	apk index --no-warnings --output APKINDEX.tar.gz *.apk && \
	abuild-sign --private /root/.abuild/$(KEY_NAME).rsa APKINDEX.tar.gz && \
	chown -R $(shell id -u):$(shell id -g) /root/packages/work"

re-sign-all: ## Re-sign packages and index for all architectures
	@$(MAKE) --no-print-directory sign TARGET_ARCH=x86_64
	@$(MAKE) --no-print-directory sign TARGET_ARCH=aarch64
	@$(MAKE) --no-print-directory sign TARGET_ARCH=riscv64

key: ## Generate package signature key
	echo "NOTICE: Generating new key!"
	@mkdir -p $(REPO_PATH)/keys key
	docker run --platform=linux/$(DOCKER_ARCH) \
		--volume ./key:/root/.abuild \
		--volume $(REPO_PATH):/apk \
		--rm $(IMAGE) \
		ash -c "\
	abuild-keygen -n && \
	mv /root/.abuild/-*.rsa.pub /root/.abuild/$(KEY_NAME).rsa.pub && \
	mv /root/.abuild/-*.rsa /root/.abuild/$(KEY_NAME).rsa && \
	echo 'PACKAGER_PRIVKEY=/root/.abuild/$(KEY_NAME).rsa' > /root/.abuild/abuild.conf && \
	cp /root/.abuild/$(KEY_NAME).rsa.pub /apk/keys/$(KEY_NAME).rsa.pub && \
	chown -R $(shell id -u):$(shell id -g) /root/.abuild /apk/keys"

shell: ## Spawn an image shell for given TARGET_ARCH
	@$(MAKE) --no-print-directory exec  DOCKER_FLAGS="-it" COMMAND="ash"

exec: ## Execute a COMMAND inside an image for given TARGET_ARCH
	@mkdir -p key
	docker run --platform=linux/$(DOCKER_ARCH) \
		--volume ./key:/key \
		--volume $(REPO_PATH)/$(REPO_NAME):/root/packages/work \
		--volume .:/work \
		--workdir /work \
		--env KEY_NAME=$(KEY_NAME) \
		--env REMOTE_APK_REPO_URL=$(REMOTE_APK_REPO_URL) \
		--env TARGET_ARCH=$(TARGET_ARCH) \
		$(DOCKER_FLAGS) --rm $(IMAGE) \
		setup-env.sh ash -c "$(COMMAND)"

image: ## Build Docker image for building packages for given TARGET_ARCH
	docker buildx build --platform=linux/$(TARGET_ARCH) \
		--build-arg=BASE_IMAGE=$(BASE_IMAGE) \
		--tag=$(IMAGE) \
		--load \
		--progress=plain \
		--file Dockerfile \
		$(DOCKER_BUILD_FLAGS) .

test: ## Test built packages for all architectures (x86_64/aarch64/riscv64)
	@$(MAKE) --no-print-directory test-packages TARGET_ARCH=x86_64
	@$(MAKE) --no-print-directory test-packages TARGET_ARCH=aarch64
	@$(MAKE) --no-print-directory test-packages TARGET_ARCH=riscv64

ifeq ($(TARGET_ARCH),riscv64)
test-packages:
	@$(MAKE) --no-print-directory exec COMMAND="\
	apk add --allow-untrusted $(PACKAGES) && \
	rollup --help && \
	cartesi-machine --final-hash"
else
test-packages: ## Test built packages for given TARGET_ARCH
	@$(MAKE) --no-print-directory exec COMMAND="\
	apk add --allow-untrusted $(PACKAGES) && \
	cartesi-machine --final-hash"
endif

distclean: ## Remove everything from APK repository directory
	rm -rf $(REPO_PATH)/$(REPO_NAME)

help: ## Show this help
	@sed \
		-e '/^[a-zA-Z0-9_\-]*:.*##/!d' \
		-e 's/:.*##\s*/:/' \
		-e 's/^\(.\+\):\(.*\)/$(shell tput setaf 6)\1$(shell tput sgr0):\2/' \
		$(MAKEFILE_LIST) | column -c2 -t -s :

.PHONY: all packages-all packages shell exec image re-sign re-sign-all key test test-packages distclean help
