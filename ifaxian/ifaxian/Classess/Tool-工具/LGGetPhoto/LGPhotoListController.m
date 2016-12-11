//
//  LGPhotoListController.m
//  自定义相册
//
//  Created by Apple_Lzzy27 on 16/11/16.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "LGPhotoListController.h"
#import "NSObject+LGGetphoto.h"
#import "LGPhoto.h"
#import "LGPhotoListCell.h"
#import "LGPhotoCollectionController.h"
@interface LGPhotoListController()
@property (nonatomic,strong) NSArray<LGPhoto *> *photoLists;
@end
@implementation LGPhotoListController
static NSString *ID = @"cellID";


+ (instancetype)photoList:(void (^)(NSArray<UIImage *> *))selectedImages{
    
    LGPhotoListController *listVc = [[LGPhotoListController alloc] init];
    
    listVc.photoBlock = selectedImages;
    
    
    return listVc;
    
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight = 120;
    [self loadImages];
    [self setNav];
}

- (void)setNav{
    
    self.navigationItem.title = @"相册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:0 target:self action:@selector(close)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGPhotoListCell class]) bundle:nil] forCellReuseIdentifier:ID];
   

}

- (void)loadImages{
    __weak typeof(self) weakSelf = self;
//    [NSObject lg_getThumbnailImage:^(NSArray<LGPhoto *> *photos) {
//        weakSelf.photoLists = photos;
//    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSObject lg_getOriginalImage:^(NSArray<LGPhoto *> *photos) {
            
            weakSelf.photoLists = photos;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            
            });
        }];
        
    });

    
}


- (void)close{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.photoLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.photo = self.photoLists[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGPhotoCollectionController *clVc = [[LGPhotoCollectionController alloc] init];
    clVc.photo = self.photoLists[indexPath.row];
    clVc.photoBlock = self.photoBlock;
    
    [self.navigationController pushViewController:clVc animated:YES];
    
}


@end
