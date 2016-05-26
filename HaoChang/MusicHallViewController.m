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
#import "Song.h"
#import "MacroDefinition.h"

@interface MusicHallViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *songCollectionView;
@property (nonatomic, strong) CollectionHeaderViewController *headerViewController;
@property (nonatomic, strong) NSMutableArray *songArray;

@end

@implementation MusicHallViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //造假数据
    _songArray = [NSMutableArray arrayWithCapacity:13];
    NSArray *names = @[@"Rollin王蓉", @"老徐👑", @"淡了流年", @"高音废物", @"象妈blair", @"🔥燃烧"];
    NSArray *songNames = @[@"独角戏", @"好乐day", @"又见炊烟", @"梦田", @"走钢索人", @"燃烧"];
    for (int i = 0; i < 13; i++)
    {
        Song *song = [[Song alloc] init];
        song.songName = songNames[i % 6];
        song.singerName = names[i % 6];
        song.score = 800 + (i * 15);
        NSString *imageName = [NSString stringWithFormat:@"albumArt%d", i % 5];
        song.image = [UIImage imageNamed:imageName];
        [self.songArray addObject:song];
    }
    
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
    CGFloat height = (CGRectGetWidth(self.view.bounds) * 300 / 640) + 46 + 50;//banner截图比例300/640
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
    return self.songArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SongCell";
    SongCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Song *song = self.songArray[indexPath.row];
    cell.imageView.image = song.image;
    cell.songNameLabel.text = song.songName;
    cell.singerNameLabel.text = [NSString stringWithFormat:@"%d.%@", (indexPath.row + 1), song.singerName];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d分", song.score];
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
        return CGSizeMake(width, width * 200 / 375); //截图得到的比例
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNamePlaySong object:nil];
}

@end
