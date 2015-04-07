//////////////////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInAuthorizationViewController.m
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
#import "PXQLinkedInAuthorizationViewController.h"
#import "PXQLinkedInApplication.h"
#import "PXQLinkedInHttpOperationManager.h"
#import "PXQLinkedInErrors.h"
#import "NSString+PXQLinkedInAuthorization.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

NSString * const kPXQLinkedInDeniedByUser   = @"the+user+denied+your+request";

@interface PXQLinkedInAuthorizationViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UIBarButtonItem * cancelBarButtonItem;

@property (nonatomic, strong) PXQLinkedInApplication * linkedInApplication;

@property (nonatomic, readwrite) BOOL handleRedirectURL;

@end

@implementation PXQLinkedInAuthorizationViewController

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithApplication:(PXQLinkedInApplication *)application {

    return [self initWithApplication:application delegate:nil];
}

- (instancetype)initWithApplication:(PXQLinkedInApplication *)application delegate:(id<PXQLinkedInAuthorizationViewControllerDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        self.linkedInApplication = application;
        
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark -
#pragma mark View Hierarchy

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //
    //  Cancel bar button item
    //
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tappedCancelButton:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.cancelBarButtonItem = cancelButton;
    
    
    //
    //  Web View
    //
    
    self.webView = [[UIWebView alloc] init];
    
    self.webView.delegate = self;
    
    self.webView.scalesPageToFit = YES;
    
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSString *linkedInAuthorizationUrlString = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", self.linkedInApplication.clientId, self.linkedInApplication.grantedAccessString, self.linkedInApplication.state, [self.linkedInApplication.redirectURLString encodedStringForLinkedInAuthorization]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedInAuthorizationUrlString]]];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark PXQLinkedInAuthorizationControllerDelegate Event Fireup

- (void)notifyDidCancel {
    
    if ( [self.delegate respondsToSelector:@selector(pxquisiteLinkedInAuthorizationViewControllerDidCancel:)] ) {
        
        [self.delegate pxquisiteLinkedInAuthorizationViewControllerDidCancel:self];
    }
}

- (void)notifyDidFail:(NSError *)error {
    
    if ( [self.delegate respondsToSelector:@selector(pxquisiteLinkedInAuthorizationViewController:failedWithError:)] ) {
        
        [self.delegate pxquisiteLinkedInAuthorizationViewController:self failedWithError:error];
    }
}

- (void)notifyDidSucceed:(NSString *)authorizationCode {
    
    if ( [self.delegate respondsToSelector:@selector(pxquisiteLinkedInAuthorizationViewController:succeededWithAuthorizationCode:)] ) {
        
        [self.delegate pxquisiteLinkedInAuthorizationViewController:self  succeededWithAuthorizationCode:authorizationCode];
    }
}

#pragma mark -
#pragma mark Cancellation

- (void)tappedCancelButton:(id)sender {
 
    [self notifyDidCancel];
}

#pragma mark -
#pragma mark WebView & OAuth Handlers

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] absoluteString];
    
    self.handleRedirectURL = self.linkedInApplication.redirectURLString && [url hasPrefix:self.linkedInApplication.redirectURLString];
    
    if (self.handleRedirectURL) {
        
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            
            BOOL accessDeniedByUser = [url rangeOfString:kPXQLinkedInDeniedByUser].location != NSNotFound;
            
            if ( accessDeniedByUser ) {
                
                [self notifyDidCancel];
                
            } else {
                
                NSError * error = [[NSError alloc] initWithDomain:kPXQLinkedInErrorDomain code:PXQLinkedInErrorUserCancelled
                                                         userInfo:[NSDictionary dictionaryWithObject:@"The user has cancelled the authorization request." forKey:NSLocalizedDescriptionKey]];
            
                [self notifyDidFail:error];
            }
            
        } else {
            
            NSString *receivedState = [self extractGetParameter:@"state" fromURLString:url];
            
            //assert that the state is as we expected it to be
            
            if ([self.linkedInApplication.state isEqualToString:receivedState]) {
               
                NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: url];
                
                if ( ! authorizationCode ) {
                    
                    NSError * error = [[NSError alloc] initWithDomain:kPXQLinkedInErrorDomain code:PXQLinkedInInvalidAuthorizationCode
                                                             userInfo:[NSDictionary dictionaryWithObject:@"The authorization code is nil or empty string." forKey:NSLocalizedDescriptionKey]];
                    
                    [self notifyDidFail:error];
                    
                }
                else {
                
                    [self notifyDidSucceed:authorizationCode];
                }
                
            } else {
                
                NSError *error = [[NSError alloc] initWithDomain:kPXQLinkedInErrorDomain code:PXQLinkedInInvalidApplicationState userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Invalid application state '%@'.", self.linkedInApplication.state] forKey:NSLocalizedDescriptionKey]];
               
                [self.delegate pxquisiteLinkedInAuthorizationViewController:self failedWithError:error];
            }
        }
    }
    return ! self.handleRedirectURL;
}

- (NSString *)extractGetParameter:(NSString *)parameterName fromURLString:(NSString *)urlString {
    
    NSMutableDictionary * mdQueryStrings = [[NSMutableDictionary alloc] init];
    
    urlString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    
    for (NSString * qs in [urlString componentsSeparatedByString:@"&"]) {
    
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    
    return [mdQueryStrings objectForKey:parameterName];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if ( ! self.handleRedirectURL ) {
    
        [self.delegate pxquisiteLinkedInAuthorizationViewController:self failedWithError:error];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        NSString* js =
            @"var meta = document.createElement('meta'); "
            @"meta.setAttribute( 'name', 'viewport' ); "
            @"meta.setAttribute( 'content', 'width = 540px, initial-scale = 1.0, user-scalable = yes' ); "
            @"document.getElementsByTagName('head')[0].appendChild(meta)";
        
        [webView stringByEvaluatingJavaScriptFromString: js];
    }
}

@end
