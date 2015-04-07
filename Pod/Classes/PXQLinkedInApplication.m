//////////////////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInApplication.m
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
#import "PXQLinkedInApplication.h"

const struct PXQLinkedInApplicationAuthorizationScope PXQLinkedInApplicationAuthorizationScope = {
    
    .rw_company_admin
        = @"rw_company_admin",
    .rw_nus
        = @"rw_nus",
    .w_share
        = @"w_share",
    .r_emailaddress
        = @"r_emailaddress",
    .w_messages
        = @"w_messages",
    .r_network
        = @"r_network",
    .r_basicprofile
        = @"r_basicprofile",
    .rw_groups
        = @"rw_groups",
    .r_fullprofile
        = @"r_fullprofile",
    .r_contactinfo
        = @"r_contactinfo",
};

@implementation PXQLinkedInApplication

- (instancetype)initWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess {
    
    self = [super init];
    
    if (self) {
    
        self.redirectURLString = redirectURL;
        self.clientId = clientId;
        self.clientSecret = clientSecret;
        self.state = state;
        self.authorizationScopes = grantedAccess;
    }
    
    return self;
}

+ (instancetype)applicationWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess {
    
    return [[self alloc] initWithRedirectURL:redirectURL clientId:clientId clientSecret:clientSecret state:state grantedAccess:grantedAccess];
}

- (NSString *)grantedAccessString {
    
    return [self.authorizationScopes componentsJoinedByString: @"%20"];
}

@end
