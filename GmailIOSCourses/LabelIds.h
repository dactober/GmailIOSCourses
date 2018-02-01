//
//  LabelsIds.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelIds : NSObject
@property(strong, nonatomic) NSString *tag;
@property(strong, nonatomic) NSString *category;
@property(strong, nonatomic) NSString *list;
- (instancetype)initWithData:(NSArray *)labelIds;
@end
