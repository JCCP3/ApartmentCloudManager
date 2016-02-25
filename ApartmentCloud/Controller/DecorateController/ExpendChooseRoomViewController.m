//
//  ExpendChooseRoomViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/23.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ExpendChooseRoomViewController.h"
#import "ApartmentCollectionView.h"

@interface ExpendChooseRoomViewController () <ApartmentCollectionViewDelegate>
{
    ApartmentCollectionView *apartmentCollectionView;
}

@end

@implementation ExpendChooseRoomViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"选择房间" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self setUpCollectionView];
    
}

- (void)setUpCollectionView
{
    if (!apartmentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        apartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) collectionViewLayout:flowLayout];
        apartmentCollectionView.tag = 110;
        apartmentCollectionView.apartmentCollectionViewDelegate = self;
        [apartmentCollectionView loadApartmentCollectionViewData];
        [self.view addSubview:apartmentCollectionView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)ACVD_passRoom:(ApartmentRoom *)room
{
    if ([self.delegate respondsToSelector:@selector(ECRVD_passRoomInfo:)]) {
        [self.delegate ECRVD_passRoomInfo:room];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
