//
//  DriveViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/3/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLRDrive.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

@interface DriveViewController : UIViewController
+ (instancetype)controllerWithService:(GTLRDriveService *)service delegate:(id<LGSideMenuDelegate>)delegate;
- (instancetype)initWithService:(GTLRDriveService *)service delegate:(id<LGSideMenuDelegate>)delegate;
@end
