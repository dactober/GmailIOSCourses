//
//  GMLeftMenuViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/2/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMLeftMenuViewController : UIViewController
+ (instancetype)leftMenuWithItems:(NSArray *)items;
- (instancetype)initWithItems:(NSArray *)items;
@end
