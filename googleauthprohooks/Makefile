include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoogleAuthPro
GoogleAuthPro_OBJCC_FILES = /mnt/d/codes/googleauthpro/googleauthprohooks/Tweak.xm
GoogleAuthPro_FRAMEWORKS = UIKit CydiaSubstrate
GoogleAuthPro_PRIVATE_FRAMEWORKS = Preferences
GoogleAuthPro_LDFLAGS = -Wl,-segalign,0x4000

export ARCHS = armv7 arm64
GoogleAuthPro_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
