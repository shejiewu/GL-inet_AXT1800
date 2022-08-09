#
# Copyright (C) 2016-2017 GitHub 
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=defaultsettings
PKG_VERSION:=1
PKG_RELEASE:=1
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/defaultsettings
  SECTION:=luci
  CATEGORY:=LuCI
  TITLE:=LuCI support for Default Settings
  PKGARCH:=all
  DEPENDS:=+luci-base +luci +luci-compat +@LUCI_LANG_zh-cn
endef

define Package/defaultsettings/description
        LuCI default settings and luci language support.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/defaultsettings/install
        $(INSTALL_DIR) $(1)/etc/uci-defaults
        $(INSTALL_BIN) ./files/zzz-default-settings $(1)/etc/uci-defaults/99-default-settings
        $(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
endef

$(eval $(call BuildPackage,defaultsettings))
