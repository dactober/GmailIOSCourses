//
//  DetailViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableCell.h"
#import "Message.h"
@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (strong,nonatomic) CustomTableCell *cell;
@property (strong,nonatomic)Message *message;
-(void)setData:(Message *)message;

@end
