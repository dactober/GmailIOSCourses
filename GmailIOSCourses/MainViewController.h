//
//  MainViewController.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/30/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "Coordinator.h"
#import "SendViewController.h"
#import "SentMessagesViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

+ (instancetype)controllerWithCoordinator:(Coordinator *)coordinator delegate:(id<LGSideMenuDelegate>)delegate;
- (instancetype)initWithCoordinator:(Coordinator *)coordinator delegate:(id<LGSideMenuDelegate>)delegate;

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
static NSString *myIdForInbox = @"Id";
