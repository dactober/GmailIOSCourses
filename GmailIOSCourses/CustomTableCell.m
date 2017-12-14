//
//  CustomTableCell.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/1/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "CustomTableCell.h"
#import "MessageEntity+CoreDataClass.h"
@implementation CustomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)customCellDataForInbox:(MessageEntity *)message {
    self.subject.text=message.subject;
    self.body.text=message.snippet;
    if([message.from containsString:@" <"]) {
        NSRange range = [message.from rangeOfString:@" <"];
        NSString *shortString = [message.from substringToIndex:range.location];
        self.title.text=shortString;
    } else {
        self.title.text=message.from;
    }
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm"];
    NSString *stringDate = [dateFormatter stringFromDate:message.date];
    self.date.text=stringDate;
    self.image.image=[UIImage imageNamed:@"non_existing_id"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
