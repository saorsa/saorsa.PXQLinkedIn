/////////////////////////////////////////////////////////////////////////////////
//
//  PXQLinkedInErrors.h
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
    The error domain associated with errors during authentication & authorization
    with the PXQLinkedIn library.
 */
extern NSString * const kPXQLinkedInErrorDomain;

/**
    Enumerates the error codes provided by the PXQLinkedInLibrary
 */
typedef enum {
    
    /**
        The user has cancelled the authorization request.
     */
    PXQLinkedInErrorUserCancelled       =   15100,
    
    /**
        The authorization succeeded but the provided LinkedIn application
        state did not match the requested one. 
     
        This could potentially mean that the authorization request has been
        tampered with and a security violation has occurred.
     */
    PXQLinkedInInvalidApplicationState  =   15200,
    
    /**
        The authorization code provided in the authorization response is not valid.
     */
    PXQLinkedInInvalidAuthorizationCode =   15300,
    
} PXQLinkedInErrorCode;