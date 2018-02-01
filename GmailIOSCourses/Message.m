//
//  Message.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/6/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Message.h"
#import "Coordinator.h"
@interface Message ()
@property(nonatomic, strong) NSDictionary *mimeTypeMapping;
@end

typedef NS_ENUM(NSInteger, MimeType) {
    mimeTypeRelated,
    mimeTypeAlternative,
    mimeTypeMixed,
    mimeTypeTextPlain,
    mimeTypeHTMLPlain,

    notSupported
};

@implementation Message

- (instancetype)initWithData:(NSDictionary *)message {
    self = [super init];
    bool subject = false;
    bool from = false;
    if (self) {
        self.sizeEstimate = [message objectForKey:@"sizeEstimate"];
        self.labelIDs = [[LabelIds alloc] initWithData:[message objectForKey:@"labelIds"]];
        self.ID = [message objectForKey:@"id"];
        self.snippet = [message objectForKey:@"snippet"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        self.internalDate = [message objectForKey:@"internalDate"];
        NSNumber *number = [f numberFromString:self.internalDate];
        double myDub = [number doubleValue];
        NSTimeInterval time = myDub / 1000;
        self.date = [NSDate dateWithTimeIntervalSince1970:time];
        self.historyID = [message objectForKey:@"historyId"];
        self.payload = [[Payload alloc] initWithData:[message objectForKey:@"payload"]];
        for (int i = 0; i < self.payload.headers.count; i++) {
            if (subject && from) {
                break;
            }
            if ([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"Subject"]) {
                self.subject = [self.payload.headers[i] objectForKey:@"value"];
                subject = true;
            } else {
                if ([[self.payload.headers[i] objectForKey:@"name"] isEqual:@"From"]) {
                    self.from = [self.payload.headers[i] objectForKey:@"value"];
                    from = true;
                }
            }
        }
        self.threadId = [message objectForKey:@"threadId"];
    }
    return self;
}

- (NSDictionary *)mimeTypeMapping {
    if (_mimeTypeMapping == nil) {
        _mimeTypeMapping = @{
            @(mimeTypeRelated) : @"multipart/related",
            @(mimeTypeAlternative) : @"multipart/alternative",
            @(mimeTypeMixed) : @"multipart/mixed",
            @(mimeTypeTextPlain) : @"text/plain",
            @(mimeTypeHTMLPlain) : @"text/html",
            @(notSupported) : @"Contex isn't supported"
        };
    }
    return _mimeTypeMapping;
}

- (NSString *)decodedMessage {
    NSString *decodedString;
    MimeType mimeType = [self mimeTypeContent:self.payload];
    if (mimeType == notSupported) {
        return self.mimeTypeMapping[@(notSupported)];
    }
    switch (mimeType) {
        case mimeTypeRelated: {
            Payload *payload = [self anotherPayloadFromPayload:self.payload];
            if ([self mimeTypeContent:payload] == notSupported) {
                return self.mimeTypeMapping[@(notSupported)];
            }
            if ([payload.mimeType isEqualToString:self.mimeTypeMapping[@(mimeTypeAlternative)]]) {
                Payload *payload1 = [self anotherPayloadFromPayload:payload];
                if ([self mimeTypeContent:payload1] == notSupported) {
                    return self.mimeTypeMapping[@(notSupported)];
                }
                decodedString = [self decodedStringWithPayload:payload1];
                self.payload.mimeType = payload1.mimeType;
            } else {
                decodedString = [self decodedStringWithPayload:payload];
                self.payload.mimeType = payload.mimeType;
                // NSLog(@"decoded string - %@",decodedString);
            }
            break;
        }
        case mimeTypeAlternative: {
            Payload *payload = [self anotherPayloadFromPayload:self.payload];
            if ([self mimeTypeContent:payload] == notSupported) {
                return self.mimeTypeMapping[@(notSupported)];
            }
            decodedString = [self decodedStringWithPayload:payload];
            self.payload.mimeType = payload.mimeType;
            break;
        }
        case mimeTypeMixed: {
            Payload *payload = [self anotherPayloadFromPayload:self.payload];
            Payload *payload1 = [self anotherPayloadFromPayload:payload];
            if ([self mimeTypeContent:payload1] == notSupported) {
                return self.mimeTypeMapping[@(notSupported)];
            }
            decodedString = [self decodedStringWithPayload:payload1];
            self.payload.mimeType = payload1.mimeType;
            break;
        }
        default: {
            decodedString = [self decodedStringWithPayload:self.payload];
            // NSLog(@"decoded string - %@",decodedString);
            break;
        }
    }
    return decodedString;
}

- (Payload *)anotherPayloadFromPayload:(Payload *)payload {
    Payload *anotherPayload = [[Payload alloc] initWithData:payload.parts[0]];
    return anotherPayload;
}

- (NSString *)decodedStringWithPayload:(Payload *)payload {
    NSString *decodedString;
    BodyOFMessage *body = [payload body];
    decodedString = [self decodeMessage:body];
    return decodedString;
}

- (MimeType)mimeTypeContent:(Payload *)payload {
    MimeType mimeType;
    for (NSNumber *key in self.mimeTypeMapping) {
        if ([self.mimeTypeMapping[key] isEqual:payload.mimeType]) {
            mimeType = [key integerValue];
            return mimeType;
        }
    }
    return notSupported;
}

- (NSString *)stringPayloadContent:(Payload *)payload {
    NSString *stringContent = nil;
    for (NSNumber *key in self.mimeTypeMapping) {
        if ([self.mimeTypeMapping[key] isEqual:payload.mimeType]) {
            stringContent = self.mimeTypeMapping[key];
            return stringContent;
        }
    }
    return self.mimeTypeMapping[@(notSupported)];
}

- (NSString *)decodeMessage:(BodyOFMessage *)body {
    NSString *data = body.data;
    data = [data stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    data = [data stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
    return [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
}

+ (NSString *)encodedMessage:(NSString *)from to:(NSString *)to subject:(NSString *)subject body:(NSString *)body {
    NSString *message = [NSString stringWithFormat:@"From: %@\r\nTo: %@\r\nSubject: %@\r\n\r\n%@", from, to, subject, body];
    NSData *encodedMessage = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [encodedMessage base64EncodedStringWithOptions:0];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSLog(@"%@", encoded);
    return encoded;
}

@end
