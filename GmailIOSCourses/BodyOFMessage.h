//
//  BodyOFMessage.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BodyOFMessage : NSObject
@property(strong,nonatomic)NSString *data;
-(instancetype)initWithData:(NSDictionary *)body;
@end
