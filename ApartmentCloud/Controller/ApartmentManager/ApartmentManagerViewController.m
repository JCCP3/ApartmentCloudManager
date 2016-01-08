//
//  ApartmentManagerViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/8.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentManagerViewController.h"

@interface ApartmentManagerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *apartmentCollectionView;
    NSMutableArray *aryData;
}

@end

@implementation ApartmentManagerViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"所有公寓" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    
    [self setUpCollectionView];
}

- (void)setUpCollectionView
{
    apartmentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64 - 40)];
    apartmentCollectionView.delegate = self;
    apartmentCollectionView.dataSource = self;
    [self.view addSubview:apartmentCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
