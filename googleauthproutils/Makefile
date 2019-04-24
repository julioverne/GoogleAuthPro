include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoogleAuthProUtils
GoogleAuthProUtils_OBJCC_FILES = /mnt/d/codes/googleauthpro/googleauthproutils/Tweak.xm
GoogleAuthProUtils_FRAMEWORKS = UIKit CydiaSubstrate
GoogleAuthProUtils_PRIVATE_FRAMEWORKS = BackBoardServices SpringBoardServices
GoogleAuthProUtils_LDFLAGS = -Wl,-segalign,0x4000

export ARCHS = armv7 arm64
GoogleAuthProUtils_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
