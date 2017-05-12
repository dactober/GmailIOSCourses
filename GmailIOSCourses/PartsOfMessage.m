//
//  PartOfMessage.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "PartsOfMessage.h"
@implementation PartsOfMessage
-(instancetype)initWithData:(NSArray *)parts{
    self.parts=[NSMutableArray new];
    self=[super init];
    if(self){
        for(int i=0;i<[parts count];i++){
            self.part=[[PartOfMessage alloc]initWithData:parts[i]];
            [self.parts addObject:self.part];
        }
    }
    return self;
}
@end
