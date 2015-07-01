//
//  APIResponse.h
//  GithubUsersTest
//
//  Created by Artem on 29/08/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIResponse : NSObject

@property (nonatomic, strong) NSArray* json;
@property (nonatomic) BOOL requestFailed;
@property (nonatomic) BOOL noInternetConnection;

+ (APIResponse*)responseWithJSON:(NSArray*)json requestFailed:(BOOL)requestFailed noInternetConnection:(BOOL)noInternetConnection;

@end
