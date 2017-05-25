//
//  Sent+CoreDataProperties.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/24/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Sent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Sent (CoreDataProperties)

+ (NSFetchRequest<Sent *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *body;
@property (nullable, nonatomic, copy) NSString *snippet;
@property (nullable, nonatomic, copy) NSString *subject;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *messageID;
@property (nullable, nonatomic, copy) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
