//
//  AppDelegate.h
//  MenuSystem
//
//  Created by Stadnik Dmitry on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property NSString *sessionId;

- (void)registerWithName:(NSString *)name password:(NSString *)password email:(NSString *)email;
- (void)loginWithName:(NSString *)name password:(NSString *)password;
- (void)logout;

@end
