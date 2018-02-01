//
//  SettingsTableViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/17/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AuthorizationViewContoller.h"
#import "CreaterContextForMessages.h"
@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self.delegate logOut];
    }
}

@end
