//
//  MKMapView+ZoomLevel.m
//  Earthquakes
//
//  Created by Lea Marolt on 2/13/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "MKMapView+ZoomLevel.h"

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@implementation MKMapView (ZoomLevel)

- (double) zoomLevel
{
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}

@end
