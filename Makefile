ARCH := $(shell uname -m)

ifeq ($(ARCH),x86_64)
    ARCH_SHORT := x64
else ifeq ($(ARCH),aarch64)
    ARCH_SHORT := arm64
else
    ARCH_SHORT := $(ARCH)
endif

APP_NAME = miracle_settings
BUILD_DIR = build/linux/$(ARCH_SHORT)/release/bundle
INSTALL_DIR = /opt/$(APP_NAME)
DESKTOP_FILE = $(APP_NAME).desktop
FLUTTER_BIN = ${FLUTTER}

all: build install desktop-entry

build:
	$(FLUTTER_BIN) build linux --release

install: desktop-entry
	sudo mkdir -p $(INSTALL_DIR)
	sudo cp -r $(BUILD_DIR)/* $(INSTALL_DIR)/
	sudo cp -r assets/icon.png $(INSTALL_DIR)/data/flutter_assets/
	sudo chmod +x $(INSTALL_DIR)/$(APP_NAME)

desktop-entry:
	@echo "[Desktop Entry]" > $(DESKTOP_FILE)
	@echo "Name=Miracle Settings" >> $(DESKTOP_FILE)
	@echo "Exec=env LD_LIBRARY_PATH=$(INSTALL_DIR)/lib $(INSTALL_DIR)/$(APP_NAME)" >> $(DESKTOP_FILE)
	@echo "Icon=$(INSTALL_DIR)/data/flutter_assets/icon.png" >> $(DESKTOP_FILE)
	@echo "Type=Application" >> $(DESKTOP_FILE)
	@echo "Categories=Utility;Application;" >> $(DESKTOP_FILE)
	sudo desktop-file-install $(DESKTOP_FILE)
	sudo update-desktop-database

clean:
	(FLUTTER_BIN) clean
	rm -f $(DESKTOP_FILE)

uninstall:
	sudo rm -rf $(INSTALL_DIR)
	sudo rm -f /usr/share/applications/$(DESKTOP_FILE)

.PHONY: all build install desktop-entry clean uninstall
