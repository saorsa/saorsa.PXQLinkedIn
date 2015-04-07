/////////////////////////////////////////////////////////////////////////////////////////////
//
//  NSString+PXQLinkedInAuthorization.m
//  AsOne
//
//  Created by Dragolov,Atanas on 7.04.15.
//  Copyright (c) 2015 г. Atanas Dragolov. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////
#import "NSString+PXQLinkedInAuthorization.h"

@implementation NSString (PXQLinkedInAuthorization)

- (NSString *)encodedStringForLinkedInAuthorization {
    
    return (NSString *)CFBridgingRelease( CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (__bridge CFStringRef) self,
                                                                                  NULL,
                                                                                  CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                  kCFStringEncodingUTF8
                                                                                  )
    );
}

@end
