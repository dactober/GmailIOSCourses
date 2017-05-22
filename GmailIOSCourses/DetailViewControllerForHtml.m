//
//  DetailViewControllerForHtml.m
//  
//
//  Created by Aleksey Drachyov on 5/13/17.
//
//

#import "DetailViewControllerForHtml.h"
#import "Coordinator.h"
#import "SendViewController.h"
#import "Inbox+CoreDataClass.h"
#import "Message.h"
@interface DetailViewControllerForHtml ()
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UIWebView *body;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,strong)Coordinator *coordinator;
@property(nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation DetailViewControllerForHtml

- (void)viewDidLoad {
    [super viewDidLoad];
    self.body.delegate=self;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.subject.text=self.inboxMessage.subject;
    if([self.inboxMessage.from containsString:@" <"]){
        
        NSRange range = [self.inboxMessage.from rangeOfString:@" <"];
        NSString *shortString = [self.inboxMessage.from substringToIndex:range.location];
        
        self.from.text=shortString;
        
        
    }else{
        self.from.text=self.inboxMessage.from;
    }
    self.activity.hidden=NO;
    [self.activity startAnimating];
    
    [self.body loadHTMLString:self.inboxMessage.body baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activity stopAnimating];
  self.activity.hidden=YES;
}
-(void)setData:(Inbox *)inboxMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext *)context{
    self.coordinator=coordinator;
    self.inboxMessage=inboxMessage;
    self.context=context;
}
- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:true message:self.inboxMessage];
    [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)delete:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Inbox"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", self.inboxMessage.messageID]];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    for (NSManagedObject *managedObject in results)
    {
        [self.context deleteObject:managedObject];
    }
    [Message deleteMessage:self.coordinator messageID:self.inboxMessage.messageID  callback:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

@end
