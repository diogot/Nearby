//
//  NBAnalytics.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBAnalytics.h"

@implementation NBAnalytics

+ (void)softCrashWithName:(NSString *)name
                    error:(NSError *)error
{
    NSMutableDictionary *info = [NSMutableDictionary new];
    
    if (name.length == 0) {
        return;
    }
    
    NSString *shortName = [self shornameFromCrashName:name];
    if (shortName.length) {
        name = shortName;
    }
    
    info[@"name"] = name;
    
    if (error) {
        NSString *domain = error.domain;
        NSInteger code = error.code;
        NSString *description = error.localizedDescription;
        
        if (domain.length) {
            info[@"errorDomain"] = domain;
        }
        if (code != 0) {
            info[@"errorCode"] = @(code);
        }
        if (description.length) {
            info[@"errorDescription"] = description;
        }
    }
    
    NSLog(@"SOFT CRASH: %@", name);
}

+ (NSString *)shornameFromCrashName:(NSString *)name
{
    NSScanner *scanner = [NSScanner scannerWithString:name];
    
    NSString *filePath = nil;
    NSInteger lineNumber = -1;
    NSString *methodName = nil;
    BOOL didScan = [scanner scanString:@"[" intoString:NULL] &&
    [scanner scanUpToString:@":" intoString:&filePath] &&
    [scanner scanString:@":" intoString:NULL] &&
    [scanner scanInteger:&lineNumber] &&
    [scanner scanString:@"] " intoString:NULL] &&
    [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                            intoString:&methodName];
    
    NSString *fileName = [filePath lastPathComponent];
    
    NSString *shortName = nil;
    if (didScan && fileName.length && lineNumber > -1 && methodName.length) {
        shortName = [NSString stringWithFormat:@"[%@:%ld] %@", fileName, (long)lineNumber, methodName];
    }
    
    return shortName;
}

@end
