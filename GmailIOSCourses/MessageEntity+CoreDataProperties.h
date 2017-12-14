//
//  MessageEntity+CoreDataProperties.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 6/8/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "MessageEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageEntity (CoreDataProperties)

+ (NSFetchRequest<MessageEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *body;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, copy) NSString *messageID;
@property (nullable, nonatomic, copy) NSString *mimeType;
@property (nullable, nonatomic, copy) NSString *snippet;
@property (nullable, nonatomic, copy) NSString *subject;

@end

NS_ASSUME_NONNULL_END
