//
//  MessagesList+CoreDataProperties.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/20/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "MessagesList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessagesList (CoreDataProperties)

+ (NSFetchRequest<MessagesList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *messageID;
@property (nullable, nonatomic, copy) NSString *threadID;

@end

NS_ASSUME_NONNULL_END
