//
//  AddApartmentDescViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentRoomViewController.h"
#import "NormalInputTextFieldCell.h"
#import "ApartmentRoom.h"

typedef enum{
    
    RENT_ING = 1,
    IDLE_ING = 2,
    NO_CLEAN = 3
    
}ApartmentStatus;


@interface AddApartmentRoomViewController () <UITableViewDelegate, UITableViewDataSource, NormalInputTextFieldCellDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
{
    UITableView *addRoomTableView;
    
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;

    NSArray *aryStatusItem;
    NSArray *aryRentItem;
}

@end

@implementation AddApartmentRoomViewController
@synthesize apartmentRoom;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"房间名称", @"租住状态", @"月租金" , @"押金", @"租赁时间", @"交租方式", @"居住人数", @"出租类型"];
    aryPlaceHolderData = @[@"请输入房间名称", @"请选择租住状态", @"请输入月租金", @"请输入押金", @"请选择租赁时间", @"请选择交租方式", @"请选择居住人数", @"请选择出租类型"];
    
    aryStatusItem = @[@"RENT_ING", @"IDLE_ING", @"NO_CLEAN"];
    aryRentItem = @[@"ALL", @"ROOMMATE"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"房间详情" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"确认添加"];
    
    if (!apartmentRoom) {
        apartmentRoom = [[ApartmentRoom alloc] init];
    }
    
    [self createTableView];
    
    [self addTableViewGesture];
}

- (void)createTableView
{
    addRoomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    addRoomTableView.delegate = self;
    addRoomTableView.dataSource = self;
    addRoomTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addRoomTableView];
}

- (void)addTableViewGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    tap.delegate = self;
    [addRoomTableView addGestureRecognizer:tap];
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 2) {
        
        int maxNum = i == 0 ? 8 : 3;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addRoomTableView cellForRowAtIndexPath:indexPath];
            for (UIView *subView in cell.subviews) {
                UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
                for (UIView *tmpSubView in wrapperView.subviews) {
                    if ([tmpSubView isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField *)tmpSubView;
                        [textField resignFirstResponder];
                    }
                }
            }
        }
        
        i ++;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryTitleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        cell.isTextFiledEnable = YES;
    } else {
        cell.isTextFiledEnable = NO;
    }
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    
    cell.cellType = AddRoomLogic;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.room = apartmentRoom;
    [cell loadAddRoomCellWithIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 28)];
    [sectionHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *sepaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 3, 16)];
    sepaLabel.backgroundColor = AppThemeColor;
    [sectionHeaderView addSubview:sepaLabel];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 200, 16)];
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.textColor = AppThemeColor;
    sectionTitle.font = [UIFont systemFontOfSize:16];
    NSString *title = @"";
    if (section == 0) {
        title = @"基本信息";
    } else if (section == 1) {
        title = @"住户信息";
    } else {
        title = @"特殊备注";
    }
    sectionTitle.text = [GlobalUtils translateStr:title];
    [sectionHeaderView addSubview:sectionTitle];
    
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"出租中",@"闲置中",@"未打扫", nil];
            actionSheet.tag = 111;
            [actionSheet showInView:self.view];
        } else if (indexPath.row == 6) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"1人", @"2人", @"3人", @"3人以上",nil];
            actionSheet.tag = 112;
            [actionSheet showInView:self.view];
        } else if (indexPath.row == 7) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"出租中",@"闲置中",@"未打扫", nil];
            actionSheet.tag = 113;
            [actionSheet showInView:self.view];
        }
    }
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    Apartment *currentApartment = apartmentRoom.roomAtApartment;
    [paramDic setObject:currentApartment.apartmentId forKey:@"apartmentId"];
    [paramDic setObject:apartmentRoom.homeName forKey:@"homeName"];
    [paramDic setObject:apartmentRoom.status forKey:@"status"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)apartmentRoom.monthlyRent] forKey:@"monthlyRent"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)apartmentRoom.deposit] forKey:@"deposit"];
    [paramDic setObject:apartmentRoom.expDate forKey:@"expDate"];
    [paramDic setObject:apartmentRoom.deliverCategory forKey:@"deliverCategory"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", apartmentRoom.tanantNumber] forKey:@"tanantNumber"];
    [paramDic setObject:apartmentRoom.rentCategory forKey:@"rentCategory"];
    [paramDic setObject:apartmentRoom.mark forKey:@"mark"];
    [paramDic setObject:apartmentRoom.userIds forKey:@"userIds"];
    
    [CustomRequestUtils createNewRequest:@"/apartment/home/add.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

}

#pragma mark - NormalInputTextFieldCellDelegate
- (void)NITFC_addRoomWithRoom:(ApartmentRoom *)room
{
    apartmentRoom = room;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 111) {
        if (buttonIndex < [aryStatusItem count]) {
            apartmentRoom.status = [aryStatusItem objectAtIndex:buttonIndex];
            [addRoomTableView reloadData];
        }
     } else if (actionSheet.tag == 112) {
         if (buttonIndex < [actionSheet numberOfButtons]) {
             apartmentRoom.tanantNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
             [addRoomTableView reloadData];
         }
    } else if (actionSheet.tag == 113) {
        if (buttonIndex < [aryRentItem count]) {
            apartmentRoom.rentCategory = [aryRentItem objectAtIndex:buttonIndex];
            [addRoomTableView reloadData];
        }
    }
}

#pragma mark - UIGestureRecognize delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
