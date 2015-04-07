//////////////////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInAuthorizationViewControllerDelegate.h
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>

@class PXQLinkedInAuthorizationViewController;

/**
    Models the authorization handlers for the @see PXQLinkedInAuthorizationViewController
    class.
 */
@protocol PXQLinkedInAuthorizationViewControllerDelegate <NSObject>

@optional

/**
    Fires when the user manually dismisses the authorization screen.
 */
- (void)pxquisiteLinkedInAuthorizationViewControllerDidCancel:(PXQLinkedInAuthorizationViewController *)linkedInAuthorizationViewController;

/**
    Fires when the authorization process fails.
 */
- (void)pxquisiteLinkedInAuthorizationViewController:(PXQLinkedInAuthorizationViewController *)linkedInAuthorizationViewController
                                     failedWithError:(NSError *)error;

/**
    Fires when the authorization process succeed.
 */
- (void)pxquisiteLinkedInAuthorizationViewController:(PXQLinkedInAuthorizationViewController *)linkedInAuthorizationViewController
                      succeededWithAuthorizationCode:(NSString *)code;

@end