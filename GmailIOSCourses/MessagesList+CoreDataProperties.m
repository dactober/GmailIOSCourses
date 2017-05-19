//
//  MessagesList+CoreDataProperties.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/20/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "MessagesList+CoreDataProperties.h"

@implementation MessagesList (CoreDataProperties)

+ (NSFetchRequest<MessagesList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MessagesList"];
}

@dynamic messageID;
@dynamic threadID;

@end
