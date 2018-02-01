//
//  LabelsIds.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "LabelIds.h"

@implementation LabelIds
- (instancetype)initWithData:(NSArray *)labelIds {
    self = [super init];
    if (self) {
        // self.tag=labelIds[0];
        //    self.category=labelIds[1];
        self.list = [labelIds lastObject];
    }
    return self;
}
@end
