//
//  CustomTableCell.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/1/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell
static bool sub=false;
static bool fr=false;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)customCellData:(Message *)message{
    sub=false;
    fr=false;
    self.headers=[message.payload objectForKey:@"headers"];
    for(int i=0;i<self.headers.count;i++){
        if(sub && fr){
            break;
        }
        if([[self.headers[i] objectForKey:@"name"] isEqual:@"Subject"]){
            self.subject.text=[self.headers[i] objectForKey:@"value"];
            sub=true;
        }else{
            if([[self.headers[i] objectForKey:@"name"] isEqual:@"From"]){
                self.title.text=[self.headers[i] objectForKey:@"value"];
                fr=true;
            }
        }
    }
    self.body.text=message.snippet;
   
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
