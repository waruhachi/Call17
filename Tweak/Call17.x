#import "Call17.h"

static void showFLEXExplorer() {
	NSString *dylibPath = jbroot(@"/Library/MobileSubstrate/DynamicLibraries/libFLEX.dylib");

	dlopen(dylibPath.UTF8String, RTLD_NOW);

	Class flexManagerClass = objc_getClass("FLEXManager");
	if (flexManagerClass) {
		id flexManager = [flexManagerClass sharedManager];
		if (flexManager && [flexManager respondsToSelector:@selector(isHidden)] && [flexManager isHidden]) {
			[flexManager showExplorer];
		}
	}
}

%hook PHInCallRootViewController

- (void)viewDidAppear:(BOOL)animated {
	%orig;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		showFLEXExplorer();
	});
}

%end

%hook ICSCallDisplayController

- (void)viewDidAppear:(BOOL)animated {
	%orig;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		showFLEXExplorer();
	});
}

%end

%hook ICSApplicationDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
	%orig;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		showFLEXExplorer();
	});
}

%end

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
	%orig;

	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if ([bundleIdentifier isEqualToString:@"com.apple.InCallService"]) {
		NSString *className = NSStringFromClass([self class]);
		if ([className containsString:@"Call"] || [className containsString:@"InCall"] || [className containsString:@"Phone"]) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				showFLEXExplorer();
			});
		}
	}
}

%end
