//
//  Entity.h
//  TestCoreData
//
//  Created by malone on 14-5-12.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * body;

@end
