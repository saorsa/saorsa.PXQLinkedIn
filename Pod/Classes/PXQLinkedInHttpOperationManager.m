//////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInHttpOperationManager.m
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////
#import "PXQLinkedInHttpOperationManager.h"
#import "PXQLinkedInApplication.h"
#import "NSString+PXQLinkedInAuthorization.h"

NSString * const kPXQ_LinkedIn_UserDefaults_TokenKey
    = @"pxq.linkedin.token";
NSString * const kPXQ_LinkedIn_UserDefaults_ExpirationKey
    = @"pxq.linkedin.expiration";
NSString * const kPXQ_LinkedIn_UserDefaults_CreatedKey
    = @"pxq.linkedin.token_created_at";


@interface PXQLinkedInHttpOperationManager ()

@end

@implementation PXQLinkedInHttpOperationManager

+ (instancetype)managerForApplication:(PXQLinkedInApplication *)application {
    
    PXQLinkedInHttpOperationManager * result = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.linkedin.com"]];
    
    result.application = application;
    
    return result;
}

- (id)initWithBaseURL:(NSURL *)url {
 
    self = [super initWithBaseURL:url];
    
    if (self) {
    
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    
    return self;
}

- (BOOL)hasLinkedInSession {
 
    NSArray * allKeys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    
    return
        [allKeys containsObject:kPXQ_LinkedIn_UserDefaults_CreatedKey] &&
        [allKeys containsObject:kPXQ_LinkedIn_UserDefaults_ExpirationKey] &&
        [allKeys containsObject:kPXQ_LinkedIn_UserDefaults_TokenKey];
}

- (BOOL)hasValidAccessToken {
    
    BOOL hasSession = [self hasLinkedInSession];
    
    if ( hasSession ) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([[NSDate date] timeIntervalSince1970] >= ([userDefaults doubleForKey:kPXQ_LinkedIn_UserDefaults_CreatedKey] + [userDefaults doubleForKey:kPXQ_LinkedIn_UserDefaults_ExpirationKey])) {
            
            return NO;
        }
        else {
            
            return YES;
        }
    }
    else {
        
        return NO;
    }
}

- (NSString *)accessToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPXQ_LinkedIn_UserDefaults_TokenKey];
}

- (void)getAccessToken:(NSString *)authorizationCode success:(void (^)(NSDictionary * authInfo))success failure:(void (^)(NSError * error))failure {
    
    NSString *accessTokenUrl = @"/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@";
    
    NSString *url = [NSString stringWithFormat:accessTokenUrl, authorizationCode, [self.application.redirectURLString encodedStringForLinkedInAuthorization], self.application.clientId, self.application.clientSecret];
    
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *accessToken = [responseObject objectForKey:@"access_token"];
        
        NSTimeInterval expiration = [[responseObject objectForKey:@"expires_in"] doubleValue];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:accessToken forKey:kPXQ_LinkedIn_UserDefaults_TokenKey];
        
        [userDefaults setDouble:expiration forKey:kPXQ_LinkedIn_UserDefaults_ExpirationKey];
        
        [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kPXQ_LinkedIn_UserDefaults_CreatedKey];
        
        if ( [userDefaults synchronize] ) {
         
            // well...
        }
        
        if ( success != NULL ) {
            
            success(responseObject);
        }
        
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ( failure != NULL ) {
        
            failure(error);
        }
    }];
}

- (void)getProfileInformation:(NSString *)accessToken
                      success:(void (^)(NSDictionary * authInfo))success
                      failure:(void (^)(NSError * error))failure {
    
    [self getProfileInformation:accessToken profilePropertiesToFetch:nil success:success failure:failure];
}

- (void)getProfileInformation:(NSString *)accessToken
     profilePropertiesToFetch:(NSArray *)profilePropertyKeys
                      success:(void (^)(NSDictionary * authInfo))success
                      failure:(void (^)(NSError * error))failure {
    
    if ( profilePropertyKeys.count > 0) {
        
        NSMutableString * stringifiedPropertyKeys = [NSMutableString new];
        
        for (NSInteger idx = 0; idx < profilePropertyKeys.count; idx++) {
         
            if ( idx == (profilePropertyKeys.count-1) ) {
                
                [stringifiedPropertyKeys appendString:[profilePropertyKeys objectAtIndex:idx]];
            }
            else {
                
                [stringifiedPropertyKeys appendFormat:@"%@,", [profilePropertyKeys objectAtIndex:idx]];
            }
        }
        
        [self GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(%@)?oauth2_access_token=%@&format=json", stringifiedPropertyKeys, accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ( success  != NULL ) {
                
                success ( responseObject );
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if ( failure != NULL ) {
                
                failure (error);
            }
        }];
    }
    else {
        
        [self GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ( success  != NULL ) {
                
                success ( responseObject );
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if ( failure != NULL ) {
                
                failure (error);
            }
        }];
    }
}

@end
