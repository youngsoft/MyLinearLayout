//
//  AppDelegate.m
//  MyLayout
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyLayout.h"

@interface AppDelegate ()

@end




@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //默认的布局视图的padding是会叠加安全区的值的，因此你可以在这里设置为UIRectEdgeNone，让所有布局视图的padding不叠加安全区。
   //MyBaseLayout.appearance.insetsPaddingFromSafeArea = UIRectEdgeNone;
        
    //this place add the ui template size dime
    [MyDimeScale setUITemplateSize:CGSizeMake(375, 667)];
        
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
        
    ViewController *vc = [[ViewController alloc] init];
   
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
        
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    
    //为了测试使用。主要用于方便通过present出来的VC返回用。
    CGPoint pt =  [touches.anyObject locationInView:self.window];
    
    if (pt.y < 20 && pt.x > 0 && pt.x < 100)
    {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
