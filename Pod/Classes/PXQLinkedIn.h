///////////////////////////////////////////////////////////////////
//
//  PXQLinkedIn.h
//  Pods
//
//  Created by Dragolov,Atanas on 7.04.15.
//
///////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import "NSString+PXQLinkedInAuthorization.h"
#import "PXQLinkedInApplication.h"
#import "PXQLinkedInAuthorizationViewController.h"
#import "PXQLinkedInAuthorizationViewControllerDelegate.h"
#import "PXQLinkedInErrors.h"
#import "PXQLinkedInHttpOperationManager.h"

typedef void (^PXQLinkedInAuthenticationSuccessCallback)(NSDictionary * authInfo);

typedef void (^PXQLinkedInErrorCallback)(NSError * error);

/**
    The entry manager class responsible for LinkedIn ops and
    UI interaction.
 */
@interface PXQLinkedIn : NSObject<PXQLinkedInAuthorizationViewControllerDelegate>

/**
    Gets the undelying HTTP client reference.
 */
@property (nonatomic, strong, readonly) PXQLinkedInHttpOperationManager * httpClient;

/**
    Gets the reference to the configured LinkedIn application.
 */
@property (nonatomic, strong, readonly) PXQLinkedInApplication * application;

/**
    Gets an indication if LinkedIn requires authorization.
 */
@property (nonatomic, readonly) BOOL requiresLinkedInAuthorization;

/**
    Gets or sets the view controller in the hierarchy used for presenting the
    authorization view on scree.
 */
@property (nonatomic, strong) UIViewController * presenterViewController;

/**
    Gets or sets the modal presentation style for the LinkedIn authorization screen.
 */
@property (nonatomic) UIModalPresentationStyle authorizationScreenPresentationStyle;

/**
    Gets or sets the modal transition style for the LinkedIn authorization screen.
 */
@property (nonatomic) UIModalTransitionStyle authorizationScreenTransitionStyle;

/**
    The callback block invoked upon authorization error.
 */
@property (nonatomic, copy) PXQLinkedInErrorCallback authorizationErrorCallback;

/**
    The callback block invoked upon authentication & authorization success.
 */
@property (nonatomic, copy) PXQLinkedInAuthenticationSuccessCallback authenticationSuccessCallback;

/**
    Gets a configured instance of the class.
 */
+ (instancetype)configureWithApplication:(PXQLinkedInApplication *)application presenterViewController:(UIViewController *)presenterViewController;

@end

@interface PXQLinkedIn (Configuration)

/**
    Configures the class for the authorization view controller.
    MUST be a derived class of the @seealso PXQLinkedInAuthorizationViewController class
 */
+ (void)setAuthorizationViewControllerClass:(Class)viewControllerClass;

/**
    Creates an instance of the class specified in @seealso setAuthorizationViewControllerClass: method.
 
    If not specified, returns a default @seealso PXQLinkedInAuthorizationViewController class instance.
 */
+ (PXQLinkedInAuthorizationViewController *)createAuthorizationControllerForApplication:(PXQLinkedInApplication *)application;

@end

@interface PXQLinkedIn (UIPresentation)

/**
    Displays the authorization screen.
 */
- (void)displayLinkedInAuthorizationScreen:(void (^)(void))completion authenticationSuccess:(void(^)(NSDictionary * authInfo))authorizationSuccess authorizationError:(void(^)(NSError * authorizationError))authorizationError;

/**
    Hides the authorization screen.
 */
- (void)hideLinkedInAuthorizationScreen:(void (^)(void))completion;

@end