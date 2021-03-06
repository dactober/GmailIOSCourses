//
//  CustomTableCell.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/1/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface CustomTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property(strong,nonatomic)NSDictionary *subjectOfMessage;
@property (strong,nonatomic)NSDictionary *from;
@property(strong,nonatomic)NSArray *headers;
-(void)customCellData:(Message *)message;
@end
