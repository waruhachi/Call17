# FLEX Explorer Window Level Fix

## Problem
The FLEX explorer was not showing on the current call screen because it was appearing behind the call interface due to window level ordering. iOS call screens run at very high window levels, causing the FLEX explorer window to be rendered beneath them.

## Root Cause
- Call screens in iOS use high window levels (around `UIWindowLevelAlert` or higher)
- FLEX's default window level is `UIWindowLevelNormal` 
- This causes FLEX to appear behind system UI elements like call screens

## Solution Implemented
Modified the `showFLEXExplorer()` function in `Tweak/Call17.x` to:

1. **Show the FLEX explorer** using the standard method
2. **Locate the FLEX window** using multiple fallback approaches:
   - Try `explorerWindow` method if available
   - Try getting window from `explorerViewController.view.window`
   - Fallback to searching all windows for FLEX-related class names
3. **Set higher window level** to `UIWindowLevelAlert + 1` to ensure it appears above call screens

## Code Changes
```objc
// After showing FLEX explorer
UIWindow *flexWindow = nil;

// Try different methods to get the FLEX window
if ([flexManager respondsToSelector:@selector(explorerWindow)]) {
    flexWindow = [flexManager explorerWindow];
} else if ([flexManager respondsToSelector:@selector(explorerViewController)]) {
    id explorerVC = [flexManager explorerViewController];
    if (explorerVC && [explorerVC respondsToSelector:@selector(view)]) {
        UIView *view = [explorerVC view];
        flexWindow = view.window;
    }
}

// Fallback: search through all windows for FLEX window
if (!flexWindow) {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        NSString *windowClass = NSStringFromClass([window class]);
        if ([windowClass containsString:@"FLEX"] || 
            [windowClass containsString:@"Explorer"]) {
            flexWindow = window;
            break;
        }
    }
}

// Set the window level to appear above call screen
if (flexWindow) {
    flexWindow.windowLevel = UIWindowLevelAlert + 1;
}
```

## Window Level Hierarchy
- `UIWindowLevelNormal` = 0 (regular app windows)
- `UIWindowLevelAlert` = 2000 (system alerts, call screens)
- `UIWindowLevelAlert + 1` = 2001 (our FLEX window level)

## Result
The FLEX explorer should now appear on top of the call screen interface, allowing developers to inspect the call interface hierarchy and debug call-related functionality.

## Build Requirements
- Requires Theos build system
- Requires access to FLEX library (`libFLEX.dylib`)
- Requires jailbroken iOS device for installation