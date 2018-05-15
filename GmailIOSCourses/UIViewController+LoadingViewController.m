//
//  UIViewController+LoadingViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/14/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "UIViewController+LoadingViewController.h"

@implementation UIViewController (LoadingViewController)

- (void)showLoading:(UIViewController *)childVC containerView:(UIView *)container {
    [self addChildViewController:childVC];
    childVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:childVC.view];
    [childVC.view.topAnchor constraintEqualToAnchor:container.topAnchor].active = YES;
    [childVC.view.leadingAnchor constraintEqualToAnchor:container.leadingAnchor].active = YES;
    [childVC.view.trailingAnchor constraintEqualToAnchor:container.trailingAnchor].active = YES;
    [childVC.view.bottomAnchor constraintEqualToAnchor:container.bottomAnchor].active = YES;
    [childVC didMoveToParentViewController:self];
}

- (void)hideLoading:(UIViewController *)childVC {
    [childVC willMoveToParentViewController:nil];
    [childVC.view removeFromSuperview];
    [childVC removeFromParentViewController];
}
@end
