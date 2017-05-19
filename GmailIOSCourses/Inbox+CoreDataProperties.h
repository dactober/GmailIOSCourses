//
//  Inbox+CoreDataProperties.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/20/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Inbox+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Inbox (CoreDataProperties)

+ (NSFetchRequest<Inbox *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *body;
@property (nullable, nonatomic, copy) NSString *subject;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *snippet;

@end

NS_ASSUME_NONNULL_END
