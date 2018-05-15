//
//  WebLinkViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/14/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebLinkViewController : UIViewController

- (instancetype)initWithRequest:(NSURLRequest *)request;
+ (instancetype)controllerWithRequest:(NSURLRequest *)request;

@end
