
#import "InboxMessagesFetcher.h"
#import "Message.h"

@interface InboxMessagesFetcher () 
@property(strong,nonatomic)NSURLSession *session;
@end
static int maxResults=20;
@implementation InboxMessagesFetcher
- (instancetype)initWithData:(NSString*)accessToken {
    self=[super init];
    if(self) {
        self.accessToken=accessToken;
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString *)labelId nextPage:(NSString *)nextPageToken {
    NSString* serverAddressForReadMessages;
    if(nextPageToken!=nil) {
        serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/me/messages?pageToken=%@&maxResults=%d&labelIds=%@",nextPageToken,maxResults,labelId];
    } else {
        serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/me/messages?maxResults=%d&labelIds=%@",maxResults,labelId];
    }
    NSURL *url = [NSURL URLWithString:serverAddressForReadMessages];
    [[self.session dataTaskWithRequest:[self getRequest:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        callback(json);
    }] resume];
}

- (void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback {
    NSString* serverAddressForMessage=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/me/messages/%@?field=raw",messageID];
    NSURL *url = [NSURL URLWithString:serverAddressForMessage];
    [[self.session dataTaskWithRequest:[self getRequest:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        Message* message= [self createMessage:json];
        callback(message);
        ;
    }] resume];
}

- (NSMutableURLRequest*)getRequest:(NSURL*)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@",self.accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (Message *)createMessage:(NSDictionary *)message {
    Message *msg=[[Message alloc]initWithData:message];
    return msg;
}

@end
