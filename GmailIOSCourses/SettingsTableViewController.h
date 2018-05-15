//
//  SettingsTableViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/17/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"

@protocol SettingsTableViewControllerDelegate
- (void)logOut;
@end

@interface SettingsTableViewController : UITableViewController

+ (instancetype)controllerWithCoordinator:(Coordinator *)coordinator;
- (instancetype)initWithCoordinator:(Coordinator *)coordinator;

@property(nonatomic, weak) id<SettingsTableViewControllerDelegate> delegate;
@end
