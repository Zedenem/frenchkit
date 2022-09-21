#import "SceneDelegate.h"
#import "frenchkit-Swift.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  UIWindowScene *windowScene = (UIWindowScene *)scene;
  
  UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
  window.rootViewController = [[TabBarController alloc] init];
  self.window = window;
  
  [window makeKeyAndVisible];
}
- (void)sceneDidDisconnect:(UIScene *)scene {}
- (void)sceneDidBecomeActive:(UIScene *)scene {}
- (void)sceneWillResignActive:(UIScene *)scene {}
- (void)sceneWillEnterForeground:(UIScene *)scene {}
- (void)sceneDidEnterBackground:(UIScene *)scene {}

@end
