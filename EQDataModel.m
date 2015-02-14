//
//  EQDataModel.m
//  Earthquakes
//
//  Created by Lea Marolt on 2/10/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "EQDataModel.h"

@implementation EQDataModel

+ (EQDataModel *)sharedModel {
    static EQDataModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[EQDataModel alloc] init];
    });
    
    return _sharedModel;
}


- (id)init
{
    self  = [super init];
    if (self) {
    }
    return self;
}

- (void)fetchEarthquakesWithCompletionBlock:(FetchEarthquakesCompletionBlock)completion
{
    
    NSMutableArray *newEarthquakes = [NSMutableArray new];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [formatter stringFromDate:today];
    
    [[EQClient sharedClient] GET:@"query?"
                         parameters:@{@"format": @"geojson",
                                      @"starttime": todayString
                                      }
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    NSArray *earthquakeArray = responseObject[@"features"];
                                    [earthquakeArray enumerateObjectsUsingBlock:^(NSDictionary *earthquakeDictionary, NSUInteger idx, BOOL *stop) {
                                        
                                        EQEarthquake *earthquake = [[EQEarthquake alloc] initWithEarthquakeDictionary:earthquakeDictionary];
                                        
                                        [newEarthquakes addObject:earthquake];
                                        [[[EQDataModel sharedModel] earthquakes] addObject:earthquake];
                                    }];
                                    completion([[EQDataModel sharedModel] earthquakes], newEarthquakes, nil);
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                completion(nil, nil, error);
                            }];
}

- (void)fetchEarthquakeDetailsWithCompletionBlock:(FetchEarthquakeDetailsCompletionBlock)completion
{
    
    NSMutableArray *earthquakeDetails = [NSMutableArray new];
    
    [[EQClient sharedClient] GET:@"query?"
                      parameters:@{@"format": @"geojson",
                                   @"eventid": @"nc72392645"
                                   }
                         success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             if (httpResponse.statusCode == 200) {
                                 NSArray *earthquakeDetailsArray = responseObject[@"properties"];
                                 
                                 NSLog(@"DETAILS ARRAY: %@", earthquakeDetailsArray);
                                 
                                 [earthquakeDetailsArray enumerateObjectsUsingBlock:^(NSDictionary *earthquakeDetailsDictionary, NSUInteger idx, BOOL *stop) {
                                     
                                     NSString *earthquakeDetail = @"";
                                     
                                     [earthquakeDetails addObject:earthquakeDetail];
                                     [[[EQDataModel sharedModel] earthquakes] addObject:earthquakeDetail];
                                 }];
                                 completion([[EQDataModel sharedModel] earthquakes], earthquakeDetails, nil);
                             }
                             
                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                             
                             completion(nil, nil, error);
                         }];
}

@end
