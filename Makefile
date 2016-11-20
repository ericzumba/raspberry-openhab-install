.PHONY: start home gpio runtime addons
VERSION:=1.8.3
DOWNLOAD_DIR:=tmp

RUNTIME_ZIP_FILENAME:=distribution-$(VERSION)-runtime.zip
RUNTIME_ZIP:=$(DOWNLOAD_DIR)/$(RUNTIME_ZIP_FILENAME)

ADDONS_ZIP_FILENAME:=distribution-$(VERSION)-addons.zip
ADDONS_ZIP:=$(DOWNLOAD_DIR)/$(ADDONS_ZIP_FILENAME)

LIB_PROVIDER:=https://bintray.com/artifact/download/openhab/bin

GPIO_LIB_FILENAME:=org.openhab.io.gpio-1.8.3.jar
GPIO_LIB_PROVIDER:=http://jcenter.bintray.com/org/openhab/io/org.openhab.io.gpio/1.8.3
GPIO_LIB:=$(DOWNLOAD_DIR)/$(GPIO_LIB_FILENAME)

GPIO_BINDING_FILENAME:=org.openhab.binding.gpio-1.8.0.jar
GPIO_BINDING_PROVIDER:=http://jcenter.bintray.com/org/openhab/binding/org.openhab.binding.gpio/1.8.0
GPIO_BINDING:=$(DOWNLOAD_DIR)/$(GPIO_BINDING_FILENAME)

INSTALL_DIR:=/opt/openhab
ADDONS_DIR:=$(INSTALL_DIR)/addons

CONFIG_DIR:=.

start: home
	chown -R pi:pi $(INSTALL_DIR)
	$(INSTALL_DIR)/start.sh

home: gpio 
	cp $(CONFIG_DIR)/sitemaps/default.sitemap $(INSTALL_DIR)/configurations/sitemaps/default.sitemap
	cp $(CONFIG_DIR)/items/home.items $(INSTALL_DIR)/configurations/items/home.items
	cp $(CONFIG_DIR)/openhab.cfg $(INSTALL_DIR)/configurations/openhab.cfg

gpio: runtime $(GPIO_LIB) $(GPIO_BINDING)
	cp $(GPIO_LIB) $(ADDONS_DIR)
	cp $(GPIO_BINDING) $(ADDONS_DIR)

runtime: $(RUNTIME_ZIP) $(INSTALL_DIR)
	cp $(RUNTIME_ZIP) $(INSTALL_DIR)/$(RUNTIME_ZIP_FILENAME) \
		&& cd $(INSTALL_DIR)  && unzip -o $(RUNTIME_ZIP_FILENAME)

addons: runtime $(ADDONS_ZIP) $(ADDONS_DIR)
	cp $(ADDONS_ZIP) $(INSTALL_DIR)/addons/$(ADDONS_ZIP_FILENAME) \
		&& cd $(ADDONS_DIR) && unzip -o $(ADDONS_ZIP_FILENAME)

$(GPIO_LIB): $(DOWNLOAD_DIR)
	cd $(DOWNLOAD_DIR) && wget $(GPIO_LIB_PROVIDER)/$(GPIO_LIB_FILENAME)

$(GPIO_BINDING_LIB): $(DOWNLOAD_DIR)
	cd $(DOWNLOAD_DIR) && wget $(GPIO_BINDING_PROVIDER)/$(GPIO_BINDING_FILENAME)

$(RUNTIME_ZIP): $(DOWNLOAD_DIR)
	cd $(DOWNLOAD_DIR) && wget $(LIB_PROVIDER)/$(RUNTIME_ZIP_FILENAME)
 
$(ADDONS_ZIP): $(DOWNLOAD_DIR)
	cd $(DOWNLOAD_DIR) && wget $(LIB_PROVIDER)/$(ADDONS_ZIP_FILENAME)

$(INSTALL_DIR):
	mkdir -p $(INSTALL_DIR)

$(ADDONS_DIR):
	mkdir -p $(ADDONS_DIR)

$(DOWNLOAD_DIR):
	mkdir -p $(DOWNLOAD_DIR)

.PHONY: zip
zip: $(RUNTIME_ZIP)
