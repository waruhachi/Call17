#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface UIControlTargetAction : NSObject {
	UIAction *_actionHandler;
	__unsafe_unretained id *_target;
	SEL _action;
	NSUInteger _eventMask;
}
@property (nonatomic) BOOL cancelled;
- (id)description;
@end

@interface PHBottomBarButton : UIButton
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

@interface PHAbstractCallParticipantLabelView : UIView
@end

@interface PHSingleCallParticipantLabelView : PHAbstractCallParticipantLabelView
@end

@interface PHCallParticipantsView : UIView
@property (atomic, strong, readwrite) PHSingleCallParticipantLabelView *singleCallLabelView;
@end

@interface PHAudioCallControlsView : UIView
@end

@interface PHAudioControlsButton : UIButton
@property (nonatomic, strong) NSMutableArray *_targetActions;
@property (nonatomic, assign, readwrite) NSUInteger controlType;
@end

@interface PHAudioCallViewController : UIViewController
- (id)findContactsButton:(UIView *)view;
- (id)findControlsView:(UIView *)view;
- (void)customInfoButtonTapped:(UIButton *)sender;
@end
