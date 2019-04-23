//
//  MNConfigViewController.m
//  MNUtil
//
//  Created by jacknan on 2019/4/23.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNConfigViewController.h"
#import "MNConfigConst.h"
#import "MNConfigModel.h"

@interface MNConfigViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *configArr;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MNConfigViewController

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"https://jacknan.top" forKey:BaseUrl];
//    [userDefaults setObject:@"v1.0.21" forKey:Version];
//    [userDefaults setObject:@NO forKey:ShowGuidePage];
    
    [self initConfigs];
    [self initView];
}

- (void)initConfigs
{
    self.configArr = [NSMutableArray array];
    
    //baseUrl
    [self addConfigModelWithKey:BaseUrl ConfigType:ConfigTypeTextField];
    
    //version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self addConfigModelWithKey:Version ConfigType:ConfigTypeLabel Value:version];
    
    //build
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self addConfigModelWithKey:Build ConfigType:ConfigTypeLabel Value:build];
    
    //guidePage
    [self addConfigModelWithKey:ShowGuidePage ConfigType:ConfigTypeSwitch];
    
    //language
    [self addConfigModelWithKey:Language ConfigType:ConfigTypeNone];
}

- (void)addConfigModelWithKey:(NSString *)key ConfigType:(ConfigType)type Value:(id)value
{
    MNConfigModel *model = [[MNConfigModel alloc] init];
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
    [UIApplication.sharedApplication setStatusBarHidden:NO];
    //navigation bar
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    [navBar setBackgroundColor:[UIColor grayColor]];
    navBar.backgroundColor = UIColor.blackColor;
    navBar.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height, self.view.bounds.size.width, 44);
    //topItem
    UINavigationItem *topItem = [[UINavigationItem alloc]initWithTitle:@"配置"];
    [navBar pushNavigationItem:topItem animated:NO];
    //backBtn
    topItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //completeBtn
    topItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeAction)];
    [topItem.rightBarButtonItem setTintColor:[UIColor redColor]];
    [self.view addSubview:navBar];
    //table view
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColor.blackColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.frame = CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height - navBar.bounds.size.height);
    [self.view insertSubview:tableView belowSubview:navBar];
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeAction
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    for (MNConfigModel *model in self.configArr) {
        [userDefaults setObject:model.value forKey:model.key];
    }
    [self backAction];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.configArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get config
    MNConfigModel *model = self.configArr[indexPath.row];
    
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
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textfieldChanged:) name:UITextFieldTextDidChangeNotification object:tf];
            tf.backgroundColor = UIColor.grayColor;
            tf.textColor = UIColor.whiteColor;
            tf.textAlignment = NSTextAlignmentCenter;
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

- (void)switchAction:(UISwitch *)switchBtn
{
    UITableViewCell *cell = (UITableViewCell *)switchBtn.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MNConfigModel *model = self.configArr[indexPath.row];
    model.value = @(switchBtn.isOn);
}

- (void)textfieldChanged:(NSNotification *)noti
{
    UITextField *tf = noti.object;
    UITableViewCell *cell = (UITableViewCell *)tf.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MNConfigModel *model = self.configArr[indexPath.row];
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
@end
