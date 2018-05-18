//
//  CalendarViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/16/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "CalendarViewController.h"
#import <CalendarView.h>
#import <NSDate+CalendarView.h>
#import <NSString+CalendarView.h>
#import <GTLRCalendar.h>
#import <Google/SignIn.h>

enum {
    kEventsSegment = 0,
    kAccessControlSegment = 1,
    kSettingsSegment = 2
};

@interface CalendarViewController ()<CalendarViewDelegate>
@property (strong, nonatomic) CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property(nonatomic, strong) GTLRCalendarService *calendarService;

@property(strong) GTLRCalendar_CalendarList *calendarList;
@property(strong) GTLRServiceTicket *calendarListTicket;
@property(strong) NSError *calendarListFetchError;

@property(strong) GTLRServiceTicket *editCalendarListTicket;

@property(strong) GTLRCalendar_Events *events;
@property(strong) GTLRServiceTicket *eventsTicket;
@property(strong) NSError *eventsFetchError;

@property(strong) GTLRCalendar_Acl *ACLs;
@property(strong) NSError *ACLsFetchError;

@property(strong) GTLRCalendar_Settings *settings;
@property(strong) NSError *settingsFetchError;

@property(strong) GTLRServiceTicket *editEventTicket;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarService = [GTLRCalendarService new];
    self.calendarService.authorizer = [GIDSignIn sharedInstance].currentUser.authentication.fetcherAuthorizer;
    self.calendarView = [[CalendarView alloc] initWithPosition:0 y:0];
    self.calendarView.selectionColor = [UIColor colorWithRed:0.203 green:0.666 blue:0.862 alpha:1.000];
    self.calendarView.fontHeaderColor = [UIColor colorWithRed:0.203 green:0.666 blue:0.862 alpha:1.000];
    [self.containerView addSubview:self.calendarView];
    self.title = @"Calendar";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self fetchCalendarList];
}

- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStyleDone target:self.delegate action:@selector(showLeftView)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)didChangeCalendarDate:(NSDate *)date {
    
}

- (void)fetchCalendarList {
    self.calendarList = nil;
    self.calendarListFetchError = nil;
    
    GTLRCalendarService *service = self.calendarService;
    
    GTLRCalendarQuery_CalendarListList *query = [GTLRCalendarQuery_CalendarListList query];
    query.minAccessRole = kGTLRCalendarMinAccessRoleOwner;
    
    self.calendarListTicket = [service executeQuery:query
                                  completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                      id calendarList,
                                                      NSError *callbackError) {
                                      // Callback
                                      self.calendarList = calendarList;
                                      self.calendarListFetchError = callbackError;
                                      self.calendarListTicket = nil;
                                      [self fetchSelectedCalendar];
                                      
                                  }];
}

- (void)fetchSelectedCalendar {
    self.events = nil;
    self.eventsFetchError = nil;
    
    self.ACLs = nil;
    self.ACLsFetchError = nil;
    
    self.settings = nil;
    self.settingsFetchError = nil;
    
    GTLRCalendarService *service = self.calendarService;
    
    GTLRCalendar_CalendarListEntry *selectedCalendar = self.calendarList.items.firstObject;
    if (selectedCalendar) {
        NSString *calendarID = selectedCalendar.identifier;
        
        // We will fetch the events for this calendar, the ACLs for this calendar,
        // and the user's settings, together in a single batch.
        GTLRBatchQuery *batch = [GTLRBatchQuery batchQuery];
        
        GTLRCalendarQuery_EventsList *eventsQuery =
        [GTLRCalendarQuery_EventsList queryWithCalendarId:calendarID];
        eventsQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                        GTLRCalendar_Events *events, NSError *callbackError) {
            self.events = events;
            self.eventsFetchError = callbackError;
        };
        [batch addQuery:eventsQuery];
        
        GTLRCalendarQuery_AclList *aclQuery = [GTLRCalendarQuery_AclList queryWithCalendarId:calendarID];
        aclQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket, GTLRCalendar_Acl *acls,
                                     NSError *callbackError) {
            self.ACLs = acls;
            self.ACLsFetchError = callbackError;
        };
        [batch addQuery:aclQuery];
        
        GTLRCalendarQuery_SettingsList *settingsQuery = [GTLRCalendarQuery_SettingsList query];
        settingsQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                          GTLRCalendar_Settings *settings, NSError *callbackError) {
            self.settings = settings;
            self.settingsFetchError = callbackError;
        };
        [batch addQuery:settingsQuery];
        
        self.eventsTicket = [service executeQuery:batch
                                completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                    GTLRBatchResult *batchResult,
                                                    NSError *callbackError) {
                                    // Callback
                                    //
                                    // For batch queries with successful execution,
                                    // the result is a GTLRBatchResult object
                                    //
                                    // At this point, the query completion blocks
                                    // have already been called
                                    self.eventsTicket = nil;
                                    
                                }];
    }
}

@end
