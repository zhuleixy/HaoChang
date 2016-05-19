//
//  MusicHallViewController.m
//  HaoChang
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 zhulei. All rights reserved.
//

#import "MusicHallViewController.h"
#import "SongCollectionViewCell.h"
#import "CollectionHeaderViewController.h"

@interface MusicHallViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *songCollectionView;
@property (nonatomic, strong) CollectionHeaderViewController *headerViewController;

@end

@implementation MusicHallViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    //collectionView
    [self.collectionView registerClass:[SongCollectionViewCell class]
            forCellWithReuseIdentifier:@"SongCell"];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    //headView
    _headerViewController = [[CollectionHeaderViewController alloc] initWithNibName:@"CollectionHeaderViewController" bundle:nil];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = (CGRectGetWidth(self.view.bounds) * 300 / 640) + 40 + 50;//banner截图比例300/640
    CGRect frame = self.headerViewController.view.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.headerViewController.view.frame = frame;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(width, height);
    [self.collectionView setCollectionViewLayout:flowLayout];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 13;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SongCell";
    SongCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"albumArt3"];
    cell.songNameLabel.text = @"凤凰传奇";
    cell.singerNameLabel.text = @"苦逼程序员";
    cell.scoreLabel.text = @"800分";
    return cell;
}

//头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    [reusableView addSubview:self.headerViewController.view];
    return reusableView;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGFloat width = CGRectGetWidth(collectionView.bounds);
        return CGSizeMake(width, width * 400 / 720); //截图得到的比例
    } else {
        CGFloat width = (CGRectGetWidth(collectionView.bounds) - 3) / 2;
        return CGSizeMake(width, width * 4 / 5);
    }
}

//设置每组的cell的边界
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

#pragma mark - UICollectionViewDelegate



@end
