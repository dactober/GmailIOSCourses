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
@class Sent;
@interface SendViewController : UIViewController
-(void)setData:(Coordinator*)coordinator flag:(bool)flag message:(Inbox*)message;
-(void)setDataForSent:(Coordinator*)coordinator flag:(bool)flag message:(Sent*)message;
@property(nonatomic,strong)Coordinator* coordinator;
@end
