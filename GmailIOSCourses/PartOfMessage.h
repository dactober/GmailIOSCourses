//
//  PartOfMessage.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BodyOFMessage.h"
@interface PartOfMessage : NSObject
-(instancetype)initWithData:(NSDictionary *)part;
@property (strong,nonatomic)NSString *mimeType;
@property(nonatomic,strong)BodyOFMessage* body;
@end
