//
//  ApartmentCollectionView.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentCollectionView.h"
#import "ApartmentCell.h"

@interface ApartmentCollectionView ()
{
    NSMutableArray *aryApartmentItem;
    NSMutableArray *aryApartmentRoomItem;
}

@end

@implementation ApartmentCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
        self.delegate = self;
        self.dataSource = self;
        
        //注册头部
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [self registerClass:[ApartmentCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        
        aryApartmentItem = [[NSMutableArray alloc] init];
        aryApartmentRoomItem = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadApartmentCollectionViewData
{
    [CustomRequestUtils createNewRequest:@"/apartment/list.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [aryApartmentRoomItem count] + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(12, 10, 0, 10);;
    }
    return UIEdgeInsetsMake(0, 15, 20, 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApartmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    if ([aryApartmentItem count] == 0) {
        [cell loadApartmentRoomCellData:nil];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = CGSizeMake(MainScreenWidth, 28);
    return headerSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            
            UILabel *sepaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 3, 16)];
            sepaLabel.backgroundColor = AppThemeColor;
            [reusableview addSubview:sepaLabel];
            
            UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 200, 16)];
            sectionTitle.backgroundColor = [UIColor clearColor];
            sectionTitle.textColor = AppThemeColor;
            sectionTitle.font = [UIFont systemFontOfSize:16];
            sectionTitle.text = [GlobalUtils translateStr:@"公寓房间情况"];
            [reusableview addSubview:sectionTitle];
        }
        return reusableview;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_addRoom:)]) {
                [self.apartmentCollectionViewDelegate ACVD_addRoom:nil];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
