//////////////////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInAuthorizationViewController.h
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>
#import "PXQLinkedInAuthorizationViewControllerDelegate.h"

@class PXQLinkedInApplication;

/**
    The base view controller class that presents the authorization view
    of the LinkedIn platform.
 */
@interface PXQLinkedInAuthorizationViewController : UIViewController

@property (nonatomic, strong, readonly) UIWebView * webView;

@property (nonatomic, strong, readonly) PXQLinkedInApplication * linkedInApplication;

@property (nonatomic, weak) id<PXQLinkedInAuthorizationViewControllerDelegate> delegate;

- (instancetype)initWithApplication:(PXQLinkedInApplication *)application;

- (instancetype)initWithApplication:(PXQLinkedInApplication *)application delegate:(id<PXQLinkedInAuthorizationViewControllerDelegate>)delegate;

@end
