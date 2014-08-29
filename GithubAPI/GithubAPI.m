//
//  GithubAPI.m
//  GithubUsersTest
//
//  Created by Artem on 29/08/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "GithubAPI.h"
#import "Constants.h"

@implementation GithubAPI

static GithubAPI* githubAPIptr;

+ (GithubAPI*)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.allowsCellularAccess = YES;
        configuration.timeoutIntervalForRequest = HttpRequestUntilDataTimeout;
        configuration.timeoutIntervalForResource = HttpRequestTimeout;
        
        githubAPIptr = [[self alloc] initWithBaseURL:[NSURL URLWithString:APIGithubBaseURL] sessionConfiguration:configuration];
        githubAPIptr.requestSerializer = [AFJSONRequestSerializer serializer];
        githubAPIptr.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return githubAPIptr;
}

- (NSURLSessionDataTask*)GET:(NSString*)URLString parameters:(NSDictionary*)parameters onCompletion:(APIResponseBlock)completionBlock
{
    return [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionBlock != nil)
            completionBlock([APIResponse responseWithJSON:responseObject requestFailed:NO noInternetConnection:NO]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(completionBlock != nil && error.code != NSURLErrorCancelled)
            completionBlock([APIResponse responseWithJSON:nil requestFailed:YES noInternetConnection:error.code == NSURLErrorNotConnectedToInternet]);
    }];
}

@end
