//
//  PartOfMessage.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "PartOfMessage.h"

@implementation PartOfMessage
-(instancetype)initWithData:(NSDictionary *)part{
    self=[super init];
    if(self){
        self.body=[[BodyOFMessage alloc]initWithData:[part objectForKey:@"body"]];
    }
    return self;
}

@end
