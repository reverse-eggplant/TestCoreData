//
//  SXViewController.m
//  TestCoreData
//
//  Created by malone on 14-5-12.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import "SXViewController.h"
#import "SXAppDelegate.h"

#import "Entity.h"

@interface SXViewController ()
{
    UITextField * titleTF;
    UITextField * contentTF;
    UIButton * addButton;
    UIButton * queryButton;
    Entity * currentEntity;
}

@property (strong,nonatomic)SXAppDelegate * myAppDelegate;
@property (strong,nonatomic)NSMutableArray  * entities;

@end

@implementation SXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myAppDelegate = (SXAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self addSuviews];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTFFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)addSuviews{
    
    titleTF = [[UITextField alloc]initWithFrame:CGRectMake(40.0, 40.0, 240.0, 40.0)];
    titleTF.layer.borderColor = [UIColor redColor].CGColor;
    titleTF.layer.borderWidth = 2.0;
    titleTF.placeholder = @"在此输入标题";
    [self.view addSubview:titleTF];
    
    contentTF = [[UITextField alloc]initWithFrame:CGRectMake(40.0, 100.0, 240.0, 40.0)];
    contentTF.layer.borderColor = [UIColor greenColor].CGColor;
    contentTF.layer.borderWidth = 2.0;
    contentTF.placeholder = @"详细内容";
    [self.view addSubview:contentTF];
    
    
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor redColor];
    [addButton addTarget:self action:@selector(addToDB:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(100.0, 200.0, 120.0, 40.0);
    [self.view addSubview:addButton];
    
    
    queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryButton setTitle:@"查询" forState:UIControlStateNormal];
    queryButton.backgroundColor = [UIColor orangeColor];
    [queryButton addTarget:self action:@selector(queryFromDB:) forControlEvents:UIControlEventTouchUpInside];

    queryButton.frame = CGRectMake(100.0, 260.0, 120.0, 40.0);
    [self.view addSubview:queryButton];
    
    UIButton * updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"更新" forState:UIControlStateNormal];
    updateButton.backgroundColor = [UIColor grayColor];
    [updateButton addTarget:self action:@selector(updateEntity) forControlEvents:UIControlEventTouchUpInside];
    updateButton.frame = CGRectMake(100.0, 320.0, 120.0, 40.0);
    [self.view addSubview:updateButton];
    
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor greenColor];
    [deleteButton addTarget:self action:@selector(deleteEntity) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(100.0, 380.0, 120.0, 40.0);
    [self.view addSubview:deleteButton];
}

//添加
- (void)addToDB:(UIButton *)sender
{
    //让CoreData在上下文中创建一个新对象(托管对象)
    Entity * entity = (Entity *)[NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:self.myAppDelegate.managerObjectContext];
    currentEntity = entity;

    [entity setTitle:titleTF.text];
    [entity setBody:contentTF.text];
    [entity setCreationDate:[NSDate date]];
    
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    NSError * error;
    BOOL isSaveSuccess = [self.myAppDelegate.managerObjectContext save:&error];
    
    if (isSaveSuccess) {
        NSLog(@"SaveSuccess");
    }else{
        NSLog(@"error :%@ , %@",error,[error userInfo]);
    }
    
}

//查询
- (void)queryFromDB:(UIButton *)sender
{
    //创建取回数据请求
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    
    //设置要检索哪种类型的实体对象
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.myAppDelegate.managerObjectContext];
    
    //设置请求实体
    [request setEntity:entityDescription];
    
    //指定对结果的排序方式
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.myAppDelegate.managerObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);

    }
    
    self.entities = mutableFetchResult;

    NSLog(@"The count of entry:%i",[self.entities count]);

    for (Entity * entity in  self.entities) {
        NSLog(@"Title:%@---Content:%@---Date:%@",entity.title,entity.body,entity.creationDate);
    }
    
    
    
}

//更新实体
- (void)updateEntity
{
    if (currentEntity != nil) {
        
        [currentEntity setTitle:titleTF.text];
        [currentEntity setBody:contentTF.text];
        [currentEntity setCreationDate:[NSDate date]];
        
        NSError * error = nil;
        if (![self.myAppDelegate.managerObjectContext save:&error]) {
            NSLog(@"error:%@ %@",error,[error userInfo]);
            
        }
    }
    
}

//删除操作
- (void)deleteEntity
{
    if (currentEntity != nil) {
        [self.myAppDelegate.managerObjectContext deleteObject:currentEntity];
        [self.entities removeObject:currentEntity];
        
        currentEntity = [self.entities lastObject];
        
        NSError * error = nil;
        if (![self.myAppDelegate.managerObjectContext save:&error]) {
            NSLog(@"error:%@ %@",error,[error userInfo]);
            
        }
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)resignTFFirstResponder
{
    [titleTF resignFirstResponder];
    [contentTF resignFirstResponder];
}
@end
