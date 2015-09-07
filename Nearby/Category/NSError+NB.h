//
//  NSError+NB.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

/**
 *  Default app domain error
 */
extern NSString * const NBErrorDomain;

/**
 *  App error codes
 */
typedef NS_ENUM(NSInteger, NBErrorCodes){
    /**
     *  Parsing error
     */
    NBParsingErrorCode = 1,
    /**
     *  No location error
     */
    NBNoLocationErrorCode,
    /**
     *  Missing parameter error
     */
    NBMissingParameterErrorCode,
    /**
     *  Error on route planner
     */
    NBRoutePlanErrorCode
};

/**
 *  NSError category to facilitate create errors
 */
@interface NSError (NB)

/**
 *  Create a NSError with decription, reason and suggestion
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

/**
 *  Create a NSError with a NBErrorCodes in NBErrorDomain with description
 *
 *  @param code        NBErrorCodes
 *  @param description NSString
 *
 *  @return NSError
 */
+ (instancetype)nb_errorWithCode:(NBErrorCodes)code
            localizedDescription:(NSString *)description;

@end
