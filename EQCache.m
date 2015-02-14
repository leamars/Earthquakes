//
//  EQCache.m
//  Earthquakes
//
//  Created by Lea Marolt on 2/14/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "EQCache.h"

@implementation EQCache

+ (EQCache *)sharedCacheModel {
    static EQCache *_sharedCacheModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCacheModel = [[EQCache alloc] init];
    });
    
    return _sharedCacheModel;
}

- (id)init
{
    self  = [super init];
    if (self) {
    }
    return self;
}

- (void) archiveObject:(id)object toFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

- (id) loadArchivedObjectWithFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
    
    id cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return cachedObject;
}

@end
