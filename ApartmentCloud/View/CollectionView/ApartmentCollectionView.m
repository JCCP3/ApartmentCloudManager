//
//  ApartmentCollectionView.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentCollectionView.h"
#import "ApartmentCell.h"
#import "ApartmentCountCell.h"

@interface ApartmentCollectionView ()
{
    NSMutableArray *aryApartmentItem;
    NSMutableArray *aryApartmentRoomItem;
    
    NSMutableArray *aryTmpApartmentItem;
    NSMutableArray *aryTmpApartmentRoomItem;
    
    NSMutableArray *aryDueApartmentItem;
    NSMutableArray *aryDueApartmentRoomItem;
    
    NSMutableArray *aryApartmentCount;
    
    BOOL showGL;
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
        [self registerClass:[ApartmentCountCell class] forCellWithReuseIdentifier:@"ApartmentCountCell"];
    
        aryApartmentItem = [[NSMutableArray alloc] init];
        aryApartmentRoomItem = [[NSMutableArray alloc] init];
        
        aryDueApartmentItem = [[NSMutableArray alloc] init];
        aryDueApartmentRoomItem = [[NSMutableArray alloc] init];
        
        aryApartmentCount = [[NSMutableArray alloc] init];
    }
    return self;
}

//我的公寓
- (void)loadApartmentCollectionViewData
{
    [CustomRequestUtils createNewRequest:@"/apartment/list.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        [self parseJsonData:jsonDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//交租查询
- (void)loadDueApartmentCollectionViewData
{
    [CustomRequestUtils createNewRequest:@"/apartment/soonRentList.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if ([[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            [self parseDueJsonData:jsonDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseDueJsonData:(NSDictionary *)jsonDic
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
            aryDueApartmentRoomItem = finalArray;
        }
        
        if ([finalApartmentArray count] > 0) {
            aryDueApartmentItem = finalApartmentArray;
        }
        
        [self reloadData];
    }

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
        
        if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_showTitleViewArray:)]) {
            [self.apartmentCollectionViewDelegate ACVD_showTitleViewArray:aryApartmentItem];
        }
        
        [self reloadData];
    }

}

- (void)parseExpiredJsonData:(NSDictionary *)dic
{
    
}

- (void)showDataWithApartment:(Apartment *)apartment
{
    if (apartment) {
        showGL = YES;
        aryTmpApartmentItem = aryApartmentItem;
        aryTmpApartmentRoomItem = aryApartmentRoomItem;
        [self reloadData];
    } else {
        showGL = NO;
        [self reloadData];
        return;
    }
    aryTmpApartmentItem = [[NSMutableArray alloc] init];
    [aryTmpApartmentItem addObject:apartment];
    
    for (NSDictionary *dic in aryApartmentRoomItem) {
        if ([[dic allKeys][0] isEqualToString:apartment.apartmentName]) {
            NSMutableArray *tmpRoomArray = [dic allValues][0];
            aryTmpApartmentRoomItem = [[NSMutableArray alloc] init];
            [aryTmpApartmentRoomItem addObject:@{apartment.apartmentName:tmpRoomArray}];
            break;
        }
    }
}

//到期查询
- (void)loadExpireApartmentCollectionViewData
{
    [CustomRequestUtils createNewRequest:@"/apartment/soonContractList.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        [self parseExpiredJsonData:jsonDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//房间统计
- (void)loadApartmentRoomCountCollectionViewData
{
    [CustomRequestUtils createNewRequest:@"/apartment/statistics.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if ([[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            [self parseRoomcountData:jsonDic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseRoomcountData:(NSDictionary *)jsonDic
{
    if (jsonDic && [[jsonDic objectForKey:@"datas"] count] > 0) {
        
        NSMutableArray *currentTmpArray = [[NSMutableArray alloc] init];
        NSMutableArray *tmpArray = [jsonDic objectForKey:@"datas"];
        if (tmpArray && [tmpArray count] > 0) {
            for (NSDictionary *tmpDic in tmpArray) {
                Apartment *apartment = [[Apartment alloc] initWithDictionary:tmpDic];
                [currentTmpArray addObject:apartment];
            }
        }
        
        aryApartmentCount = currentTmpArray;
        [self reloadData];
    }
}

#pragma mark - UICollectionViewDelegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.tag == 100) {
        if (showGL) {
            return [aryTmpApartmentItem count];
        } else {
            return [aryApartmentItem count];
        }
    } else if (collectionView.tag == 101) {
        return [aryDueApartmentItem count];
    } else if (collectionView.tag == 102) {
        return 0;
    } else {
        return [aryApartmentCount count];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 100) {
        if (showGL) {
            NSMutableDictionary *currentDic = [aryTmpApartmentRoomItem objectAtIndex:section];
            NSMutableArray *tmpArray = [currentDic allValues][0];
            return [tmpArray count] + 1;
        } else {
            NSMutableDictionary *currentDic = [aryApartmentRoomItem objectAtIndex:section];
            NSMutableArray *tmpArray = [currentDic allValues][0];
            return [tmpArray count] + 1;
        }
    } else if (collectionView.tag == 101) {
        NSMutableDictionary *currentDic = [aryDueApartmentRoomItem objectAtIndex:section];
        NSMutableArray *tmpArray = [currentDic allValues][0];
        return [tmpArray count];
    } else if (collectionView.tag == 102){
        return 0;
    } else {
        return 2;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 103) {
        return CGSizeMake((MainScreenWidth - 30) / 2, 60);
    } else {
        return CGSizeMake(50, 60);
    }
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
    if (collectionView.tag == 100 || collectionView.tag == 101) {
        ApartmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        NSMutableDictionary *tmpDic;
        BOOL showPay;
        if (collectionView.tag == 100) {
            if (showGL) {
                tmpDic = [aryTmpApartmentRoomItem objectAtIndex:indexPath.section];
                showPay = NO;
            } else {
                tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.section];
                showPay = NO;
            }
            
        } else {
            tmpDic = [aryDueApartmentRoomItem objectAtIndex:indexPath.section];
            showPay = YES;
        }
        
        
        NSMutableArray *tmpArray = [tmpDic allValues][0];
        if (tmpArray && [tmpArray count] > 0) {
            if (indexPath.row < [tmpArray count]) {
                ApartmentRoom *room = [tmpArray objectAtIndex:indexPath.row];
                [cell loadApartmentRoomCellData:room showPay:showPay];
            } else {
                [cell loadApartmentRoomCellData:nil showPay:showPay];
            }
        } else {
            [cell loadApartmentRoomCellData:nil showPay:showPay];
        }
        
        return cell;
    } else if (collectionView.tag == 102){
        return nil;
    } else {
        ApartmentCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApartmentCountCell" forIndexPath:indexPath];
        
        Apartment *apartment = [aryApartmentCount objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            [cell loadApartmentCountCell:apartment style:@"first"];
        } else {
            [cell loadApartmentCountCell:apartment style:@"second"];
        }
        
        return cell;
    }
    
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
            if (collectionView.tag == 100) {
                sectionTitle.text = [GlobalUtils translateStr:@"公寓房间情况"];
            } else if (collectionView.tag == 101) {
                sectionTitle.text = [GlobalUtils translateStr:@"即将到期房间"];
            } else if (collectionView.tag == 102) {
                sectionTitle.text = [GlobalUtils translateStr:@"与房主合同到期房间"];
            } else {
                sectionTitle.text = [GlobalUtils translateStr:@"公寓房间统计"];
            }
            
            [reusableview addSubview:sectionTitle];
            
            marginTop += 28;
            
        }
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, marginTop + 12.f, MainScreenWidth - 20, 16)];
        [reusableview addSubview:sectionLabel];
        
        UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(sectionLabel.frame), MainScreenWidth, CGRectGetHeight(sectionLabel.bounds))];
        [reusableview addSubview:sectionBtn];

        Apartment *apartment;
        if (collectionView.tag == 100) {
            if (showGL) {
                apartment = [aryTmpApartmentItem objectAtIndex:indexPath.section];
            } else {
                apartment = [aryApartmentItem objectAtIndex:indexPath.section];
            }
        } else if (collectionView.tag == 101) {
            apartment = [aryDueApartmentItem objectAtIndex:indexPath.section];
        } else if (collectionView.tag == 102) {
            apartment = nil;
        } else {
            apartment = [aryApartmentCount objectAtIndex:indexPath.section];
        }
        
        [[sectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_showApartmentDetailInfo:)]) {
                [self.apartmentCollectionViewDelegate ACVD_showApartmentDetailInfo:apartment];
            }
        }];
        
        NSMutableDictionary *tmpDic;
        NSString *apartmentName;
        if (collectionView.tag == 100) {
            if (showGL) {
                tmpDic = [aryTmpApartmentRoomItem objectAtIndex:indexPath.section];
            } else {
                tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.section];
            }
            
            apartmentName = [tmpDic allKeys][0];
        } else if (collectionView.tag == 101){
            tmpDic = [aryDueApartmentRoomItem objectAtIndex:indexPath.section];
            apartmentName = [tmpDic allKeys][0];
        } else if (collectionView.tag == 102) {
            
        } else {
            Apartment *currentApartment = [aryApartmentCount objectAtIndex:indexPath.section];
            apartmentName = currentApartment.apartmentName;
        }
        
        sectionLabel.font = [UIFont systemFontOfSize:16.f];
        sectionLabel.text = apartmentName;
        sectionLabel.textColor = [CustomColorUtils colorWithHexString:@"#333333"];
        
        return reusableview;
    }
    
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 100) {
        NSMutableDictionary *tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.section];
        NSArray *roomArray = [tmpDic allValues][0];
        if (indexPath.row < [roomArray count]) {
            if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_goToRoom:)]) {
                [self.apartmentCollectionViewDelegate ACVD_goToRoom:[roomArray objectAtIndex:indexPath.row]];
            }
        } else {
            Apartment *apartment = [aryApartmentItem objectAtIndex:indexPath.section];
            if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_addRoom:)]) {
                [self.apartmentCollectionViewDelegate ACVD_addRoom:apartment];
            }
        }
    } else if (collectionView.tag == 101) {
        NSMutableDictionary *tmpDic = [aryDueApartmentRoomItem objectAtIndex:indexPath.section];
        NSArray *roomArray = [tmpDic allValues][0];
        if ([self.apartmentCollectionViewDelegate respondsToSelector:@selector(ACVD_goToRoom:)]) {
            [self.apartmentCollectionViewDelegate ACVD_goToRoom:[roomArray objectAtIndex:indexPath.row]];
        }
    } else if (collectionView.tag == 102) {
        
    } else {
        Apartment *apartment = [aryApartmentCount objectAtIndex:indexPath.row];
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
