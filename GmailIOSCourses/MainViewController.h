//
//  MainViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/30/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLRGmail.h"
#import "Coordinator.h"
#import "SendViewController.h"
@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic)Coordinator *coordinator;
@end
static NSString *myId=@"Id";
