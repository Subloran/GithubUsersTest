//
//  APIResponse.m
//  GithubUsersTest
//
//  Created by Artem on 29/08/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "APIResponse.h"

@implementation APIResponse

+ (APIResponse*)responseWithJSON:(NSDictionary*)json requestFailed:(BOOL)requestFailed noInternetConnection:(BOOL)noInternetConnection
{
    APIResponse* response = [[APIResponse alloc] init];
    
    response.json = json;
    response.requestFailed = requestFailed || json.count == 0;
    response.noInternetConnection = noInternetConnection;
    
    return response;
}

@end
