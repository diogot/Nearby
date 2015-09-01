//
//  NBAnalytics.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

#define SOFT_CRASH_NAME [NSString stringWithFormat:@"[%s:%d] %s", __FILE__, __LINE__, __PRETTY_FUNCTION__]
#define LogSoftCrash()           [NBAnalytics softCrashWithName:SOFT_CRASH_NAME error:nil]
#define LogSoftCrashWithError(x) [NBAnalytics softCrashWithName:SOFT_CRASH_NAME error:x]

@interface NBAnalytics : NSObject

/**
 *  Log a soft crash or an inconsistent state
 *
 *  @param name  crash or state key, if is @a nil nothing is logged
 *  @param error an error related with crash, can be @a nil
 */
+ (void)softCrashWithName:(NSString *)name
                    error:(NSError *)error;

@end
