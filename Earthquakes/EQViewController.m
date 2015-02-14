//
//  ViewController.m
//  Earthquakes
//
//  Created by Lea Marolt on 2/10/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "EQViewController.h"

@interface EQViewController () {

}

@property (nonatomic, strong) NSMutableArray *allNewEarthquakesArray;
@property (nonatomic, strong) NSMutableArray *oldEarthquakesArray;

@end

@implementation EQViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.allNewEarthquakesArray = [NSMutableArray new];
    [self fetchData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.locationManager startUpdatingLocation];
    [self configureViewArea];
    self.calloutView.hidden = YES;
    
}

- (void) viewDidLayoutSubviews {
    [self configureCardView];
}

- (void)plotEarthquakes {
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
        
    }
    
    for (EQEarthquake  *eq in self.allNewEarthquakesArray) {
        [self.mapView addAnnotation:eq];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    
    else {
    
        static NSString *identifier = @"EQEarthquake";
    
        EQAnnotationView *annotationView = (EQAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[EQAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            //annotationView.canShowCallout = YES;
        
        } else {
        
            annotationView.annotation = annotation;
            [self.mapView deselectAnnotation:annotation animated:YES];
        }
    
        annotationView.image = [UIImage imageNamed:@"GreyAlert"];
        return annotationView;
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    view.image = [UIImage imageNamed:@"RedAlert"];
    self.calloutView.hidden = NO;

    [self changeViewForMKAnnotationView:view];
    
    EQEarthquake *eq = (EQEarthquake *) view.annotation;
    [self dataForEarthquake:eq];
}


- (IBAction)dismiss:(id)sender {
    self.calloutView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    self.calloutView.hidden = YES;
    view.image = [UIImage imageNamed:@"GreyAlert"];
}

#pragma mark - configure views

- (void) configureCardView {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    CGRect frame = CGRectMake(screenWidth*0.0825, screenHeight*0.35, screenWidth*0.8375, screenHeight*0.575);
    self.calloutView.frame = frame;
    
    self.calloutView.layer.cornerRadius = 10;
    self.calloutView.layer.masksToBounds = YES;
}

- (void) configureViewArea {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // for iOS 8 compatibility
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //View Area
    MKCoordinateRegion region = { { 100.0, 100.0 }, { 100.0, 100.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    [self.mapView setRegion:region animated:YES];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    
    [self.mapView setScrollEnabled:YES];
}

- (void) changeViewForMKAnnotationView: (MKAnnotationView *)view {
    MKMapRect rect = [self.mapView visibleMapRect];
    MKMapPoint point = MKMapPointForCoordinate([view.annotation coordinate]);
    rect.origin.x = point.x - rect.size.width * 0.45;
    rect.origin.y = point.y - rect.size.height * 0.15;
    [self.mapView setVisibleMapRect:rect animated:YES];
}

#pragma mark - consume data

- (void) fetchData {
    
    [[EQDataModel sharedModel] fetchEarthquakesWithCompletionBlock:^(NSMutableArray *earthquakes, NSMutableArray *newEarthquakes, NSError *error) {
        if (!error) {
            
            // if there's no network connection, load from cache
            if ([newEarthquakes count] == 0) {
                self.allNewEarthquakesArray = [[EQCache sharedCacheModel] loadArchivedObjectWithFileName:@"OldEarthquakes"];
            }
            else {
                self.allNewEarthquakesArray = newEarthquakes;
            }
            
            [self plotEarthquakes];
            
            [[EQCache sharedCacheModel] archiveObject:newEarthquakes toFileName:@"OldEarthquakes"];
            
        }
        else {
            NSLog(@"I am sad! :%@", [error description]);
        }
    }];
}

- (void) dataForEarthquake:(EQEarthquake *) eq {
    
    if (eq.city) {
        if (eq.state) {
            self.cityAndState.text = [NSString stringWithFormat:@"%@, %@", eq.city, eq.state];
        }
        else {
            self.cityAndState.text = [NSString stringWithFormat:@"%@, %@", eq.city, eq.country];
        }
    }
    else {
        self.cityAndState.text = @"";
    }
    self.time.text = [NSString stringWithFormat:@"%@", eq.time];
    self.depth.text = [NSString stringWithFormat:@"%.02f km", eq.depth];
    self.date.text = [NSString stringWithFormat:@"%@", eq.dateString];
    self.exactCoordinates.text = [NSString stringWithFormat:@"%@", eq.coordinateString];
    self.magnitude.text = [NSString stringWithFormat:@"%.02f", eq.magnitude];
    
    if (eq.magnitudeType) {
        self.magnitudeType.text = [NSString stringWithFormat:@"%@", eq.magnitudeType];
    }
    else {
        self.magnitudeType.text = @"";
    }
    self.place.text = [NSString stringWithFormat:@"%@", eq.place];
    self.timeAgo.text = [NSString stringWithFormat:@"About %@ ago", eq.timeAgo];
    
    CLLocation *pinLocation = [[CLLocation alloc]
                               initWithLatitude:eq.latitude
                               longitude:eq.longitude];
    
    CLLocation *userLocation = [[CLLocation alloc]
                                initWithLatitude:self.mapView.userLocation.coordinate.latitude
                                longitude:self.mapView.userLocation.coordinate.longitude];
    
    CLLocationDistance distance = [pinLocation distanceFromLocation:userLocation];
    
    [self.awayFromYou setText: [NSString stringWithFormat:@"%4.02f km from your location", distance/1000]];
    self.day.text = [self.date.text substringToIndex:2];
    
    self.significance.text = [NSString stringWithFormat:@"%d", eq.significance];
}

@end
