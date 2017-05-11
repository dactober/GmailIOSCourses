//
//  Message.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/6/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic,strong)NSString *sizeEstimate;
@property(nonatomic,strong)NSDictionary *labelsIDs;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *snippet;
@property(nonatomic,strong)NSString *internalDate;
@property(nonatomic,strong)NSString *historyID;
@property(nonatomic,strong)NSDictionary *payload;
@property(nonatomic,strong)NSString *threadId;
@property (nonatomic,strong)NSArray *parts;
-(instancetype)initWithData:(NSDictionary*) message;
-(NSString *)decodeMessage;
@end
