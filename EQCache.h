//
//  EQCache.h
//  Earthquakes
//
//  Created by Lea Marolt on 2/14/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EQCache : NSObject

+ (EQCache *) sharedCacheModel;

- (void) archiveObject:(id)object toFileName:(NSString *)fileName;
- (id) loadArchivedObjectWithFileName:(NSString *)fileName;

@end
