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
@property(strong, nonatomic) Coordinator *coordinator;
@end

@implementation SettingsTableViewController

+ (instancetype)controllerWithCoordinator:(Coordinator *)coordinator {
    return [[self alloc] initWithCoordinator:coordinator];
}

- (instancetype)initWithCoordinator:(Coordinator *)coordinator {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"Settings"];
    if (self) {
        self.coordinator = coordinator;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self.delegate logOut];
    }
}

@end
