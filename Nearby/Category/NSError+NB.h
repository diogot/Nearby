//
//  NSError+NB.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

#warning Docs

extern NSString * const NBErrorDomain;

typedef NS_ENUM(NSInteger, NBErrorCodes) {
    NBParsingErrorCode = 1,
    NBNoLocationErrorCode,
    NBMissingParameterErrorCode,
    NBRoutePlanErrorCode
};

@interface NSError (NB)

/**
 *  Create an NSError with decription, reason and suggestion
 *
 *  @param domain      NSString with the domain error
 *  @param code        NSInteger code error
 *  @param description NSString for NSLocalizedDescriptionKey, can be @a nil
 *  @param reason      NSString for NSLocalizedFailureReasonErrorKey, can be @a nil
 *  @param suggestion  NSString for NSLocalizedRecoverySuggestionErrorKey, can be @a nil
 *
 *  @return NSError
 */
+ (instancetype)nb_errorWithDomain:(NSString *)domain
                              code:(NBErrorCodes)code
                       description:(NSString *)description
                            reason:(NSString *)reason
                        suggestion:(NSString *)suggestion;

+ (instancetype)nb_errorWithCode:(NBErrorCodes)code
            localizedDescription:(NSString *)description;

@end
