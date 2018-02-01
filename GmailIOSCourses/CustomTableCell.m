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
    [self fillTitleLabel:message.from];
    self.subject.text = message.subject;
    self.body.text = message.snippet;
    [self fillDateLabel:message.date];
    self.image.image = [UIImage imageNamed:@"non_existing_id"];
}

- (void)fillTitleLabel:(NSString *)from {
    if ([from containsString:@" <"]) {
        NSRange range = [from rangeOfString:@" <"];
        NSString *shortString = [from substringToIndex:range.location];
        self.title.text = shortString;
    } else {
        self.title.text = from;
    }
}

- (void)fillDateLabel:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    NSString *stringMessageDate = [dateFormatter stringFromDate:date];
    NSString *stringCurrentDate = [dateFormatter stringFromDate:currentDate];
    if ([stringCurrentDate isEqualToString:stringMessageDate]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *stringDate = [dateFormatter stringFromDate:date];
        self.date.text = stringDate;
    } else {
        self.date.text = stringMessageDate;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
