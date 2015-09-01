//
//  NBDeviceLocationManager.h
//  Nearby
//
//  Created by Diogo Tridapalli on 8/31/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

@import Foundation;

@class NBLocation;

/**
 *  Possible authorization status of NBDeviceLocationManager
 *
 *  @see +authorizationStatus
 */
typedef NS_ENUM(NSInteger, NBDeviceLocationAuthorizationStatus){
    /**
     *  Authorization not asked
     */
    kNBDeviceLocationAuthorizationStatusNotDetermined = 0,
    /**
     *  Location services disabled
     */
    kNBDeviceLocationAuthorizationStatusDisabled,
    /**
     *  Is not possible to ask for authorization due to system restrictions
     */
    kNBDeviceLocationAuthorizationStatusRestricted,
    /**
     *  Authorization denied
     */
    kNBDeviceLocationAuthorizationStatusDenied,
    /**
     *  Authorization granted
     */
    kNBDeviceLocationAuthorizationStatusAuthorized
};

/**
 *  Name of the notification that is posted when the autrorization status is changed
 *
 *  @see NBDeviceLocationAuthorizationStatus
 *  @see +authorizationStatus
 */
extern NSString * const NBDeviceLocationManagerDidChangedAutrorizationStatusNotification;

/**
 *  Name of the notification that is posted when there is a new location available
 *
 *  @see -location
 */
extern NSString * const NBDeviceLocationManagerDidUpdateLocationNotification;

/**
 *  Name of the notification that is posted when there is a error to get the location
 *
 *  @see NBDeviceLocationManagerDidFailErrorKey
 */
extern NSString * const NBDeviceLocationManagerDidFailNotification;

/**
 *  Key of the notification userInfo that contains the error in a
 *   NBDeviceLocationManagerDidFailNotification
 *
 *  @see NBDeviceLocationManagerDidFailNotification
 */
extern NSString * const NBDeviceLocationManagerDidFailErrorKey;

/**
 *  Class to manage device location
 */
@interface NBDeviceLocationManager : NSObject

/**
 *  Current device location
 */
@property (nonatomic, readonly) NBLocation *location;

/**
 *  Get the current instance
 *
 *  @return NBDeviceLocationManager
 */
+ (instancetype)sharedManager;

/**
 *  Returns the current authorization status
 *
 *  @see NBDeviceLocationAuthorizationStatus
 *
 *  @return NBDeviceLocationAuthorizationStatus
 */
+ (NBDeviceLocationAuthorizationStatus)authorizationStatus;

/**
 *  Request authorization to access device location
 */
- (void)requestAuthorization;

/**
 *  Start updating device location, when a new location is available a 
 *   notification named NBDeviceLocationManagerDidUpdateLocationNotification is 
 *   posted or a a NBDeviceLocationManagerDidFailNotification when a error is 
 *   occurred You must call stopUpdatingLocation after got a location with 
 *   the desired precision
 *
 *  @see -stopUpdatingLocation
 *  @see NBDeviceLocationManagerDidUpdateLocationNotification
 *  @see NBDeviceLocationManagerDidFailNotification
 */
- (void)startUpdatingLocation;

/**
 *  Stop to update the device location
 *
 *  @see -startUpdatingLocation
 */
- (void)stopUpdatingLocation;

@end
