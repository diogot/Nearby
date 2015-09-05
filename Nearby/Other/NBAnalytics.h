//
//  NBAnalytics.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

/**
 *  Get file and function names, also line number
 */
#define SOFT_CRASH_NAME [NSString stringWithFormat:@"[%s:%d] %s", __FILE__, __LINE__, __PRETTY_FUNCTION__]

/**
 *  Log soft crash or inconsistent states
 */
#define LogSoftCrash()           [NBAnalytics softCrashWithName:SOFT_CRASH_NAME error:nil]

/**
 *  Log soft crash or inconsistent states with an error
 *
 *  @param x NSError
 */
#define LogSoftCrashWithError(x) [NBAnalytics softCrashWithName:SOFT_CRASH_NAME error:x]

/**
 *  Class to analytics and crash report
 */
@interface NBAnalytics : NSObject

/**
 *  Log a soft crash or an inconsistent state, give preference to use the
 *  macros LogSoftCrash() and LogSoftCrashWithError(error)
 *
 *  @param name  crash or state key, if is @a nil nothing is logged
 *  @param error an error related with crash, can be @a nil
 */
+ (void)softCrashWithName:(NSString *)name
                    error:(NSError *)error;

@end
