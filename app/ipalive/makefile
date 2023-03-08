include $(TOPDIR)/rules.mk

PKG_NAME:=ipalive
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/ipalive
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=IpAlive
  DEPENDS:=+lua +libuci-lua +luci-lib-jsonc
endef

define Package/ipalive/description
  This is a simple Lua application packaged for OpenWrt.
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)/files
  cp -R ./files/* $(PKG_BUILD_DIR)/files/
endef

define Build/Compile
endef

define Package/ipalive/install
  $(INSTALL_DIR) $(1)/usr/lib/lua
  $(CP) $(PKG_BUILD_DIR)/files/lua_app.lua $(1)/usr/lib/lua/

  $(INSTALL_DIR) $(1)/www/luci-static/resources
  $(CP) $(PKG_BUILD_DIR)/files/ipalive.htm $(1)/www/luci-static/resources/

  $(INSTALL_DIR) $(1)/etc/config
  $(INSTALL_CONF) $(PKG_BUILD_DIR)/files/ipalive.config $(1)/etc/config/ipalive

  $(INSTALL_DIR) $(1)/etc/init.d
  $(INSTALL_BIN) $(PKG_BUILD_DIR)/files/ipalive $(1)/etc/init.d/
endef

$(eval $(call BuildPackage,ipalive))