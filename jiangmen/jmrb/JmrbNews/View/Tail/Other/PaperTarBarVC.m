//
//  PaperTarBarVC.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "PaperTarBarVC.h"
#import "AppDelegate.h"

@implementation PaperTarBarVC
@synthesize delegate;
@synthesize btnList, btnMore, btnPicture, btnMainPage, btnPersonNews;

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [btnMainPage setSelected:YES];
}

- (IBAction)clickTarBar:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isLoading]) {
        return;
    }
    
    if ([(UIButton *)sender isSelected]) {
        return;
    }
    [btnPicture setSelected:NO];
    [btnPersonNews setSelected:NO];
    [btnMore setSelected:NO];
    [btnMainPage setSelected:NO];
    [btnList setSelected:NO];
    switch ([(UIButton *)sender tag]) {
        case 0:
            [btnMainPage setSelected:YES];
            if (delegate && [delegate respondsToSelector:@selector(tarBarSelectedItem:)]) {
                [delegate tarBarSelectedItem:0];
            }
            break;
        case 1:
            [btnPicture setSelected:YES];
            if (delegate && [delegate respondsToSelector:@selector(tarBarSelectedItem:)]) {
                [delegate tarBarSelectedItem:1];
            }
            break;
        case 2:
            [btnList setSelected:YES];
            if (delegate && [delegate respondsToSelector:@selector(tarBarSelectedItem:)]) {
                [delegate tarBarSelectedItem:2];
            }
            break;
        case 3:
            [btnPersonNews setSelected:YES];
            if (delegate && [delegate respondsToSelector:@selector(tarBarSelectedItem:)]) {
                [delegate tarBarSelectedItem:3];
            }
            break;
        case 4:
            [btnMore setSelected:YES];
            if (delegate && [delegate respondsToSelector:@selector(tarBarSelectedItem:)]) {
                [delegate tarBarSelectedItem:4];
            }
            break;
        default:
            break;
    }
}

@end
