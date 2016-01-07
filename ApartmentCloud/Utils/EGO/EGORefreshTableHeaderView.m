//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "SvGifView.h"


//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR	 RGBCOLOR(140, 140, 140)

#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize isFrom;


- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //        self.backgroundColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
        [label release];
        
        //		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 40.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
        _statusLabel=label;
        [label release];
		
		CALayer *layer = [CALayer layer];
        //		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.frame = CGRectMake(MainScreenWidth / 2 - 7, frame.size.height - 50, 13, 32);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"refresh_arrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"refresh_loading@2x" withExtension:@"gif"];
        SvGifView *_gifView = [[SvGifView alloc] initWithCenter:CGPointMake(MainScreenWidth / 2, CGRectGetHeight(frame) - 30) fileURL:fileUrl];
        _gifView.backgroundColor = [UIColor clearColor];
        [_gifView startGif];
        [self addSubview:_gifView];
		_activityView = _gifView;
		[_gifView release];
		
		
        UIImageView *_refreshFinishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _refreshFinishImage.layer.opacity = 0;
        _refreshFinishImage.center = CGPointMake(MainScreenWidth / 2, CGRectGetHeight(frame) - 30);
        _refreshFinishImage.image = ImageNamed(@"refresh_finish.png");
        refreshFinishImage = _refreshFinishImage;
        [self addSubview:refreshFinishImage];
        [_refreshFinishImage release];
        
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		[_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		//[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		//[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        NSLog(@"%@",date);
        //		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最近更新: %@", [dateFormatter stringFromDate:date]];
        _lastUpdatedLabel.text = @"";
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
//			_statusLabel.text = NSLocalizedString(@"释放立即刷新", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
//			_statusLabel.text = NSLocalizedString(@"下拉检查更新", @"Pull down to refresh status");
			[_activityView stopGif];
            
			[self resetArrowImageDirection];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
        {
            
//			_statusLabel.text = NSLocalizedString(@"正在努力检查...", @"Loading Status");
			[_activityView startGif];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
        }
			break;
        case EGOOPullRefreshFinish:
        {
            [_activityView stopGif];
            
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 refreshFinishImage.layer.opacity = 1;
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [self performSelector:@selector(resetArrowImageDirection) withObject:nil afterDelay:0.8f];
                                 }
                             }];
			
			[self refreshLastUpdatedDate];
        }
            break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)resetArrowImageDirection
{
    refreshFinishImage.layer.opacity = 0;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _arrowImage.hidden = NO;
    _arrowImage.transform = CATransform3DIdentity;
    [CATransaction commit];
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[self setState:EGOOPullRefreshFinish];
    [self performSelector:@selector(resetScrollViewPosition:) withObject:scrollView afterDelay:1];
}

- (void)resetScrollViewPosition:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
}

- (void)egoRefreshScrollViewDataSourceStartManualLoading:(UIScrollView *)scrollView {
    [self setState:EGOOPullRefreshLoading];
    
    //animating pull down scroll view
    [UIView animateWithDuration:0.2
                     animations:^{
                         scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                         scrollView.contentOffset = CGPointMake(0, -60.0f);
                     }
     ];
    
    //triggering refreshview regular refresh
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
        [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
    }
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
