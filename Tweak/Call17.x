#import "Call17.h"

const NSUInteger kPHAudioControlsButtonTypeContacts = 6;

%hook PHAudioCallViewController

- (void)viewDidLoad {
	%orig;

	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	infoButton.tintColor = [UIColor whiteColor];

	[self.view addSubview:infoButton];
	infoButton.translatesAutoresizingMaskIntoConstraints = NO;
	[NSLayoutConstraint activateConstraints:@[
		[infoButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
		[infoButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
		[infoButton.widthAnchor constraintEqualToConstant:30],
		[infoButton.heightAnchor constraintEqualToConstant:30]
	]];

	[infoButton addTarget:self action:@selector(customInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

%new
- (void)customInfoButtonTapped:(UIButton *)sender {
	id contactsButton = [self findContactsButton:self.view];
	if (contactsButton) {
		[contactsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
}

%new
- (id)findContactsButton:(UIView *)view {
	id controlsView = [self findControlsView:view];
	if (controlsView) {
		if ([controlsView respondsToSelector:@selector(buttonsArray)]) {
			NSArray *buttonsArray = [controlsView performSelector:@selector(buttonsArray)];

			for (id button in buttonsArray) {
				if (!button) {
					continue;
				}

				if ([button isKindOfClass:[%c(PHAudioControlsButton) class]]) {
					NSUInteger controlType = 0;
					@try {
						controlType = [(PHAudioControlsButton *)button controlType];
					}
					@catch (NSException *exception) {
						continue;
					}
					if (controlType == kPHAudioControlsButtonTypeContacts) {
						return button;
					}
				}
			}
		}
	}
	return nil;
}

%new
- (id)findControlsView:(UIView *)view {
	for (UIView *subview in view.subviews) {
		if ([subview isKindOfClass:[%c(PHAudioCallControlsView) class]]) {
			return subview;
		}

		id found = [self findControlsView:subview];
		if (found) {
			return found;
		}
	}
	return nil;
}

%end
