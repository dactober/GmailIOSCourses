//
//  Payload.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/11/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Payload.h"

@implementation Payload
-(instancetype)initWithData:(NSDictionary *)payload{
    self=[super init];
    if(self){
        self.mimeType= [payload objectForKey:@"mimeType"];
        self.body=[[BodyOFMessage alloc] initWithData:[payload objectForKey:@"body"]];
        self.fileName=[payload objectForKey:@"fileName"];
        self.headers=[payload objectForKey:@"headers"];
        self.parts=[payload objectForKey:@"parts"];
    }
    return self;
}
@end
