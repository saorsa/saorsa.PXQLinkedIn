//////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInHttpOperationManager.h
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@class PXQLinkedInApplication;

extern NSString * const kPXQ_LinkedIn_UserDefaults_TokenKey;

extern NSString * const kPXQ_LinkedIn_UserDefaults_ExpirationKey;

extern NSString * const kPXQ_LinkedIn_UserDefaults_CreatedKey;

/**
    AFNetworking operation class for processing LinkedIn API specific requests.
 */
@interface PXQLinkedInHttpOperationManager : AFHTTPRequestOperationManager

/**
    Gets or sets the LinkedIn application reference.
 */
@property(nonatomic, strong) PXQLinkedInApplication * application;

/**
    Gets the last-known access token for the LinkedIn API.
 */
@property (nonatomic, strong, readonly) NSString * accessToken;

/**
    Gets an indication, if the @seealso accessToken is valid and not expired.
 */
@property (nonatomic, readonly) BOOL * hasValidAccessToken;

/**
    Returns an instance of the class for the specified application.
 */
+ (instancetype)managerForApplication:(PXQLinkedInApplication *)application;

/**
    Performs asynchronious request for the authorization code against the
    LinkedIn OAuth API.
 */
- (void)getAccessToken:(NSString *)authorizationCode success:(void (^)(NSDictionary * authInfo))success failure:(void (^)(NSError * error))failure;

@end
