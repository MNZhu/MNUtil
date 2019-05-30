//
//  MNConfigViewController.m
//  MNUtil
//
//  Created by jacknan on 2019/4/23.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNDebugConfigViewController.h"
#import "MNDebugConfigConst.h"
#import "MNDebugConfigModel.h"
#import "MNAppLogViewController.h"
#import "MNPickerView.h"
#import "MNLogManager.h"

@interface MNDebugConfigViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *configArr;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MNDebugConfigViewController

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:self];
        return (MNDebugConfigViewController *)na;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfigs];    //初始化配置项
    [self initView];       //初始化view
}

- (void)initConfigs
{
    self.configArr = [NSMutableArray array];
    
    //baseUrl
    [self addConfigModelWithKey:BaseUrl ConfigType:ConfigTypeTextField];
    
    //version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    version = [NSString stringWithFormat:@"%@(Build%@)",version,build];
    [self addConfigModelWithKey:Version ConfigType:ConfigTypeLabel Value:version];
    
    //build
    
//    [self addConfigModelWithKey:Build ConfigType:ConfigTypeLabel Value:build];
    
    //guidePage
    [self addConfigModelWithKey:ShowGuidePage ConfigType:ConfigTypeSwitch];
    
    //language
    [self addConfigModelWithKey:Language ConfigType:ConfigTypeArrow];
    
    //app log level
    NSNumber *num = [NSUserDefaults.standardUserDefaults objectForKey:AppLogLevel];
    [self addConfigModelWithKey:AppLogLevel ConfigType:ConfigTypeArrow Value:num];
    
    //app log
    [self addConfigModelWithKey:AppLogFiles ConfigType:ConfigTypeArrow];
}

- (void)addConfigModelWithKey:(NSString *)key ConfigType:(ConfigType)type Value:(id)value
{
    MNDebugConfigModel *model = [[MNDebugConfigModel alloc] init];
    model.key = key;
    model.type = type;
    if (value) {
        model.value = value;
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        model.value = [userDefaults objectForKey:key];
    }
    [self.configArr addObject:model];
}

- (void)addConfigModelWithKey:(NSString *)key ConfigType:(ConfigType)type
{
    [self addConfigModelWithKey:key ConfigType:type Value:nil];
}

- (void)initView
{
    self.view.backgroundColor = UIColor.blackColor;
    self.title = @"配置";
    //backBtn
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //completeBtn
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(completeAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
    //table view
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColor.blackColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height);
    [self.view addSubview:tableView];
    
    
    //header
//    UILabel *la = [[UILabel alloc] init];
//    la.text = [@"bundleid:" stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
//    la.textAlignment = NSTextAlignmentCenter;
//    la.frame = CGRectMake(0, 0, 0, 20);
//    la.textColor = UIColor.lightGrayColor;
//    self.tableView.tableHeaderView = la;
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeAction
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (MNDebugConfigModel *model in self.configArr) {
        if (model.key) {
            [userDefaults setObject:model.value forKey:model.key];
        }
    }
    [self backAction];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    typeof(self) weakSelf = self;
    MNDebugConfigModel *model = self.configArr[indexPath.row];
    if ([model.key isEqualToString:AppLogFiles]) {
        MNAppLogViewController *vc = [[MNAppLogViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([model.key isEqualToString:AppLogLevel]) {
        [MNPickerView showInView:UIApplication.sharedApplication.keyWindow WithTitleArr:MNLogManager.logLevels Complete:^(NSInteger index) {
            model.value = @(index);
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.configArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get config
    MNDebugConfigModel *model = self.configArr[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColor.blackColor;
    CGFloat height = tableView.rowHeight;
    CGFloat width = tableView.bounds.size.width;
    //title
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = model.key;
    titleLab.textColor = UIColor.whiteColor;
    CGSize size = [titleLab sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    titleLab.frame = CGRectMake(5, 0, size.width + 10, height);
    [cell addSubview:titleLab];
    
    switch (model.type) {
        case ConfigTypeNone:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case ConfigTypeLabel:
        {
            UILabel *lab = [[UILabel alloc] init];
            lab.text = model.value;
            lab.textColor = UIColor.whiteColor;
            lab.textAlignment = NSTextAlignmentRight;
            lab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), 5, width - titleLab.bounds.size.width - 10, height - 10);
            [cell addSubview:lab];
        }
            break;
        case ConfigTypeTextField:
        {
            UITextField *tf = [[UITextField alloc] init];
            tf.placeholder = @"https://example.com:8080";
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textfieldChanged:) name:UITextFieldTextDidChangeNotification object:tf];
            tf.backgroundColor = UIColor.grayColor;
            tf.textColor = UIColor.whiteColor;
            tf.textAlignment = NSTextAlignmentCenter;
            tf.clearButtonMode = UITextFieldViewModeAlways;
            tf.keyboardType = UIKeyboardTypeURL;
            tf.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), 5, width - titleLab.bounds.size.width - 10, height - 10);
            [cell addSubview:tf];
            tf.text = model.value;
        }
            break;
        case ConfigTypeSwitch:
        {
            UISwitch *switchBtn = [[UISwitch alloc]init];
            switchBtn.frame = CGRectMake(width - 56, (height-31)*0.5, 51, 31);
            NSNumber *num = model.value;
            [switchBtn setOn:num.boolValue];
            [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchBtn];
        }
            break;
        case ConfigTypeArrow:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([model.key isEqualToString:AppLogLevel]) {
                NSNumber *num = model.value;
                UILabel *la = [[UILabel alloc] init];
                la.text = [MNLogManager getLevelTypeString:num.integerValue];
                la.textColor = UIColor.lightGrayColor;
                la.textAlignment = NSTextAlignmentRight;
                la.frame = CGRectMake(width - 110, 0, 80, height);
                [cell addSubview:la];
            }
        }
            break;
        default:
            break;
    }
    
    //line
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, height-1, width, 1);
    line.backgroundColor = [UIColor grayColor];
    [cell addSubview:line];
    return cell;
}
//所有带switch按钮的cell都走这里
- (void)switchAction:(UISwitch *)switchBtn
{
    UITableViewCell *cell = (UITableViewCell *)switchBtn.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MNDebugConfigModel *model = self.configArr[indexPath.row];
    model.value = @(switchBtn.isOn);
}

//所有带textfield的cell都走这
- (void)textfieldChanged:(NSNotification *)noti
{
    UITextField *tf = noti.object;
    UITableViewCell *cell = (UITableViewCell *)tf.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MNDebugConfigModel *model = self.configArr[indexPath.row];
    model.value = tf.text;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
