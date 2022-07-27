export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

INSTALLER_CHANNEL = 21.11
INSTALLER_CHANNEL_NIXPKGS = nixpkgs/$(INSTALLER_CHANNEL)

.PHONY:

setup: .PHONY setup-nixpkgs
	@rm ./result 2> /dev/null || true

build: .PHONY setup-qemu
	docker-compose up --build;

build-native: .PHONY
	nix-build '<nixpkgs/nixos>' \
		-A config.system.build.sdImage \
		-I nixos-config=./installer/default.nix \
		-I nixpkgs=$(INSTALLER_CHANNEL_NIXPKGS) \
		--argstr system aarch64-linux \
		--option sandbox false;
	mkdir -p ./output;
	cp -rf ./result/* ./output/;

setup-nixpkgs: .PHONY
	@if [ ! -d $(INSTALLER_CHANNEL_NIXPKGS) ]; then \
		git clone --depth=1 \
			-b release-$(INSTALLER_CHANNEL) \
			https://github.com/NixOS/nixpkgs \
			$(INSTALLER_CHANNEL_NIXPKGS); \
	fi;

setup-qemu: .PHONY
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

DEV = /dev/sda
OUTDIR = ./output
burn: .PHONY
	@echo "Burning image $(shell ls $(OUTDIR)/sd-image/*.img | head -n 1)...";
	sudo dd \
		if="$(shell ls $(OUTDIR)/sd-image/*.img | head -n 1)" \
		of="$(DEV)" \
		bs=4096 conv=fsync status=progress;

# Helper to notify on task completion
notify: .PHONY
	@notify-send "=== COMPLETE ===";

