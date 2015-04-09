///////////////////////////////////////////////////////////////////
//
//  PXQLinkedIn.m
//  Pods
//
//  Created by Dragolov,Atanas on 7.04.15.
//
///////////////////////////////////////////////////////////////////
#import "PXQLinkedIn.h"

@interface PXQLinkedIn ()

@property (nonatomic, strong) PXQLinkedInApplication * application;

@property (nonatomic, strong) PXQLinkedInHttpOperationManager * httpClient;

@property (nonatomic, strong) PXQLinkedInAuthorizationViewController * activeAuthorizationController;

@end

@implementation PXQLinkedIn

@synthesize application = _application;
@synthesize httpClient = _httpClient;
@synthesize presenterViewController = _presenterViewController;

static Class _authorizationViewControllerClass;

- (id)init {
    
    self = [super init];
    
    self.authorizationScreenPresentationStyle = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIModalPresentationFormSheet : UIModalPresentationFullScreen;
    
    self.authorizationScreenTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    return self;
}

+ (instancetype)configureWithApplication:(PXQLinkedInApplication *)application presenterViewController:(UIViewController *)presenterViewController {
    
    PXQLinkedIn * result = [[[self class] alloc] init];
    
    result.application = application;
    
    result.presenterViewController = presenterViewController ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    
    return result;
}

+ (void)setAuthorizationViewControllerClass:(Class)viewControllerClass {
 
    if ( ! [viewControllerClass isSubclassOfClass:[PXQLinkedInAuthorizationViewController class]]) {
    
        [NSException raise:@"ArgumentException" format:@"Class '%@' is not a valid subclass of the PXQLinkedInAuthorizationViewController class.", NSStringFromClass(viewControllerClass)];
    }
    else {
        
        _authorizationViewControllerClass = viewControllerClass;
    }
}

- (void)setApplication:(PXQLinkedInApplication *)application {
 
    @synchronized ( self ) {
        
        _application = application;
        
        _httpClient = [PXQLinkedInHttpOperationManager managerForApplication:application];
    }
}

- (BOOL)requiresLinkedInAuthorization {
    
    return self.httpClient.hasValidAccessToken;
}

- (void)displayLinkedInAuthorizationScreen:(void (^)(void))completion authenticationSuccess:(void(^)(NSDictionary * authInfo))authorizationSuccess authorizationError:(void(^)(NSError * authorizationError))authorizationError; {
    
    self.authorizationErrorCallback = authorizationError;
    
    self.authenticationSuccessCallback = authorizationSuccess;
    
    PXQLinkedInAuthorizationViewController * authorizationController = [[self class] createAuthorizationControllerForApplication:self.application];
    
    authorizationController.delegate = self;
    
    self.activeAuthorizationController = authorizationController;
    
    [self displayLinkedInAuthorizationScreen:authorizationController completion:completion];
}

+ (PXQLinkedInAuthorizationViewController *)createAuthorizationControllerForApplication:(PXQLinkedInApplication *)application {
    
    if ( _authorizationViewControllerClass ) {
        
        return [[_authorizationViewControllerClass alloc] initWithApplication:application];
    }
    else {
        
        return [[PXQLinkedInAuthorizationViewController alloc] initWithApplication:application];
    }
}

- (void)displayLinkedInAuthorizationScreen:(PXQLinkedInAuthorizationViewController *)authorizationViewController completion:(void (^)(void))completion {
    
    if (self.presenterViewController == nil) {
        
        NSLog(@"[PXQLinkedIn] Cannot display the LinkedIn authorization screen. The presenter view controller is nil.");
        
        if ( completion ) {
            
            completion();
        }
    }
    else {
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:authorizationViewController];
        
        authorizationViewController.modalPresentationStyle = self.authorizationScreenPresentationStyle;
        
        authorizationViewController.modalTransitionStyle = self.authorizationScreenTransitionStyle;
        
        [self.presenterViewController presentViewController:nc animated:YES completion:completion];
    }
}

- (void)hideLinkedInAuthorizationScreen:(void (^)(void))completion  {
    
    [self.presenterViewController dismissViewControllerAnimated:YES completion:completion];
}

- (void)pxquisiteLinkedInAuthorizationViewController:(PXQLinkedInAuthorizationViewController *)linkedInAuthorizationViewController failedWithError:(NSError *)error {
 
    if ( self.authorizationErrorCallback != NULL) {
        
        self.authorizationErrorCallback ( error );
    }
    
    [self hideLinkedInAuthorizationScreen:^{
        
    }];
}

- (void)pxquisiteLinkedInAuthorizationViewController:(PXQLinkedInAuthorizationViewController *)linkedInAuthorizationViewController succeededWithAuthorizationCode:(NSString *)code {
    
    [self.httpClient getAccessToken:code success:^(NSDictionary * authInfo) {
    
        if ( self.authenticationSuccessCallback != NULL) {
            
            self.authenticationSuccessCallback ( authInfo );
        }
        
        [self hideLinkedInAuthorizationScreen:^{
            
        }];
        
    } failure:^(NSError * error) {
        
        if ( self.authorizationErrorCallback != NULL) {
            
            self.authorizationErrorCallback ( error );
        }
        
        [self hideLinkedInAuthorizationScreen:^{
            
        }];
    }];
}

- (void)pxquisiteLinkedInAuthorizationViewControllerDidCancel:(PXQLinkedInAuthorizationViewController *)linkedInAuthorizationViewController {
    
    [self hideLinkedInAuthorizationScreen:^{
        
    }];
}

@end