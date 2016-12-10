//
//  ViewController.m
//  图片浏览相册
//
//  Created by ming on 26/7/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShowController.h"
#import "LGFlowLayout.h"
#import "LGCategoryCell.h"
#import "LGDiscoverList.h"
#import "LGPostModel.h"
#import "LGCategory.h"
#import "LGShow.h"
#import "LGRecommendController.h"

@interface LGShowController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong) LGDiscoverList *list;
@property(nonatomic, strong) NSMutableArray *categories;
@property(nonatomic, strong) NSMutableArray *categoryposts;
@end
static NSString *ID = @"cell";
@implementation LGShowController
- (LGDiscoverList *)list{
    
    if (_list == nil) {
        _list = [[LGDiscoverList alloc] init];
    }
    
    return _list;
    
}
- (NSMutableArray *)categoryposts{
    
    if (_categoryposts == nil) {
        _categoryposts = [NSMutableArray array];
    }
    
    return _categoryposts;
}


- (NSMutableArray *)categories{
    
    if (_categories == nil) {
        _categories = [NSMutableArray array];
    }
    
    return _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建布局
    LGFlowLayout *layout = [[LGFlowLayout alloc]init];
    
    UICollectionView *coollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.lg_height * 0.4) collectionViewLayout:layout];
    coollectionView.backgroundColor = [UIColor redColor];
    coollectionView.showsHorizontalScrollIndicator = NO;
    
    //设置代理
    coollectionView.delegate = self;
    coollectionView.dataSource = self;

    //注册cell
    
    [coollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LGCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    //添加到视图
    
    [self.view addSubview:coollectionView];
    
    LGWeakSelf;

    [self.list getAllCategoriesPosts:^(NSArray *categoryposts) {
       
        [weakSelf.categories addObjectsFromArray:categoryposts];
        [coollectionView reloadData];
    }];
    

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categories.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    LGShow *model = self.categories[indexPath.row];
    cell.model = model;

   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
 UINavigationController *nav = tab.selectedViewController;
    LGRecommendController *rVc = [[LGRecommendController alloc] init];
    [nav pushViewController:rVc animated:YES];

}




@end
