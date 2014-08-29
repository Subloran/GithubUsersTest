//
//  GithubAPI.h
//  GithubUsersTest
//
//  Created by Artem on 29/08/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <AFNetworking.h>
#import "APIResponse.h"

typedef void (^APIResponseBlock)(APIResponse* response);

@interface GithubAPI : AFHTTPSessionManager

+ (GithubAPI*)sharedInstance;

- (NSURLSessionDataTask*)GET:(NSString*)URLString parameters:(NSDictionary*)parameters onCompletion:(APIResponseBlock)completionBlock;

@end
