include $(THEOS)/makefiles/common.mk

SUBPROJECTS += googleauthprohooks
SUBPROJECTS += googleauthproutils
SUBPROJECTS += googleauthprosettings

include $(THEOS_MAKE_PATH)/aggregate.mk

all::
	
