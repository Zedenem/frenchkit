#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol API_ObjcBridging;

@interface TopRatedViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithAPI:(id<API_ObjcBridging>)api NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
