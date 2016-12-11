

//
//  LxGridViewFlowLayout.h
//  LxGridView
//


#import <UIKit/UIKit.h>

@interface LGSelectImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end

