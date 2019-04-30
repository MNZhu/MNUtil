//
//  MNAppLogViewController.m
//  MNUtil
//
//  Created by jacknan on 2019/4/30.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNAppLogViewController.h"
#import "MNLogManager.h"


@interface MNAppLogViewController () <UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation MNAppLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self.tableView reloadData];
}

- (void)initView
{
    self.title = @"AppLog";
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.frame = self.view.bounds;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL *file_URL = [NSURL fileURLWithPath:self.dataArr[indexPath.row]];
    if (file_URL != nil) {
        if (_documentController == nil) {
            _documentController = [[UIDocumentInteractionController alloc] init];
            _documentController = [UIDocumentInteractionController interactionControllerWithURL:file_URL];
            _documentController.delegate = self;
        }else {
            _documentController.URL = file_URL;
        }
        [_documentController presentPreviewAnimated:YES];
    }
//    MNAppLogDetailViewController *vc = [MNAppLogDetailViewController viewControllerWithFilePath:self.dataArr[indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"MNAppLogViewControllerCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.dataArr[indexPath.row] lastPathComponent];
    return cell;
}


#pragma mark lazy
- (NSArray *)dataArr
{
    return [MNLogManager getAllAppLogFilePath];
}

#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}

-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    NSLog(@"documentInteractionControllerDidEndPreview");
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    NSLog(@"documentInteractionControllerDidDismissOpenInMenu");
    return self.view.frame;
}

@end
