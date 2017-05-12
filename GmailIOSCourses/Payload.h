//
//  Payload.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/11/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BodyOFMessage.h"
#import "PartsOfMessage.h"
@interface Payload : NSObject
@property(nonatomic,strong)NSString* mimeType;
@property(nonatomic,strong)NSString* fileName;
@property(nonatomic,strong)NSArray* headers;
@property(nonatomic,strong)BodyOFMessage* body;
@property(nonatomic,strong)PartsOfMessage *parts;
-(instancetype)initWithData:(NSDictionary *)payload;
@end
