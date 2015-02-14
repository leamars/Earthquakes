//
//  EQEarthquake.m
//  Earthquakes
//
//  Created by Lea Marolt on 2/10/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "EQEarthquake.h"

@implementation EQEarthquake

- (instancetype)initWithEarthquakeDictionary:(NSDictionary *)earthquakeDictionary
{
    self = [super init];
    if (self) {
        
        
        // data we get from the geojson
        
        // from properties
        self.earthquakeId = earthquakeDictionary[@"properties"][@"ids"];
        self.eventDetailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", earthquakeDictionary[@"properties"][@"detail"]]];
        self.magnitude = [earthquakeDictionary[@"properties"][@"mag"] floatValue];
        self.place = earthquakeDictionary[@"properties"][@"place"];
        self.timeStamp = [earthquakeDictionary[@"properties"][@"time"] floatValue];
        self.updatedTimeStamp = [earthquakeDictionary[@"properties"][@"updated"] floatValue];
        self.magnitudeType = earthquakeDictionary[@"properties"][@"magType"];
        self.significance = [earthquakeDictionary[@"properties"][@"sig"] intValue];
        
        // from geometry
        self.longitude = [[earthquakeDictionary[@"geometry"][@"coordinates"] objectAtIndex:0] floatValue];
        self.latitude = [[earthquakeDictionary[@"geometry"][@"coordinates"] objectAtIndex:1] floatValue];
        self.depth = [[earthquakeDictionary[@"geometry"][@"coordinates"] objectAtIndex:2] floatValue];
    
        // TO DO: get nearby cities somehow, maybe
        // do stuff with the json stuff, to fill in other stuff
        self.updatedAt = [self convertSecondsToDateString:self.updatedTimeStamp];
        self.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        self.date = [self convertSecondsToDate:self.timeStamp];        
        self.dateString = [self convertSecondsToDateString:self.timeStamp];
        self.timeAgo = [self timeFromNow];
        self.time = [self timeInHoursFor:self.timeStamp];
        
        self.coordinateString = [self convertCoordinatesToString:self.longitude andLatitude:self.latitude];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * placemark in placemarks) {
                self.address = [placemark name]; // address
                self.city = [placemark locality]; // city
                self.state = [placemark administrativeArea]; // state in USA, otherwise null
                self.country = [placemark country]; // country
            }
        }];
        
    }
    
    return self;
}

#pragma mark - mkannotation delegates

- (MKMapItem *) mapItem {
    NSDictionary *addressDict = @{
                              (NSString *)kABPersonAddressCityKey: @"",
                              };
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = @"event";
    
    return mapItem;
}

- (NSString *)title
{
    return @"";
}
- (NSString *)subtitle
{
    return @"";
}

#pragma mark - helper methods

- (NSString *) timeFromNow {
    
    NSDate *today = [NSDate date];
    NSDate *eqDate = self.date;
    NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:eqDate];;
    
    NSInteger hoursBetweenDates = distanceBetweenDates / 3600;
    NSInteger minutesBetweenDates = (distanceBetweenDates - (hoursBetweenDates * 3600))/60;
        
    return [NSString stringWithFormat:@"%zd hour(s) and %zd minute(s)", hoursBetweenDates, minutesBetweenDates];
}

- (NSString *) timeInHoursFor: (float) timeStamp {
    
    NSTimeInterval interval = timeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *EQtimeString = [formatter stringFromDate:date];
    
    return EQtimeString;
    
}

- (NSString *) convertCoordinatesToString: (float) longitude andLatitude: (float) latitude {
    
    int latSeconds = (int)round(latitude * 3600);
    int latDegrees = latSeconds / 3600;
    latSeconds = abs(latSeconds % 3600);
    int latMinutes = latSeconds / 60;
    latSeconds %= 60;
    
    int longSeconds = (int)round(longitude * 3600);
    int longDegrees = longSeconds / 3600;
    longSeconds = abs(longSeconds % 3600);
    int longMinutes = longSeconds / 60;
    longSeconds %= 60;
    
    NSString *stringCoordinates = [NSString stringWithFormat:@"%i° %i' %i\", %i° %i' %i\"", latDegrees, latMinutes, latSeconds, longDegrees, longMinutes, longSeconds];
    
    return stringCoordinates;
}

- (NSString *) convertSecondsToDateString: (float) timeStamp {
    
    NSTimeInterval interval = timeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [NSDateFormatter new];
    // TO DO: Potentially change the formatter
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *EQdateString = [formatter stringFromDate:date];
    
    return EQdateString;
}

- (NSDate *) convertSecondsToDate: (float) timeStamp {
    
    NSTimeInterval interval = timeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    return date;
}

#pragma mark - Serializing and Deserializing

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        self.earthquakeId = [aDecoder decodeObjectForKey:@"id"];
        self.eventDetailURL = [aDecoder decodeObjectForKey:@"detailURL"];
        self.place = [aDecoder decodeObjectForKey:@"place"];
        self.magnitudeType = [aDecoder decodeObjectForKey:@"magnitudeType"];
        self.updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.dateString = [aDecoder decodeObjectForKey:@"dateString"];
        self.timeAgo = [aDecoder decodeObjectForKey:@"timeAgo"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.coordinateString = [aDecoder decodeObjectForKey:@"coordinateString"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        
        // floats & ints
        self.longitude = [[aDecoder decodeObjectForKey:@"longitude"] floatValue];
        self.latitude = [[aDecoder decodeObjectForKey:@"latitude"] floatValue];
        self.depth = [[aDecoder decodeObjectForKey:@"depth"] floatValue];
        self.timeStamp = [[aDecoder decodeObjectForKey:@"timeStamp"] floatValue];
        self.updatedTimeStamp = [[aDecoder decodeObjectForKey:@"updatedTimeStamp"] floatValue];
        self.significance = [[aDecoder decodeObjectForKey:@"significance"] intValue];
        self.magnitude = [[aDecoder decodeObjectForKey:@"magnitude"] floatValue];
        

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.earthquakeId forKey:@"id"];
    [aCoder encodeObject:self.eventDetailURL forKey:@"detailURL"];
    [aCoder encodeObject:self.place forKey:@"place"];
    [aCoder encodeObject:self.magnitudeType forKey:@"magnitudeType"];
    [aCoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.dateString forKey:@"dateString"];
    [aCoder encodeObject:self.timeAgo forKey:@"timeAgo"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.coordinateString forKey:@"coordinateString"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.country forKey:@"country"];
    
    // annoying floats/ints
    [aCoder encodeObject:[NSNumber numberWithFloat:self.magnitude] forKey:@"magnitude"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.timeStamp] forKey:@"timeStamp"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.updatedTimeStamp] forKey:@"updatedTimeStamp"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.significance] forKey:@"significance"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.longitude] forKey:@"longitude"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.latitude] forKey:@"latitude"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.depth] forKey:@"depth"];
    
}


@end
