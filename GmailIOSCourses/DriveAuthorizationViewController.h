//
//  DriveAuthorizationViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/3/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

@interface DriveAuthorizationViewController : UIViewController

- (instancetype)initWithMenuController:(LGSideMenuController *)sideMenu;
+(instancetype)controllerWithMenuController:(LGSideMenuController *)sideMenu;
@property (nonatomic, strong) LGSideMenuController *sideMenu;
@end
