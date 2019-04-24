#import <dlfcn.h>
#import <objc/runtime.h>
#import <notify.h>
#import <substrate.h>
#import <libactivator/libactivator.h>

#define NSLog(...)

extern "C" const char * __progname;

extern "C" int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);

@interface GoogleAuthProUtilsActivator : NSObject
+ (id)sharedInstance;
- (void)RegisterActions;
@end

@implementation GoogleAuthProUtilsActivator
+ (id)sharedInstance
{
    __strong static id _sharedObject;
	if (!_sharedObject) {
		_sharedObject = [[self alloc] init];
	}
	return _sharedObject;
}
- (void)RegisterActions
{
    if (access("/usr/lib/libactivator.dylib", F_OK) == 0) {
	dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
	    if (Class la = objc_getClass("LAActivator")) {
			[[la sharedInstance] registerListener:(id<LAListener>)self forName:@"com.julioverne.googleauthpro.search"];
			[[la sharedInstance] registerListener:(id<LAListener>)self forName:@"com.julioverne.googleauthpro.open"];
		}
	}
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	return @"GoogleAuthPro";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	if([listenerName isEqualToString:@"com.julioverne.googleauthpro.search"]) {
		return @"Open Google Authenticator For Search";
	}
	return @"Open Google Authenticator";
}
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName
{
	if([listenerName isEqualToString:@"com.julioverne.googleauthpro.search"]) {
		[[UIPasteboard generalPasteboard] setData:[NSData dataWithBytes:" " length:1] forPasteboardType:@"com.julioverne.googleauthpro.search"];
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			SBSLaunchApplicationWithIdentifier(CFSTR("com.google.Authenticator"), NO);
		});
	} else {
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			SBSLaunchApplicationWithIdentifier(CFSTR("com.google.Authenticator"), NO);
		});
	}
}
@end


%group HooksSB

%end

@interface BrowserController : NSObject

@end
@interface TabDocument : NSObject
- (NSURL*)URL;
@end
%group HooksSafari
%hook BrowserController
- (void)updateTitleForTabDocument:(TabDocument*)tabDocument
{
	%orig;
	if(tabDocument) {
		NSURL* url = tabDocument.URL;
		if(url!=nil && [url host]!=nil) {
			NSString* hostSt = [url host];
			
			if([hostSt hasPrefix:@"www."]) {
				hostSt = [hostSt substringFromIndex:4];
			}
			if([hostSt hasPrefix:@"m."]) {
				hostSt = [hostSt substringFromIndex:2];
			}
			if([hostSt hasPrefix:@"login."]) {
				hostSt = [hostSt substringFromIndex:6];
			}
			if([hostSt hasPrefix:@"mobile."]) {
				hostSt = [hostSt substringFromIndex:7];
			}
			NSArray * compDomain = [hostSt componentsSeparatedByString:@"."];
			hostSt = [[compDomain firstObject] capitalizedString];
			[[UIPasteboard generalPasteboard] setData:[hostSt dataUsingEncoding:NSUTF8StringEncoding] forPasteboardType:@"com.julioverne.googleauthpro.search"];
		} else {
			[[UIPasteboard generalPasteboard] setData:[NSData data] forPasteboardType:@"com.julioverne.googleauthpro.search"];
		}
	}
}
%end
%end

%ctor
{
	if(!strcmp(__progname, "SpringBoard")) {
		%init(HooksSB);
		[[GoogleAuthProUtilsActivator sharedInstance] RegisterActions];
	} else {
		%init(HooksSafari);
	}
}


__attribute__((destructor)) static void finalize_()
{
	if(!strcmp(__progname, "SpringBoard")) {
		
	} else {
		//Closed Safari Process, clean search focused
		[[UIPasteboard generalPasteboard] setData:[NSData data] forPasteboardType:@"com.julioverne.googleauthpro.search"];
	}
}