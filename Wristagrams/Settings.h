//
//  Settings.h
//  Wristagrams
//
//  Created by admin on 2015-05-21.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSNumber * purchased;
@property (nonatomic, retain) NSNumber * showTip;

@end
