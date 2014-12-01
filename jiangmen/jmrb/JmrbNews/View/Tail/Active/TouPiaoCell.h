//
//  TouPiaoCell.h
//  JmrbNews
//
//  Created by dean on 12-12-4.
//
//

#import <UIKit/UIKit.h>

@interface TouPiaoCell : UITableViewCell



@property (nonatomic, assign) IBOutlet UIImageView *newsImageView;
@property (nonatomic, assign) IBOutlet UILabel *newsTitle;
@property (nonatomic, assign) IBOutlet UIImageView *selectimage1;
@property (nonatomic, assign) IBOutlet UILabel *selecttext1;
@property (nonatomic, assign) IBOutlet UIImageView *selectimage2;
@property (nonatomic, assign) IBOutlet UILabel *selecttext2;
@property (nonatomic, assign) IBOutlet UILabel *toupiaonum;
@property (nonatomic, assign) IBOutlet UILabel *newsDetailTitle;
@property (nonatomic, assign) IBOutlet UIImageView *newstypeImageView;

@end
