//
//  ViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationViewContoller : NSObject
-(void)logOut:(NSURL*)url;
- (instancetype)initWithData:(UIWindow *)window;

- (void)createViewController;
@end

