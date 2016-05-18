//
//  Cell.h
//  Wristagrams
//
//  Created by admin on 2015-05-21.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cell : NSManagedObject

@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * imageData;

@end
