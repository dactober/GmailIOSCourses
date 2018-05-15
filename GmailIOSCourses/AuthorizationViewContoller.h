//
//  ViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRGmail.h>

@interface AuthorizationViewContoller : UIViewController<GIDSignInDelegate, GIDSignInUIDelegate>
@property(nonatomic, strong) IBOutlet GIDSignInButton *signInButton;

@property(nonatomic, strong) GTLRGmailService *service;

@end
