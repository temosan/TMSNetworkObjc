//
//  TMSNetwork.m
//  -
//
//  Created by Temosan on 05/07/2019.
//  Copyright © 2019 Temosan. All rights reserved.
//

#import "TMSNetwork.h"

#define LOG_HIDE_HEADER 0


@implementation TMSNetwork

+ (void)requestURL:(NSString *)urlString
              Type:(TMSNetworkType)type
           Headers:(NSDictionary *)headers
        Parameters:(NSDictionary *)parameters
   CompletionBlock:(NetworkCompletionHandler)completionHandler {
    
    NSMutableURLRequest *request = [[self class]
                                    createRequestFromUrlString:urlString];
    
    NSString *typeString = nil;
    switch (type) {
        case POST:
            typeString = @"POST";
            break;
        case GET:
            typeString = @"GET";
            break;
        case DELETE:
            typeString = @"DELETE";
            break;
        case PUT:
            typeString = @"PUT";
            break;
    }
    
    if (!typeString) { return; }
    
    [request setHTTPMethod:typeString];
    [request setAllHTTPHeaderFields:headers];
    
    if (type != GET && type != DELETE) {
        NSData *postData = [NSJSONSerialization
                            dataWithJSONObject:parameters
                            options:0
                            error:nil];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *dataTask = [self
                                      dataProcessorRequest:request
                                      CompletionBlock:completionHandler];
    [dataTask resume];
}

+ (NSMutableURLRequest*)createRequestFromUrlString:(NSString*)urlString {
    
    NSMutableURLRequest *urlRequest = nil;
    
    urlRequest = [NSMutableURLRequest
                  requestWithURL:[NSURL URLWithString:urlString]
                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                  timeoutInterval:20.0];
    
    return urlRequest;
}

+ (NSURLSessionDataTask*)dataProcessorRequest:(NSMutableURLRequest*)request
                              CompletionBlock:(NetworkCompletionHandler)completionBlock {
    
    NSMutableString *logString = [NSMutableString stringWithFormat:@"REQUEST TYPE: \t%@", request.HTTPMethod];
    [logString appendString:[NSString stringWithFormat:@"\nREQUEST URL: \t%@", request.URL]];
    if (!LOG_HIDE_HEADER) {
        [logString appendString:[NSString stringWithFormat:@"\nHEADERS: \t%@", request.allHTTPHeaderFields]];
    }
    
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        
        NSDictionary *parameters = [NSJSONSerialization
                                    JSONObjectWithData:request.HTTPBody
                                    options:0
                                    error:nil];
        [logString appendString: [NSString stringWithFormat:@"\nREQUEST DATA: \t%@", parameters]];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@", request.URL];
    if (![url rangeOfString:@"sys/logging"].length) {
        log_Network_Request(@"%@", logString);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    NSDate *time = [NSDate new];
    
    void (^requestBlock)(NSData*, NSURLResponse*, NSError*) = nil;
    requestBlock = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        double now = -floor([time timeIntervalSinceDate:[NSDate date]] * 1000) / 100; now = now;
        log_System(@"URL: %@\nElapsed Time: %f", url, now);
        
        typedef NS_ENUM(NSInteger, COMPLET_TYPE) {
            COMPLET_TYPE_SUCCESS,
            COMPLET_TYPE_NETWORK_ERROR,
            COMPLET_TYPE_RESPONSE_ERROR
        };
        
        COMPLET_TYPE type = COMPLET_TYPE_SUCCESS;
        NSError *jsonError = nil;
        NSDictionary *dic = nil;
        
        if (error) {
            
            type = COMPLET_TYPE_NETWORK_ERROR;
        } else {
            
            jsonError = nil;
            dic = [NSJSONSerialization
                   JSONObjectWithData:data
                   options:0
                   error:&jsonError];
            
            if (jsonError) {
                type = COMPLET_TYPE_RESPONSE_ERROR;
            }
        }
        
        switch (type) {
                
            case COMPLET_TYPE_NETWORK_ERROR:
                if (completionBlock) {
                    completionBlock(NO, error, nil);
                }
                break;
                
            case COMPLET_TYPE_RESPONSE_ERROR:
                if (completionBlock) {
                    completionBlock(NO, jsonError, nil);
                }
                break;
                
            case COMPLET_TYPE_SUCCESS: {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSMutableString *logString = [NSMutableString
                                              stringWithFormat:@"Response Code: \t@%ld\n",
                                              (long)httpResponse.statusCode];
                [logString appendString:[NSString stringWithFormat:@"Response URL: \t%@\n", response.URL.absoluteString]];
                if (!LOG_HIDE_HEADER) {
                    [logString appendString:[NSString stringWithFormat:@"\nHEADERS: \t%@", httpResponse.allHeaderFields]];
                }
                
                if (dic) {
                    [logString appendString: [NSString stringWithFormat:@"\nResponse DATA: \t%@", dic]];
                }
                
                log_Network_Response(@"%@", logString);
                
                if (completionBlock) {
                    completionBlock(YES, nil, dic);
                }
                break;
            }
        }
    };
    
    // Background Request
    __block UIBackgroundTaskIdentifier backgroundID;
    backgroundID = [[UIApplication sharedApplication]
                    beginBackgroundTaskWithExpirationHandler:^{
                        [[UIApplication sharedApplication] endBackgroundTask:[[self class] getBackgroundID]];
                        backgroundID = UIBackgroundTaskInvalid;
                    }];
    [[self class] setBackgroundID:backgroundID];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session
                                      dataTaskWithRequest:request
                                      completionHandler:requestBlock];
    
    return dataTask;
}

+ (void)setBackgroundID:(UIBackgroundTaskIdentifier)backgroundID {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:backgroundID forKey:@"TMSbackgroundID"];
}

+ (UIBackgroundTaskIdentifier)getBackgroundID {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"TMSbackgroundID"];
}

@end
