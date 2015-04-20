//
//  YSKCustomVertical.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKCustomVertical.h"
#import "TumblrPhoto.h"
#import "TMAPIClient.h"
#import "YSKCustomCardCell.h"

const int TOP_CONTENT_INSET = 10;
const int BOTTOM_CONTENT_INSET = 40;

@interface YSKCustomVertical () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) TumblrPhotos *tumblrPhotos;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YSKCustomCardCell *sizingCardCell;
@property (nonatomic, strong) YSLVerticalSelectorItem *verticalSelectorItem;

@end

@implementation YSKCustomVertical

#pragma mark - Lifecycle functions

- (void)loadView {
    [super loadView];
    [self addSubviews];
    [self addConstraints];
    [self setupTumblrClient];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startLoading];
}

#pragma mark - YSLSearchProtocol

- (UIScrollView*)mainScrollView {
    return self.tableView;
}

- (void)startLoading {
    // Scroll to Top first
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"type"] = @"photo";
    params[@"filter"] = @"text";
    NSString *query = self.queryRequest.query;
    if (query != nil) {
        [TMAPIClient.sharedInstance tagged:query parameters:params callback:^(NSArray *result, NSError *error) {
            if (error == nil) {
                self.tumblrPhotos = [[TumblrPhotos alloc] initWithResponseDictionaries:result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    }
}

- (void)stopLoading {
    self.tumblrPhotos = [TumblrPhotos new];
    [self.tableView reloadData];
}

#pragma mark - Setup

- (void)setupTumblrClient {
    TMAPIClient.sharedInstance.OAuthConsumerKey = @"uHJxDgqpeoFeg2TJiUU9PYYKV6Q5FnhcaKvrsIEM4PJtkQnnwY";
    TMAPIClient.sharedInstance.defaultCallbackQueue = [NSOperationQueue new];
}

#pragma mark - View Hierarchy setup

- (void)addSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_CONTENT_INSET, 0, BOTTOM_CONTENT_INSET, 0);
    [self.tableView registerClass:[YSKCustomCardCell class] forCellReuseIdentifier:@"cell"];
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.top += self.consumptionModeDelegate.headerHeight;
    self.tableView.contentInset = inset;
    [self.view addSubview:self.tableView];
    
}

- (void)addConstraints {
    NSDictionary *viewsDictionary = @{@"tableView": self.tableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - Lazy loaders

- (YSKCustomCardCell*)sizingCardCell {
    if (!_sizingCardCell) {
        _sizingCardCell = [[YSKCustomCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sizing"];
    }
    return _sizingCardCell;
}

- (YSLVerticalSelectorItem*)verticalSelectorItem {
    if (!_verticalSelectorItem) {
        _verticalSelectorItem = [YSLVerticalSelectorItem new];
        _verticalSelectorItem.title = @"tumblr";
    }
    return _verticalSelectorItem;
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tumblrPhotos.photos.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TumblrPhoto *photo = self.tumblrPhotos.photos[indexPath.row];
    self.sizingCardCell.title.text = photo.blogName;
    self.sizingCardCell.caption.text = photo.caption;
    self.sizingCardCell.tags.text = photo.tagsString;
    [self.sizingCardCell setNeedsUpdateConstraints];
    [self.sizingCardCell updateConstraintsIfNeeded];
    [self.sizingCardCell setNeedsLayout];
    [self.sizingCardCell layoutIfNeeded];
    
    CGSize size = [self.sizingCardCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return round(size.height + cardTopBottomMargin);
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSKCustomCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = UIColor.whiteColor;
    TumblrPhoto *photo = self.tumblrPhotos.photos[indexPath.row];
    cell.title.text = photo.blogName;
    cell.caption.text = photo.caption;
    cell.tags.text = photo.tagsString;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.imageUrl]];
        if (data != nil) {
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView transitionWithView:cell.blogImage
                                  duration:1.0f
                                   options:UIViewAnimationOptionTransitionCrossDissolve\
                                animations:^{
                                    cell.blogImage.image = image;
                                }
                                completion:nil];
            });
        }
    });
    return cell;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    CGPoint contentOffset = [self effectiveContentOffsetForScrollView:scrollView andTargetOffset:nil];
    CGPoint bottomOffset = [self effectiveContentBottomOffsetForScrollView:scrollView andTargetOffset:nil];
    
    [self.consumptionModeDelegate viewController:self didStartScrollingWithContentOffset:contentOffset bottomOffset:bottomOffset];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    CGPoint contentOffset = [self effectiveContentOffsetForScrollView:scrollView andTargetOffset:nil];
    CGPoint bottomOffset = [self effectiveContentBottomOffsetForScrollView:scrollView andTargetOffset:nil];
    
    [self.consumptionModeDelegate viewController:self didStartScrollingWithContentOffset:contentOffset bottomOffset:bottomOffset];
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint contentOffset = [self effectiveContentOffsetForScrollView:scrollView andTargetOffset:targetContentOffset];
    CGPoint bottomOffset = [self effectiveContentBottomOffsetForScrollView:scrollView andTargetOffset:targetContentOffset];
    
    [self.consumptionModeDelegate viewController:self didFinishScrollingWithContentOffet:contentOffset bottomOffset:bottomOffset velocity:velocity];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // switch out of consumption mode
    [self.consumptionModeDelegate viewController:self didStartScrollingWithContentOffset:CGPointZero bottomOffset:CGPointZero];
    [self.consumptionModeDelegate viewController:self didFinishScrollingWithContentOffet:CGPointZero bottomOffset:CGPointZero velocity:CGPointZero];
    return YES;
}

#pragma mark - UIScrollViewDelegate method helpers

- (CGPoint)effectiveContentOffsetForScrollView:(UIScrollView*)scrollView andTargetOffset:(CGPoint*)targetOffset {
    CGPoint contentOffset = CGPointZero;
    if (targetOffset != nil) {
        contentOffset = CGPointMake(targetOffset->x, targetOffset->y);
    } else {
        contentOffset = scrollView.contentOffset;
    }
    
    contentOffset = CGPointMake(contentOffset.x, contentOffset.y + scrollView.contentInset.top);
    return contentOffset;
}

- (CGPoint)effectiveContentBottomOffsetForScrollView:(UIScrollView*)scrollView andTargetOffset:(CGPoint*)targetOffset {
    CGPoint bottomOffset = CGPointZero;
    CGSize effectiveContentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom);
    CGPoint contentOffset = CGPointZero;
    if (targetOffset != nil) {
        contentOffset = CGPointMake(targetOffset->x, targetOffset->y);
    } else {
        contentOffset = scrollView.contentOffset;
    }
    CGPoint effectiveContentOffset = CGPointMake(contentOffset.x, contentOffset.y + scrollView.contentInset.top);
    bottomOffset = CGPointMake(effectiveContentOffset.x, effectiveContentSize.height - (effectiveContentOffset.y+self.view.frame.size.height));
    return bottomOffset;
}

@end
