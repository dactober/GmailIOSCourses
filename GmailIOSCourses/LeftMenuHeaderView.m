//
//  LeftMenuHeaderView.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/15/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "LeftMenuHeaderView.h"
#import <Google/SignIn.h>

@interface LeftMenuHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LeftMenuHeaderView

+ (instancetype)header {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LeftMenuHeaderView" owner:self options:nil];
    LeftMenuHeaderView *header = (LeftMenuHeaderView *)array.firstObject;
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 10;
    self.nameLabel.text = [GIDSignIn sharedInstance].currentUser.profile.name;
    self.emailLabel.text = [GIDSignIn sharedInstance].currentUser.profile.email;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
