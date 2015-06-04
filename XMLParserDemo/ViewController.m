//
//  ViewController.m
//  XMLParserDemo
//
//  Created by gongguifei on 15/6/3.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import "ViewController.h"
#import "BookParserOperation.h"
#import "Book.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BookParserOperation *bookParseOperation;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ViewController

#pragma mark - Life cicle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"Books";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];

    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    self.bookParseOperation = [[BookParserOperation alloc] initWithData:[self getXMLData]];
    
    __weak ViewController *weakSelf = self;
    [self.bookParseOperation setCompletionBlock:^{
        ViewController *strongSelf = weakSelf;
        
        [strongSelf.tableView reloadData];
    }];
    
    [self.operationQueue addOperation:self.bookParseOperation];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _operationQueue;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
- (NSData *)getXMLData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"xml"];
    
    return [NSData dataWithContentsOfFile:path];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookParseOperation.bookList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    Book *book = [self.bookParseOperation.bookList objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.summary;
    
    return cell;
    
}

@end
