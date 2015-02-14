//
//  EQAnnotationView.h
//  Earthquakes
//
//  Created by Lea Marolt on 2/13/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "EQEarthquake.h"

@interface EQAnnotationView : MKAnnotationView

- (instancetype)initWithMagnitudeOfEarthquake:(EQEarthquake *) eq;

@end
