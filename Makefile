VERSION:=1.8.3
DOWNLOAD_DIR:=/tmp
RUNTIME_ZIP_FILENAME:=distribution-$(VERSION)-runtime.zip
RUNTIME_ZIP:=$(DOWNLOAD_DIR)/$(RUNTIME_ZIP_FILENAME)

ADDONS_ZIP_FILENAME:=distribution-$(VERSION)-addons.zip
ADDONS_ZIP:=$(DOWNLOAD_DIR)/$(ADDONS_ZIP_FILENAME)

INSTALL_DIR:=/opt/openhab
ADDONS_DIR:=$(INSTALL_DIR)/addons

LIB_PROVIDER:=https://bintray.com/artifact/download/openhab/bin

CONFIG_DIR:=.

home: addons 
	cp $(CONFIG_DIR)/sitemaps/home.sitemap $(INSTALL_DIR)/configurations/sitemaps/default.sitemap
	cp $(CONFIG_DIR)/openhab.cfg $(INSTALL_DIR)/configurations/openhab.cfg

runtime: $(RUNTIME_ZIP) $(INSTALL_DIR)
	cp $(DOWNLOAD_DIR)/$(RUNTIME_ZIP_FILENAME) $(INSTALL_DIR)/$(RUNTIME_ZIP_FILENAME) \
		&& cd $(INSTALL_DIR) \
		&& unzip -o $(RUNTIME_ZIP_FILENAME) \
		&& rm -f $(RUNTIME_ZIP_FILENAME) \
		&& chown pi:pi -R $(INSTALL_DIR)

addons: runtime $(ADDONS_ZIP) $(ADDONS_DIR)
	cp $(DOWNLOAD_DIR)/$(ADDONS_ZIP_FILENAME) $(INSTALL_DIR)/addons/$(ADDONS_ZIP_FILENAME) \
		&& cd $(INSTALL_DIR)/addons \
		&& unzip -o $(ADDONS_ZIP_FILENAME) \
		&& rm -f $(ADDONS_ZIP_FILENAME) \
		&& chown pi:pi -R $(INSTALL_DIR)/addons
 
$(ADDONS_ZIP):   
	cd $(DOWNLOAD_DIR) && wget $(LIB_PROVIDER)/$(ADDONS_ZIP_FILENAME)

$(RUNTIME_ZIP):
	cd $(DOWNLOAD_DIR) && wget $(LIB_PROVIDER)/$(RUNTIME_ZIP_FILENAME)

$(INSTALL_DIR):
	mkdir -p $(INSTALL_DIR)

$(ADDONS_DIR):
	mkdir -p $(ADDONS_DIR)

$(DOWNLOAD_DIR):
	mkdir -p $(DOWNLOAD_DIR)
