//
//  EQClient.h
//  Earthquakes
//
//  Created by Lea Marolt on 2/10/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface EQClient : AFHTTPSessionManager

+ (EQClient *)sharedClient;

@end
