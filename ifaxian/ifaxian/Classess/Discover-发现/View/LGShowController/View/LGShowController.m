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

- (UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
         LGFlowLayout *layout = [[LGFlowLayout alloc]init];
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.lg_height * 0.4) collectionViewLayout:layout];
    }
    
    return _collectionView;
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
   
 
   
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //注册cell
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LGCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    //添加到视图
    
    [self.view addSubview:self.collectionView];
    

//    NSString *fileName = @"show.plist";
//    NSString *path = [fileName lg_appendDocumentDir];
    //[NSKeyedArchiver archiveRootObject:arrM toFile:path];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"show.plist" ofType:nil];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self.categories addObjectsFromArray:array];
    
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.lg_width, 0)];
    [self.collectionView reloadData];

//    LGWeakSelf;
//    [self.list getAllCategoriesPosts:^(NSArray *categoryposts) {
//       
//        [weakSelf.categories addObjectsFromArray:categoryposts];
//        [self.collectionView reloadData];
//        [self.collectionView setContentOffset:CGPointMake(self.collectionView.lg_width, 0)];
//    }];
//    

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
