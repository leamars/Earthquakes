//
//  EQDataModel.h
//  Earthquakes
//
//  Created by Lea Marolt on 2/10/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EQClient.h"
#import "EQEarthquake.h"

@interface EQDataModel : NSObject

typedef void (^FetchEarthquakesCompletionBlock) (NSMutableArray *earthquakes, NSMutableArray *newEarthquakes, NSError *error);
typedef void (^FetchEarthquakeDetailsCompletionBlock) (NSMutableArray *earthquakes, NSMutableArray *earthquakeDetails, NSError *error);

@property (nonatomic, strong) NSMutableArray *earthquakes;

+ (EQDataModel *)sharedModel;
- (void)fetchEarthquakesWithCompletionBlock:(FetchEarthquakesCompletionBlock)completion;
- (void)fetchEarthquakeDetailsWithCompletionBlock:(FetchEarthquakeDetailsCompletionBlock)completion;

@end
