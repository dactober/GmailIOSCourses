//
//  CalendarViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/16/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

@interface CalendarViewController : UIViewController
@property (nonatomic, weak) id<LGSideMenuDelegate> delegate;
@end
