//
//  flowLayout.m
//  图片浏览相册
//
//  Created by ming on 26/7/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGFlowLayout.h"

@implementation LGFlowLayout



//这个方法会返回所有cell的属性设置
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //取出所有item 的UICollectionViewLayoutAttributes（cell的所有属性）
    NSArray *superAttributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];;
    
    //计算屏幕的中心点+偏移量 - cell的中心点，除以一个数得到一个放大比例，然后再取反
    //屏幕中心点
    
    CGFloat srceenCenter = self.collectionView.frame.size.width * 0.5 + self.collectionView.contentOffset.x;
    //NSLog(@"srceenCenter = %f",srceenCenter);
    
    //遍历cell数据
    for (UICollectionViewLayoutAttributes *attributes in superAttributes) {
        //计算差值 ABS() 取绝对值
        CGFloat scale = ABS(srceenCenter - attributes.center.x);
        //计算一个放大比例
        CGFloat sy =1 - scale/(self.collectionView.frame.size.width + attributes.frame.size.width);
        //NSLog(@"%f",sy);
        
        attributes.transform = CGAffineTransformMakeScale(sy, sy);
    }
    
    
    
    
    return superAttributes;
}

//当屏幕的可见范围发生改变的时候，要从新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
        return YES;
}


//#pragma mark -
#pragma mark - 当布局刷新的时候, 就会自动调用这个方法
// 建议在这个方法里进行初始化的设置
- (void)prepareLayout{
    
    [super prepareLayout];
     //设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   //取出collection的size
    CGFloat itemW = [UIScreen lg_screenWidth] * 0.55;
    CGFloat itemH = [UIScreen lg_screenWidth] * 0.7;
    self.itemSize = CGSizeMake(itemW,itemH);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 35, 0, self.collectionView.frame.size.width/4);
    
}

//targetContentOffset   最终停留1的位置
//ProposedContentOffset  本应该停留的位置

//velocity  力度, 速度
//当手指离开collectionView的时候回调用这个方法
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    velocity = CGPointMake(100, 100);
    
    //1.取出屏幕的中心点（偏移量加上collectionVie宽度的一半），最终停留位置就是collectionView的偏移量，以最终停留位置的x，就是collectionView的最终偏移量
    //在屏幕的最左方
    CGFloat screenCenter = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    //创建一个空的可见范围
       CGRect visibleRect = CGRectZero;
    // 2. 取出可见范围内的cell的size就是collectionView的size
    visibleRect.size = self.collectionView.frame.size;
    //可见范围的origin 就是最终停留位置的origin，屏幕最左边
    visibleRect.origin = proposedContentOffset;
    
     //取出可见范围的cell属性结合，调用super方法,避免从新计算比率

    NSArray *visibleArray = [super layoutAttributesForElementsInRect:visibleRect];
    //定义最小的 间距为最大,然后在可见范围cell'下面遍历取出最小值
    CGFloat miniMargin = MAXFLOAT;
 //取出可见范围cell
    for (UICollectionViewLayoutAttributes *attributes in visibleArray) {
        CGFloat deltaMargin = attributes.center.x - screenCenter;
        //因为有正负所以取绝对值，然后取出可见cll中最小的值
        if (ABS(miniMargin) > ABS(deltaMargin)) {
            //取出最小值
            miniMargin = deltaMargin;
        }
    }  
    //返回最终偏移位置
    
     CGPoint poin = CGPointMake(proposedContentOffset.x + miniMargin, proposedContentOffset.y);
  
    return poin;
}

@end
