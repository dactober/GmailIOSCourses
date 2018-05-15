//
//  DriveTableViewCell.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/4/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "DriveTableViewCell.h"

@interface DriveTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation DriveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRemoveButtonHidden:(BOOL)hidden {
    self.removeButton.hidden = hidden;
}

- (IBAction)pressedRemoveFile:(id)sender {
    if (self.removeAction) {
        self.removeAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
