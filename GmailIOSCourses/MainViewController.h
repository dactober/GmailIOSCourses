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
#import "SettingsTableViewController.h"
#import "SearchViewController.h"
@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsControllerForList;
@property(nonatomic,strong)SettingsTableViewController* settingsViewController;
@property(nonatomic,strong)SearchViewController *searchViewController;
@property (strong,nonatomic)Coordinator *coordinator;
@end
static NSString *myId=@"Id";
