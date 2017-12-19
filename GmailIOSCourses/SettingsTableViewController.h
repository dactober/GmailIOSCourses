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
@property (nonatomic,strong) id <SettingsTableViewControllerDelegate> delegate;
@property (strong,nonatomic)Coordinator *coordinator;
@end
