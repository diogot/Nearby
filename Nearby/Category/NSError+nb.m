//
//  NSError+nb.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NSError+nb.h"

NSString * const NBErrorDomain = @"NBErrorDomain";

@implementation NSError (nb)

+ (NSError *)nb_errorWithDomain:(NSString *)domain
                           code:(NSInteger)code
                    description:(NSString *)description
                         reason:(NSString *)reason
                     suggestion:(NSString *)suggestion
{
    NSMutableDictionary *userInfo;
    userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    
    if ([description length]) {
        [userInfo setObject:description
                     forKey:NSLocalizedDescriptionKey];
    }
    
    if ([reason length]) {
        [userInfo setObject:reason
                     forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    if ([suggestion length]) {
        [userInfo setObject:suggestion
                     forKey:NSLocalizedRecoverySuggestionErrorKey];
    }
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:code
                                     userInfo:userInfo];
    
    return error;
}

+ (instancetype)nb_errorWithCode:(NSInteger)code
            localizedDescription:(NSString *)description
{
    NSString *domain = NBErrorDomain;
    NSDictionary *userInfo;
    if (description.length) {
        userInfo = @{NSLocalizedDescriptionKey: description};
    }
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:code
                                     userInfo:userInfo];
    
    return error;
}

@end
