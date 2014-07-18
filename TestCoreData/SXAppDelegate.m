//
//  SXAppDelegate.m
//  TestCoreData
//
//  Created by malone on 14-5-12.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import "SXAppDelegate.h"

@implementation SXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //这个方法定义的是当应用程序退到后台时将执行的方法，按下home键执行（通知中心来调度）
    //实现此方法的目的是将托管对象上下文存储到数据存储区，防止程序退出时有未保存的数据
    
    NSError * error = nil;
    
    if (nil != _managerObjectContext) {
        //hasChanges方法是检查是否有未保存的上下文更改，如果有，则执行save方法保存上下文
        if ([_managerObjectContext hasChanges] && ![_managerObjectContext save:&error]) {
            NSLog(@"error :%@ , %@",error,[error userInfo]);
            abort();

        }
    }
}



- (NSManagedObjectModel *)managerObjectModal{
    if (_managerObjectModal != nil) {
        return _managerObjectModal;
    }
    
    _managerObjectModal = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managerObjectModal;
    
}

- (NSManagedObjectContext *)managerObjectContext{
    
    if (_managerObjectContext != nil) {
        return  _managerObjectContext;
    }
    
    _managerObjectContext = [[NSManagedObjectContext alloc]init];
    
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if (nil != coordinator) {
        [_managerObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managerObjectContext;
    
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    
    
    
    if (_persistentStoreCoordinator != nil) {
        return  _persistentStoreCoordinator;
    }
    
    //得到数据库的路径
    NSString * docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL * storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CDMaLong.sqlite"]];
    NSError * error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managerObjectModal]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"error :%@ , %@",error,[error userInfo]);
    }
    
    return _persistentStoreCoordinator;
    
}

@end
