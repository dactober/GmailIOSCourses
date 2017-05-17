//
//  CustomTableCell.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/1/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell
const NSString* destination=@"/Users/alekseydrachyov/Documents/work/GmailIOSCourses/GmailIOSCourses/GmailIOSCourses/non_existing_id.png";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)customCellData:(Message *)message{
    
    
    self.subject.text=message.subject;
    self.body.text=message.snippet;
    self.title.text=message.from;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E d MMM yyyy HH:mm:ss Z"];
    NSString *stringDate = [dateFormatter stringFromDate:message.date];
    self.date.text=stringDate;
   self.image.image=[[UIImage alloc]initWithContentsOfFile: destination];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
