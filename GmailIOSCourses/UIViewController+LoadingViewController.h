//
//  UIViewController+LoadingViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/14/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadingViewController)
- (void)showLoading:(UIViewController *)childVC containerView:(UIView *)container;
- (void)hideLoading:(UIViewController *)childVC;
@end
