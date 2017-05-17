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
    
    bool sub=false;
    bool fr=false;
    for(int i=0;i<message.payload.headers.count;i++){
        if(sub && fr){
            break;
        }
        if([[message.payload.headers[i] objectForKey:@"name"] isEqual:@"Subject"]){
            self.subject.text=[message.payload.headers[i]objectForKey:@"value"];
            [message setSubject:[message.payload.headers[i]objectForKey:@"value"]];
            sub=true;
        }else{
            if([[message.payload.headers[i] objectForKey:@"name"] isEqual:@"From"]){
                self.title.text=[message.payload.headers[i] objectForKey:@"value"];
                [message setFrom:[message.payload.headers[i]objectForKey:@"value"]];
                fr=true;
            }
        }
    }
    self.body.text=message.snippet;
   self.image.image=[[UIImage alloc]initWithContentsOfFile: destination];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
