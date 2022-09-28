#import "UIColor+DesignSystem.h"

@implementation UIColor (DesignSystem)

+ (UIColor *)barBackgroundColor {
  return [UIColor tertiarySystemBackgroundColor];
}

+ (UIColor *)listItemOddBackgroundColor {
  return [UIColor secondarySystemBackgroundColor];
}

+ (UIColor *)primaryBackgroundColor {
  return [UIColor systemBackgroundColor];
}

+ (UIColor *)selectedTintColor {
  return [UIColor labelColor];
}

+ (UIColor *)unselectedTintColor {
  return [UIColor tertiaryLabelColor];
}

@end
