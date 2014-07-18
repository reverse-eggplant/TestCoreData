//
//  SXAppDelegate.h
//  TestCoreData
//
//  Created by malone on 14-5-12.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface SXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//数据模型对象
@property (strong, nonatomic) NSManagedObjectModel * managerObjectModal;

//上下文对象
@property (strong, nonatomic) NSManagedObjectContext * managerObjectContext;

//持久性存储区
@property (strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;



//managedObjectModel的初始化赋值函数
- (NSManagedObjectModel *)managerObjectModal;

//managedObjectContext的初始化赋值函数
- (NSManagedObjectContext *)managerObjectContext;

//初始化Core Data使用的数据库
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;


@end
