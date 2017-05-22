//
//  SendViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"
@class Inbox;
@interface SendViewController : UIViewController
-(void)setData:(Coordinator*)coordinator flag:(bool)flag message:(Inbox*)message;
@property(nonatomic,strong)Coordinator* coordinator;
@end
