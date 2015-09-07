//
//  NBMapViewController.m
//  Nearby
//
//  Created by Diogo Tridapalli on 9/6/15.
//  Copyright (c) 2015 Diogo Tridapalli. All rights reserved.
//

#import "NBMapViewController.h"

@import MapKit;

#import "NBLocation.h"
#import "NBRouteListViewController.h"
#import "NBDeviceLocationManager.h"
#import "NBLocationsFetcher.h"
#import "NBRoutePlanner.h"

static CGFloat const kInfoHeight = 60;
static CGFloat const kInset = 20;

@interface NBMapViewController () <MKMapViewDelegate, NBRouteListViewControllerDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic) UIEdgeInsets mapInset;
@property (nonatomic) MKPolyline *routePath;

@property (nonatomic) NBRouteListViewController *routeListController;

@property (nonatomic) id<NSObject> deviceLocationObserver;

@property (nonatomic) NBLocation *deviceLocation;
@property (nonatomic) NSArray *locations;

@property (nonatomic, weak) NSOperation *fetchOperation;
@property (nonatomic, weak) NSOperation *routePlanningOperation;

@end

@implementation NBMapViewController

#pragma mark - UIViewController

- (void)awakeFromNib
{
    self.title = NSLocalizedString(@"NBMapViewController.Title", );
    self.mapInset = UIEdgeInsetsMake(kInset, kInset, kInfoHeight+kInset, kInset);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(fetchDeviceLocationAndUpdatedNearbyLocations)];
    [self setUpRouteList];
    
    
    [self fetchDeviceLocationAndUpdatedNearbyLocations];
}

- (void)setUpRouteList
{
    NBRouteListViewController *routeList = [NBRouteListViewController controller];
    routeList.delegate = self;
    
    self.routeListController = routeList;
    
    UIView *view = self.view;
    UIView *listView = routeList.view;
    listView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:routeList];
    [view addSubview:listView];
    
    UIView *lineView = [UIView new];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(listView, lineView);
    NSDictionary *metrics = @{@"height": @(kInfoHeight),
                              @"one": @(0.5)};
    
    [view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[listView]|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|"
                                             options:0
                                             metrics:metrics
                                               views:views]];
    [view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(one)][listView(height)]|"
                                             options:0
                                             metrics:metrics
                                               views:views]];
    
    [routeList didMoveToParentViewController:self];
}

#pragma mark - UI

- (void)cleanMap
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
}

- (void)updateMapLocations
{
    [self cleanMap];
    
    NSArray *locations = self.locations;
    if (locations.count == 0) {
        return;
    }
    
    MKMapView *map = self.mapView;
    [map addAnnotations:locations];
}

- (void)updateMapRoute
{
    MKMapView *map = self.mapView;
    MKPolyline *path = self.routePath;
    if (path) {
        [map removeOverlay:path];
        path = nil;
    }

    NSArray *locations = self.locations;
    if (locations.count == 0) {
        return;
    }

    NSInteger points = locations.count;
    CLLocationCoordinate2D *coords = malloc(points * sizeof(CLLocationCoordinate2D));
    for (NSInteger i=0; i<points; ++i) {
        NBLocation *location = locations[i];
        coords[i] = location.coordinate;
    }
    path = [MKPolyline polylineWithCoordinates:coords
                                         count:points];
    free(coords);
    self.routePath = path;
    
    [map addOverlay:path];
    [map setVisibleMapRect:[path boundingMapRect]
               edgePadding:self.mapInset
                  animated:YES];
    
    [self updateRouteList];
}

- (void)updateRouteList
{
    NBRouteListViewController *routeList = self.routeListController;
    routeList.locations = self.locations;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *view = nil;
    if (overlay == self.routePath) {
        view = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        view.strokeColor = [UIColor redColor];
        view.lineWidth = 3;
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[NBLocation class]] == NO) {
        
        return;
    }

    NBLocation *location = (NBLocation *)view.annotation;
    [self.routeListController setHighlightedLocation:location animated:YES];
}

#pragma mark - NBRouteListViewControllerDelegate

- (void)didHighlightLocation:(NBLocation *)location
       onRouteListController:(NBRouteListViewController *)controller
{
    NSArray *annotatios = @[location];
    
    self.mapView.selectedAnnotations = annotatios;
    [self.mapView showAnnotations:annotatios animated:YES];
}

- (void)didSelectedLocation:(NBLocation *)location
      onRouteListController:(NBRouteListViewController *)controller
{
    // TODO: Show location details
    NBLogD(@"Show details for location: %@", location);
}

#pragma mark - get locations

- (void)fetchDeviceLocationAndUpdatedNearbyLocations
{
    [self cancelCurrentFetch];
    [self getDeviceLocation];
}

#pragma mark - Device Location
// TODO: extract this section to a new class

- (void)getDeviceLocation
{
    switch ([NBDeviceLocationManager authorizationStatus]) {
        case kNBDeviceLocationAuthorizationStatusNotDetermined: {
            NBDeviceLocationManager *manager = [NBDeviceLocationManager sharedManager];
            [manager requestAuthorization];
            // The absence of a break here is intentional
        }
        case kNBDeviceLocationAuthorizationStatusAuthorized: {
            [self waitForNewDeviceLocation];
            break;
        }
        case kNBDeviceLocationAuthorizationStatusDenied: {
            NSString *title = NSLocalizedString(@"NBMapViewController.GPSDeniedPopup.Title", );
            NSString *message = NSLocalizedString(@"NBMapViewController.GPSDeniedPopup.Message", );
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:title
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *notNow =
            [UIAlertAction actionWithTitle:NSLocalizedString(@"NNMapViewController.GPSDeniedPopup.NotNow", )
                                                             style:UIAlertActionStyleDefault
                                   handler:nil];
            [alert addAction:notNow];
            
            UIAlertAction *goToSettings =
            [UIAlertAction actionWithTitle:NSLocalizedString(@"NNMapViewController.GPSDeniedPopup.GoToSetting", )
                                     style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                       NSURL *settings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                       [[UIApplication sharedApplication] openURL:settings];
                                   }];
            [alert addAction:goToSettings];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case kNBDeviceLocationAuthorizationStatusRestricted: {
            NSString *title = NSLocalizedString(@"NNMapViewController.GPSRestrictedPopup.Title", );
            NSString *message = NSLocalizedString(@"NNMapViewController.GPSRestrictedPopup.Message", );
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:title
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case kNBDeviceLocationAuthorizationStatusDisabled: {
            NSString *title = NSLocalizedString(@"NNMapViewController.GPSDisabledPopup.Title", );
            NSString *message = NSLocalizedString(@"NNMapViewController.GPSDisabledPopup.Message", );
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:title
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

- (void)waitForNewDeviceLocation
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    if (self.deviceLocationObserver) {
        [center removeObserver:self.deviceLocationObserver];
    }

    __weak typeof(self) weakSelf = self;
    
    self.deviceLocationObserver =
    [center addObserverForName:NBDeviceLocationManagerDidUpdateLocationNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        if (weakSelf.deviceLocationObserver) {
            [center removeObserver:weakSelf.deviceLocationObserver];
        }

        NBDeviceLocationManager *manager = [NBDeviceLocationManager sharedManager];
        [manager stopUpdatingLocation];
        
        weakSelf.deviceLocation = manager.location;
    }];
    
    NBDeviceLocationManager *manager = [NBDeviceLocationManager sharedManager];
    [manager startUpdatingLocation];
}


#pragma mark - Fetch Locations and sort

- (void)setDeviceLocation:(NBLocation *)deviceLocation
{
    _deviceLocation = deviceLocation;

    CLLocationCoordinate2D coordintate = deviceLocation.coordinate;
    
    if (CLLocationCoordinate2DIsValid(coordintate)) {
        [self.mapView setCenterCoordinate:coordintate animated:YES];
    }
    
    [self fetchLocationsNearby:deviceLocation];
}

- (void)cancelCurrentFetch
{
    [self.fetchOperation cancel];
    [self.routePlanningOperation cancel];
}

- (void)fetchLocationsNearby:(NBLocation *)location
{
    [self cleanMap];
    
    __weak typeof(self) weakSelf = self;
    
    self.fetchOperation =
    [NBLocationsFetcher fetchLocationsForCoordinate:location.coordinate completionHandler:^(NSArray *locations, NSError *error) {
        if (error) {
            [weakSelf showError:error];
            LogSoftCrashWithError(error);
            
            return;
        }
        
        weakSelf.locations = locations;
        [weakSelf updateMapLocations];
        
        weakSelf.routePlanningOperation =
        [NBRoutePlanner routeForLocations:locations startingAtLocation:location completionHandler:^(NSArray *path, NSError *error) {
            if (error) {
                [weakSelf showError:error];
                LogSoftCrashWithError(error);
                
                return;
            }
            weakSelf.locations = path;
            [weakSelf updateMapRoute];
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
