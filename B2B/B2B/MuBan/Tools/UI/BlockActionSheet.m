//
//  BlockActionSheet.m
//  kkunion
//
//  Created by 龚 俊慧 on 2016/11/24.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "BlockActionSheet.h"

@interface BlockActionSheet ()<UIActionSheetDelegate>

@property (nonatomic, copy) void (^cancelBlock) (BlockActionSheet *actionSheet);
@property (nonatomic, copy) void (^otherBlock) (BlockActionSheet *actionSheet, NSInteger buttonIndex);

@end

@implementation BlockActionSheet

+ (void)showWithTitle:(nullable NSString *)title
          cancelTitle:(nullable NSString *)cancelTitle
          cancelBlock:(nullable void (^) (BlockActionSheet * _Nonnull actionSheet))cancelBlock
           otherBlock:(nullable void (^) (BlockActionSheet * _Nonnull actionSheet, NSInteger buttonIndex))otherBlock
     destructiveTitle:(nullable NSString *)destructiveTitle
    otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    
    NSMutableArray<NSString *> *argsArray = [[NSMutableArray alloc] init];
    if (otherButtonTitles) {
        
        va_list vlist;
        va_start(vlist, otherButtonTitles);
        
        [argsArray addObject:otherButtonTitles];
        NSString *arg = nil;
        
        while ((arg = va_arg(vlist, NSString *))) {
            [argsArray addObject:arg];
        }
        va_end(vlist);
    }
    
    BlockActionSheet *actionSheet = [[self alloc] initWithTitle:title
                                                    cancelTitle:cancelTitle
                                                    cancelBlock:cancelBlock
                                                     otherBlock:otherBlock
                                               destructiveTitle:destructiveTitle
                                              otherButtonTitles:argsArray];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (id)initWithTitle:(nullable NSString *)title
        cancelTitle:(nullable NSString *)cancelTitle
        cancelBlock:(nullable void (^) (BlockActionSheet * _Nonnull actionSheet))cancelBlock
         otherBlock:(nullable void (^) (BlockActionSheet * _Nonnull actionSheet, NSInteger buttonIndex))otherBlock
   destructiveTitle:(nullable NSString *)destructiveTitle
  otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles {
    
    if (0 == otherButtonTitles.count) {
        self = [super initWithTitle:title
                           delegate:self
                  cancelButtonTitle:cancelTitle
             destructiveButtonTitle:destructiveTitle
                  otherButtonTitles:nil];
    } else if (1 == otherButtonTitles.count) {
        
        self = [super initWithTitle:title
                           delegate:self
                  cancelButtonTitle:cancelTitle
             destructiveButtonTitle:destructiveTitle
                  otherButtonTitles:otherButtonTitles[0], nil];
    } else if (2 == otherButtonTitles.count) {
        
        self = [super initWithTitle:title
                           delegate:self
                  cancelButtonTitle:cancelTitle
             destructiveButtonTitle:destructiveTitle
                  otherButtonTitles:otherButtonTitles[0], otherButtonTitles[1], nil];
    } else if (3 == otherButtonTitles.count) {
        
        self = [super initWithTitle:title
                           delegate:self
                  cancelButtonTitle:cancelTitle
             destructiveButtonTitle:destructiveTitle
                  otherButtonTitles:otherButtonTitles[0], otherButtonTitles[1], otherButtonTitles[2], nil];
    } else if (4 == otherButtonTitles.count) {
        
        self = [super initWithTitle:title
                           delegate:self
                  cancelButtonTitle:cancelTitle
             destructiveButtonTitle:destructiveTitle
                  otherButtonTitles:otherButtonTitles[0], otherButtonTitles[1], otherButtonTitles[2], otherButtonTitles[3], nil];
    } else if (5 == otherButtonTitles.count) {
        
        self = [super initWithTitle:title
                           delegate:self
                  cancelButtonTitle:cancelTitle
             destructiveButtonTitle:destructiveTitle
                  otherButtonTitles:otherButtonTitles[0],  otherButtonTitles[1], otherButtonTitles[2], otherButtonTitles[3], otherButtonTitles[4], nil];
    }
    
    if (self) {
        
        if (cancelBlock == nil && otherBlock == nil) {
            self.delegate = nil;
        }
        self.cancelBlock = cancelBlock;
        self.otherBlock = otherBlock;
    }
    
    return self;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
    if (_cancelBlock) {
        
        _cancelBlock(self);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *cancelTitle = [actionSheet buttonTitleAtIndex:actionSheet.cancelButtonIndex];
    NSString *selectedTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([cancelTitle isEqualToString:selectedTitle]) {
        
        if (_cancelBlock) {
            
            _cancelBlock(self);
        }
    } else {
    
        if (_otherBlock) {
            
            _otherBlock(self, buttonIndex);
        }
    }
}

@end
