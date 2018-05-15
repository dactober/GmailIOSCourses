//
//  DriveTableViewCell.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/4/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);
@interface DriveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, copy) ActionBlock removeAction;
@property (nonatomic, copy) ActionBlock downloadAction;

- (void)setRemoveButtonHidden:(BOOL)hidden;
@end
