//
//  TMSNetwork.h
//  -
//
//  Created by Temosan on 05/07/2019.
//  Copyright © 2019 Temosan. All rights reserved.
//

#import <UIKit/UIKit.h>

// Can be off the Network Log
// #define NetworkLogRequest
// #define NetworkLogResponse

#ifdef NetworkLogRequest
#define log_Network_Request(fmt, ...) NSLog(@"Network Request\t\n%@%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__], @"\n------------------------------");
#else
#define log_Network_Request(fmt, ...)
#endif

#ifdef NetworkLogResponse
#define log_Network_Response(fmt, ...) NSLog(@"Network Response\t\n%@%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__], @"\n------------------------------");
#else
#define log_Network_Response(fmt, ...)
#endif

typedef enum : NSUInteger {
    POST,
    GET,
    DELETE,
    PUT,
} TMSNetworkType;

typedef void(^NetworkCompletionHandler)(BOOL, NSError *, NSDictionary *);

@interface TMSNetwork : NSObject

+ (void)requestURL:(NSString *)urlString
              Type:(TMSNetworkType)type
           Headers:(NSDictionary *)headers
        Parameters:(NSDictionary *)parameters
   CompletionBlock:(NetworkCompletionHandler)completionHandler;

@end
