//
//  SettingsTableViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/17/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizationViewContoller.h"
#import "Coordinator.h"
@interface SettingsTableViewController : UITableViewController
@property (strong,nonatomic)Coordinator *coordinator;
@property (strong,nonatomic)AuthorizationViewContoller *auth;
@end
