//
//  BodyOFMessage.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BodyOFMessage.h"

@implementation BodyOFMessage
long size;
-(instancetype)initWithData:(NSDictionary *)body{
    self=[super init];
    if(self){
        self.data=[body objectForKey:@"data"];
        size=[body objectForKey:@"size"];
    }
    return self;
}
@end
