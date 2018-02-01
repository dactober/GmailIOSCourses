//
//  DetailViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//
@class Coordinator;
@class MessageEntity;

#import <UIKit/UIKit.h>
#import "CustomTableCell.h"
#import "CoreData/CoreData.h"
@class Message;
@interface DetailViewController : UIViewController
@property(weak, nonatomic) IBOutlet UILabel *subject;
@property(weak, nonatomic) IBOutlet UILabel *from;
@property(weak, nonatomic) IBOutlet UILabel *body;
@property(strong, nonatomic) MessageEntity *messageModel;
@property(strong, nonatomic) Message *message;
- (void)setData:(MessageEntity *)inboxMessage coordinator:(Coordinator *)coordinator context:(NSManagedObjectContext *)context;

@end
