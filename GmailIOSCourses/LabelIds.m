//
//  LabelsIds.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "LabelIds.h"

@implementation LabelIds
-(instancetype)initWithData:(NSArray *)labelIds{
    self=[super init];
    if(self){
        self.tag=labelIds[0];
        self.category=labelIds[0];
        self.list=labelIds[0];
    }
    return self;
}
@end
