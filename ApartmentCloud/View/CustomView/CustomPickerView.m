//
//  CustomPickerView.m
//  ApartmentCloud
//
//  Created by JC_CP3 on 16/1/14.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *pickerView;
    NSArray *aryPickerData;
}

@end

@implementation CustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 216, MainScreenWidth, 216)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
    }
    return self;
}

- (void)setPickerViewWithComponentsNum:(NSInteger)components pickerViewData:(NSMutableArray *)aryPickerViewData
{
    aryPickerData = aryPickerViewData;
    [pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate & dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [aryPickerData count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *tmpArray = [aryPickerData objectAtIndex:component];
    return [tmpArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *tmpArray = [aryPickerData objectAtIndex:component];
    return [tmpArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
