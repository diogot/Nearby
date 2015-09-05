//
//  ViewController.m
//  Nearby
//
//  Created by Diogo Tridapalli on 8/30/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "ViewController.h"

@import MapKit;

#import "NBLocation+MKAnnotation.h"
#import "NBDeviceLocationManager.h"
#import "NBLocationsFetcher.h"
#import "NBRouteProvider.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) NBLocation *deviceLocation;
@property (nonatomic) NSArray *locations;

@end

@implementation ViewController

#warning REVIEW

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpView];
    [self fetchDeviceLocationAndUpdatedNearbyLocations];
}


#pragma mark - map

- (void)setUpView
{
    CGRect frame = self.view.bounds;
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:frame];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                               UIViewAutoresizingFlexibleWidth;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    self.mapView.delegate = self;
}

- (void)updateMapLocations
{
    MKMapView *map = self.mapView;
    NSArray *annotations = map.annotations;
    if (annotations.count) {
        [map removeAnnotations:annotations];
    }
    NSArray *overlays = map.overlays;
    if (overlays.count) {
        [map removeOverlays:overlays];
    }
    
    NSArray *locations = self.locations;
    if (locations.count == 0) {
        return;
    }
    
    [map addAnnotations:locations];
    
    NSInteger points = locations.count;
    CLLocationCoordinate2D *coords = malloc(points * sizeof(CLLocationCoordinate2D));
    for (NSInteger i=0; i<points; ++i) {
        NBLocation *location = locations[i];
        coords[i] = location.coordinate;
    }
    MKPolyline *path = [MKPolyline polylineWithCoordinates:coords
                                                     count:points];
    free(coords);
    [map addOverlay:path];
    [map setVisibleMapRect:[path boundingMapRect]
               edgePadding:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
                  animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *view = nil;
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        view = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        view.strokeColor = [UIColor redColor];
        view.lineWidth = 3;
    }
    
    return view;
}

#pragma mark - get locations

- (void)fetchDeviceLocationAndUpdatedNearbyLocations
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receivedNewDeviceLocation)
     name:NBDeviceLocationManagerDidUpdateLocationNotification
     object:nil];
    
    NBDeviceLocationManager *manager = [NBDeviceLocationManager sharedManager];
    [manager requestAuthorization];
    [manager startUpdatingLocation];
}

- (void)receivedNewDeviceLocation
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:NBDeviceLocationManagerDidUpdateLocationNotification
     object:nil];
    
    NBDeviceLocationManager *manager = [NBDeviceLocationManager sharedManager];
    self.deviceLocation = manager.location;
    
    [self fetchLocationsNearby:self.deviceLocation];
}

- (void)fetchLocationsNearby:(NBLocation *)location
{
    __weak typeof(self) weakSelf = self;
    [NBLocationsFetcher fetchLocationsForCoordinate:location.coordinate completionHandler:^(NSArray *locations, NSError *error) {
        if (error) {
            [weakSelf showError:error];
            LogSoftCrashWithError(error);
            
            return;
        }
        [NBRouteProvider routeForLocations:locations startingAtLocation:location completionHandler:^(NSArray *path, NSError *error) {
            if (error) {
                [weakSelf showError:error];
                LogSoftCrashWithError(error);
                
                return;
            }
            weakSelf.locations = path;
            [weakSelf updateMapLocations];
        }];
    }];
}

- (void)showError:(NSError *)error
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:error.localizedDescription
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
