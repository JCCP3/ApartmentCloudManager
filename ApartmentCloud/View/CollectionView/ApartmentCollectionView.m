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
        [self parseJsonData:jsonDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseJsonData:(NSDictionary *)jsonDic
{
    NSMutableArray *finalApartmentArray = [[NSMutableArray alloc] init];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tmpArray = [jsonDic objectForKey:@"datas"];
    if (tmpArray && [tmpArray count] > 0) {
        for (NSDictionary *dic in tmpArray) {
            
            Apartment *apartment = [[Apartment alloc] initWithDictionary:dic];
            [finalApartmentArray addObject:apartment];
            
            NSMutableArray *aryApartmentRomeData = [[NSMutableArray alloc] init];
            if ([dic objectForKey:@"apartmentHomes"]) {
                NSMutableArray *currentTmpArray = [dic objectForKey:@"apartmentHomes"];
                
                if (currentTmpArray && [currentTmpArray count] > 0) {
                    for (NSDictionary *tmpDic in currentTmpArray) {
                        ApartmentRoom *room = [[ApartmentRoom alloc] initWithDictionary:tmpDic];
                        [aryApartmentRomeData addObject:room];
                    }
                }
            }
            
            NSMutableDictionary *currentTmpDic = [[NSMutableDictionary alloc] init];
            [currentTmpDic setObject:aryApartmentRomeData forKey:apartment.apartmentName];
            
            [finalArray addObject:currentTmpDic];
            
        }
        
        if ([finalArray count] > 0) {
            aryApartmentRoomItem = finalArray;
        }
        
        if ([finalApartmentArray count] > 0) {
            aryApartmentItem = finalApartmentArray;
        }
        
        [self reloadData];
        
        if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_requestFinishWithTag:)]) {
            [self.apartmentCollectionViewDelegate ACVD_requestFinishWithTag:MyApartmentCollectionViewTag];
        }
    }

}

#pragma mark - UICollectionViewDelegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [aryApartmentItem count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableDictionary *currentDic = [aryApartmentRoomItem objectAtIndex:section];
    NSMutableArray *tmpArray = [currentDic allValues][0];
    return [tmpArray count] + 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == [aryApartmentItem count] - 1) {
        return UIEdgeInsetsMake(12, 10, 20, 10);
    } else {
        return UIEdgeInsetsMake(12, 10, 0, 10);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApartmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSMutableDictionary *tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.section];
    
    NSMutableArray *tmpArray = [tmpDic allValues][0];
    if (tmpArray && [tmpArray count] > 0) {
        if (indexPath.row < [tmpArray count]) {
            ApartmentRoom *room = [tmpArray objectAtIndex:indexPath.row];
            [cell loadApartmentRoomCellData:room];
        } else {
            [cell loadApartmentRoomCellData:nil];
        }
    } else {
        [cell loadApartmentRoomCellData:nil];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize;
    if (section == 0) {
        headerSize = CGSizeMake(MainScreenWidth, 56);
    } else {
        headerSize = CGSizeMake(MainScreenWidth, 28);
    }
    
    return headerSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [reusableview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat marginTop = 0.f;
        
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
            
            marginTop += 28;
            
        }
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, marginTop + 12.f, MainScreenWidth - 20, 16)];
        [reusableview addSubview:sectionLabel];
        NSMutableDictionary *tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.section];
        NSString *apartmentName = [tmpDic allKeys][0];
        sectionLabel.font = [UIFont systemFontOfSize:16.f];
        sectionLabel.text = apartmentName;
        sectionLabel.textColor = [CustomColorUtils colorWithHexString:@"#333333"];
        
        return reusableview;
    }
    
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.section];
    NSArray *roomArray = [tmpDic allValues][0];
    if (indexPath.row < [roomArray count]) {
        if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_goToRoom:)]) {
            [self.apartmentCollectionViewDelegate ACVD_goToRoom:[roomArray objectAtIndex:indexPath.row]];
        }
    } else {
        if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_addRoom:)]) {
            [self.apartmentCollectionViewDelegate ACVD_addRoom:nil];
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
