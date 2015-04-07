//////////////////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInApplication.h
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
    The PXQLinkedInApplicationAuthorizationScope struct defines the authorization
    scopes supported by the LinkedIn OAuth API.
 */
extern const struct PXQLinkedInApplicationAuthorizationScope {
    
    __unsafe_unretained NSString *rw_company_admin;
    __unsafe_unretained NSString *rw_nus;
    __unsafe_unretained NSString *w_share;
    __unsafe_unretained NSString *r_emailaddress;
    __unsafe_unretained NSString *w_messages;
    __unsafe_unretained NSString *r_network;
    __unsafe_unretained NSString *r_basicprofile;
    __unsafe_unretained NSString *rw_groups;
    __unsafe_unretained NSString *r_fullprofile;
    __unsafe_unretained NSString *r_contactinfo;
    
} PXQLinkedInApplicationAuthorizationScope;


/**
    Represents a high-level abstract model of a LinkedIn application.
 */
@interface PXQLinkedInApplication : NSObject

/**
    Gets or sets the configured callback redirect URL to be used after a successful
    authentication & authorization against the LinkedIn API.
 */
@property (nonatomic, copy) NSString * redirectURLString;

/**
    Gets or sets the client ID / consumer key of the application.
 */
@property (nonatomic, copy) NSString * clientId;

/**
    Gets or sets the consumer secret of the application.
 */
@property (nonatomic, copy) NSString * clientSecret;

/**
    Gets or sets the security state of the application.
 */
@property (nonatomic, copy) NSString * state;

/**
    Gets or sets the array of user authorized scopes. 
    @seealso PXQLinkedInApplicationAuthorizationScope
 */
@property (nonatomic, strong) NSArray *authorizationScopes;

/**
    Gets the user authorized scopes in LinkedIn acceptable form.
    Used by the authorization mechanism of the library.
 */
@property (nonatomic, strong, readonly) NSString * grantedAccessString;

/**
    Object constructor. 
    Initializes with predefined properties.
 */
- (instancetype)initWithRedirectURL:(NSString *)redirectURL
                           clientId:(NSString *)clientId
                       clientSecret:(NSString *)clientSecret
                              state:(NSString *)state
                      grantedAccess:(NSArray *)grantedAccess;

/**
    Object constructor.
    Initializes with predefined properties.
 */
+ (instancetype)applicationWithRedirectURL:(NSString *)redirectURL
                                  clientId:(NSString *)clientId
                              clientSecret:(NSString *)clientSecret
                                     state:(NSString *)state
                             grantedAccess:(NSArray *)grantedAccess;

@end
