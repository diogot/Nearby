//
//  NBDeviceLocationManager.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBDeviceLocationManager.h"

@import CoreLocation;
#import "NBLocation.h"


NSString * const NBDeviceLocationManagerDidChangedAutrorizationStatusNotification =
@"NBDeviceLocationManagerDidChangedAutrorizationStatusNotification";
NSString * const NBDeviceLocationManagerDidUpdateLocationNotification =
@"NBDeviceLocationManagerDidUpdateLocationsNotification";
NSString * const NBDeviceLocationManagerDidFailNotification =
@"NBDeviceLocationManagerDidFailNotification";
NSString * const NBDeviceLocationManagerDidFailErrorKey =
@"NBDeviceLocationManagerDidFailErrorKey";


@interface NBDeviceLocationManager () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end


@implementation NBDeviceLocationManager

#pragma mark - NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    _locationManager.delegate = nil;
}

#pragma mark - Public Methods

+ (instancetype)sharedManager
{
    static NBDeviceLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NBDeviceLocationManager new];
    });
    
    return manager;
}

+ (NBDeviceLocationAuthorizationStatus)authorizationStatus
{
    NBDeviceLocationAuthorizationStatus status = kNBDeviceLocationAuthorizationStatusDisabled;
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus clStatus = [CLLocationManager authorizationStatus];
        switch (clStatus) {
            case kCLAuthorizationStatusNotDetermined: {
                status = kNBDeviceLocationAuthorizationStatusNotDetermined;
                break;
            }
            case kCLAuthorizationStatusRestricted: {
                status = kNBDeviceLocationAuthorizationStatusRestricted;
                break;
            }
            case kCLAuthorizationStatusDenied: {
                status = kNBDeviceLocationAuthorizationStatusDenied;
                break;
            }
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse: {
                status = kNBDeviceLocationAuthorizationStatusAuthorized;
                break;
            }
            default: {
                LogSoftCrash();
                break;
            }
        }
    }
    
    return status;
}

- (NBLocation *)location
{
    CLLocation *location = self.locationManager.location;
    
    NBLocation *myLocation = [NBLocation locationWithName:NSLocalizedString(@"Me", nil)
                                               coordinate:location.coordinate];
    
    return myLocation;
}

- (void)requestAuthorization
{
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:NBDeviceLocationManagerDidChangedAutrorizationStatusNotification
                          object:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:NBDeviceLocationManagerDidUpdateLocationNotification
                          object:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSDictionary *userInfo = nil;
    if (error) {
        userInfo = @{NBDeviceLocationManagerDidFailErrorKey: error};
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:NBDeviceLocationManagerDidFailNotification
                          object:self
                        userInfo:userInfo];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return NO;
}

@end
