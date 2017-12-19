//
//  ViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewController.h"
@interface AuthorizationViewContoller : NSObject <SettingsTableViewControllerDelegate>
- (instancetype)initWithWindow:(UIWindow *)window;
- (void)addAuthorizationViewController;
@end

