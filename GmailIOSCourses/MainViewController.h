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
@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong)SentMessagesViewController *sentMessagesViewController;
@property (strong,nonatomic)Coordinator *coordinator;
@end
static NSString *myIdForInbox=@"Id";
