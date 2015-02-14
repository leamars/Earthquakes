//
//  EQEarthquake.h
//  Earthquakes
//
//  Created by Lea Marolt on 2/10/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EQDataModel.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface EQEarthquake : NSObject <MKAnnotation>

@property (nonatomic) float magnitude;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic, strong) NSString *coordinateString;
@property (nonatomic) float depth;
@property (nonatomic) float timeStamp;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *place; // place: "0km NNE of The Geysers, California",
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *timeAgo;
@property (nonatomic, strong) NSString *earthquakeId;
@property (nonatomic, strong) NSURL *eventDetailURL;
@property (nonatomic) float updatedTimeStamp;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *magnitudeType;
@property (nonatomic) int significance;
@property (nonatomic) float distanceFromYou;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;

- (instancetype)initWithEarthquakeDictionary:(NSDictionary *)earthquakeDictionary;
- (MKMapItem *)mapItem;

@end
