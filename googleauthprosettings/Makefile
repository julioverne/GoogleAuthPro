include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = GoogleAuthPro
GoogleAuthPro_FILES = /mnt/d/codes/googleauthpro/googleauthprosettings/GoogleAuthProController.mm
GoogleAuthPro_INSTALL_PATH = /Library/PreferenceBundles
GoogleAuthPro_FRAMEWORKS = UIKit QuartzCore CoreGraphics MessageUI Social Twitter
GoogleAuthPro_PRIVATE_FRAMEWORKS = Preferences
GoogleAuthPro_CFLAGS = -fobjc-arc
GoogleAuthPro_LDFLAGS = -Wl,-segalign,4000
GoogleAuthPro_ARCHS = armv7 arm64
export ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/bundle.mk
