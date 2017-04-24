//
//  NavMenuView.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "NavMenuView.h"
#import <NerdyUI/NerdyUI.h>
#import "StringJudgeManager.h"

#define kRowHeight 44
#define kMenuWith 175

@implementation NavMenuItem

- (instancetype)initWithText:(NSString *)text imageSource:(NSString *)imageSource {
    self = [super init];
    
    if (self) {
        self.text = text;
        self.imageNameOrUlrStr = imageSource;
    }
    return self;
}

@end

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

@protocol NavMenuViewDelegate <NSObject>

- (void)navMenuView:(NavMenuView *)menuView didSelectItem:(NavMenuItem *)item atIndex:(NSInteger)index;

@end

@interface NavMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<NavMenuItem *> *itmes;
@property (nonatomic, copy) void (^rowSelectedHandle) (NSInteger index, NavMenuItem *selectedItem);
@property (nonatomic, weak) id<NavMenuViewDelegate> delegate;

@end

@implementation NavMenuView

- (instancetype)initWithMenuItems:(NSArray<NavMenuItem *> *)items {
    self = [super init];
    if (self) {
        [self initializationWithMenuItems:items];
    }
    return self;
}

- (void)initializationWithMenuItems:(NSArray<NavMenuItem *> *)items {
    if ([items isValidArray]) {
        self.itmes = items;
        
        self.frame = CGRectMake(0, 0, kMenuWith, kRowHeight * items.count);
        UITableView *tableView = InsertTableView(self, self.bounds, self, self, UITableViewStylePlain);
        tableView.bounces = NO;
    }
}

#pragma mark - UITableViewDataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itmes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.textLabel.fnt(13);
        cell.textLabel.color(@"black");
    }
    
    NavMenuItem *item = _itmes[indexPath.row];
    
    cell.textLabel.str(item.text);
    
    if ([item.imageNameOrUlrStr isValidString]) {
        if ([StringJudgeManager isValidateStr:item.imageNameOrUlrStr regexStr:UrlRegex]) {
            @weakify(cell)
            [cell.imageView setImageWithURL:[NSURL URLWithString:item.imageNameOrUlrStr]
                                placeholder:nil
                                    options:YYWebImageOptionAvoidSetImage
                                 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                 if (image) {
                     weak_cell.imageView.image = [image imageByResizeToSize:CGSizeMake(20, 20)];
                 }
            }];
        } else {
            cell.imageView.image = [[UIImage imageNamed:item.imageNameOrUlrStr] imageByResizeToSize:CGSizeMake(20, 20)];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_rowSelectedHandle) {
        _rowSelectedHandle(indexPath.row, _itmes[indexPath.row]);
    }
     
    if ([_delegate respondsToSelector:@selector(navMenuView:didSelectItem:atIndex:)]) {
        [_delegate navMenuView:self
                 didSelectItem:_itmes[indexPath.row]
                       atIndex:indexPath.row];
    }
}

@end

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

@implementation NavMenuViewManager

+ (void)presentNavMenuWithMenuItems:(NSArray<NavMenuItem *> *)items targetView:(UIView *)targetView inView:(UIView *)containerView selectedHandle:(void (^)(NSInteger, NavMenuItem *))selectedHandle {
    if ([items isValidArray]) {
        NavMenuView *menu = [[NavMenuView alloc] initWithMenuItems:items];
        
        CMPopTipView *popView = [[CMPopTipView alloc] initWithCustomView:menu];
        popView.hasShadow = YES;
        popView.pointerSize = 0;
        popView.cornerRadius = 0;
        popView.topMargin = 5;
        popView.borderWidth = 0;
        popView.dismissTapAnywhere = YES;
        popView.animation = CMPopTipAnimationSlide;
        if (selectedHandle) {
            menu.rowSelectedHandle = ^(NSInteger index, NavMenuItem *selectedItem) {
                [popView dismissAnimated:YES];
                
                selectedHandle(index, selectedItem);
            };
        }
        
        [popView presentPointingAtView:targetView
                                inView:containerView
                              animated:YES];
    }
}

@end
