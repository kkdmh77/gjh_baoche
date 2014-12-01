//
//  SpecialCell.h
//  JmrbNews
//
//  Created by dean on 12-11-16.
//
//

#import <UIKit/UIKit.h>

@interface SpecialCell : UITableViewCell


@property (nonatomic, assign) IBOutlet UILabel *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *newsInfo;
@property (nonatomic, assign) IBOutlet UILabel *newsReplayView;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView1;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView2;
@property (nonatomic, assign) IBOutlet UIImageView *newsImageView3;

@end
