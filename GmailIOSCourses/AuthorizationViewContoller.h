//
//  ViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "MainViewController.h"
#import "GTLRGmail.h"
#import "Coordinator.h"
@interface AuthorizationViewContoller : UIViewController
@property (nonatomic, strong) GTLRGmailService *service;


@property(nonatomic,strong)MainViewController *mainViewController;
@end

