//
//  NBLocationFetchOperation.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/5/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBLocationFetchOperation.h"
#import "NBNetworkManager.h"

@interface NBLocationFetchOperation ()

@property (nonatomic, readonly) NSOperationQueue *queue;
@property (nonatomic, readonly) NSMutableArray *requestTasks;
@property (nonatomic, readonly) NSMutableSet *locations;
@property (nonatomic, copy) NBLocationFetchOperationCompletionHandler completionHandler;
@property (nonatomic) NSError *fetchError;

@end

@implementation NBLocationFetchOperation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                 completionHandler:(NBLocationFetchOperationCompletionHandler)completionHandler
{
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue new];
        _queue.name = NSStringFromClass([self class]);
        _requestTasks = [NSMutableArray new];
        _locations = [NSMutableSet new];
        _coordinate = coordinate;
        _completionHandler = completionHandler;
    }
    
    return self;
}

- (void)execute
{
    __weak typeof(self) weakSelf = self;
    
    NSBlockOperation *completedRequest1 = [NSBlockOperation blockOperationWithBlock:^(){}];
    NSURLSessionTask *task1 =
    [NBNetworkManager fetchLocationsForCoordinate:self.coordinate page:0 completionHandler:^(NSSet *locations, NSError *error) {
        if (error) {
            weakSelf.fetchError = error;
        } else {
            [weakSelf.locations unionSet:locations];
        }
        
        [weakSelf.queue addOperation:completedRequest1];
    }];
    if (task1) {
        [self.requestTasks addObject:task1];
    }
    
    NSBlockOperation *completedRequest2 = [NSBlockOperation blockOperationWithBlock:^(){}];
    NSURLSessionTask *task2 =
    [NBNetworkManager fetchLocationsForCoordinate:self.coordinate page:1 completionHandler:^(NSSet *locations, NSError *error) {
        if (error) {
            weakSelf.fetchError = error;
        } else {
            [weakSelf.locations unionSet:locations];
        }
        
        [weakSelf.queue addOperation:completedRequest2];
    }];
    if (task2) {
        [self.requestTasks addObject:task2];
    }
    
    NSBlockOperation *finish = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf finish];
    }];
    [finish addDependency:completedRequest1];
    [finish addDependency:completedRequest2];
    
    [self.queue addOperation:finish];
}

- (void)finish
{
    NBLocationFetchOperationCompletionHandler completionHandler = [self.completionHandler copy];
    if (completionHandler && self.cancelled == NO) {
        NSArray *locations = [self.locations allObjects];
        if (locations.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(locations, nil);
            });
        } else {
            NSError *error = self.fetchError ?: [self noLocationError];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, error);
            });
        }
    }
    
    self.completionHandler = nil;
    [super finish];
}

- (void)cancel
{
    [self.queue cancelAllOperations];
    for (NSURLSessionTask *task in self.requestTasks) {
        [task cancel];
    }
    
    [super cancel];
}

- (NSError *)noLocationError
{
    NSString *description = NSLocalizedString(@"NBNocationFetchOperation.NoLocationDescription", nil);
    NSError *error = [NSError nb_errorWithCode:NBNoLocationErrorCode
                          localizedDescription:description];
    
    return error;
}

@end
