//
//  Message.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/6/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payload.h"
#import "LabelIds.h"
@interface Message : NSObject
@property(nonatomic,strong)NSString *sizeEstimate;
@property(nonatomic,strong)LabelIds *labelIDs;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *snippet;
@property(nonatomic,strong)NSString *internalDate;
@property(nonatomic,strong)NSString *historyID;
@property(nonatomic,strong)Payload *payload;
@property(nonatomic,strong)NSString *threadId;
@property(nonatomic,strong)NSString* subject;
@property(nonatomic,strong)NSString *from;
-(instancetype)initWithData:(NSDictionary*) message;
-(NSString *)decodedMessage;
@end
