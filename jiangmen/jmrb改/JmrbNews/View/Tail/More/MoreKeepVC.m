//
//  MoreKeepVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreKeepVC.h"
#import "ZSSourceModel.h"

@interface MoreKeepVC ()

@end

@implementation MoreKeepVC
@synthesize keepTableView;
@synthesize delegate;

- (void)dealloc {
    [_newInfo release];
    [_keepArray release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [keepTableView indexPathForSelectedRow];
    [keepTableView deselectRowAtIndexPath:indexPath animated:YES];
    [keepTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _keepArray = [[[ZSSourceModel defaultSource] KeepArray] retain];
    [keepTableView setDelegate:self];
    [keepTableView setDataSource:self];
    _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    [_newInfo setDelegate:self];
    NSMutableArray *keepArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [_keepArray count]; i++) {
        NSDictionary *item_dic = [_keepArray objectAtIndex:i];
        NSDictionary *keepDic = [NSDictionary dictionaryWithObjectsAndKeys:[item_dic objectForKey:@"newsId"],@"newsId", nil];
        [keepArray addObject:keepDic];
    }
    [_newInfo setNewsArray:keepArray];
    [keepTableView setEditing:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Xib Function
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(MoreDetailGoBack)]) {
        [delegate MoreDetailGoBack];
    }
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [_keepArray count]) {
        NSLog(@"%i, %i",indexPath.section, [_keepArray count]);
        return;
    }
    [_keepArray removeObjectAtIndex:indexPath.section];
    [tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_keepArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemId = 0;
    NSMutableDictionary *dic = [_keepArray objectAtIndex:indexPath.section];
    itemId = [[dic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(MoreKeepHideTarBar:)]) {
        [delegate MoreKeepHideTarBar:YES];
    }
    [self.navigationController pushViewController:_newInfo animated:YES];
    [_newInfo initFrame];
    [_newInfo setNewsContent:itemId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indetifyString = @"keepCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifyString];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifyString] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSDictionary *itemDic = [_keepArray objectAtIndex:indexPath.section];
    [cell.textLabel setText:[itemDic objectForKey:@"newsTitle"]];
    return cell;
}

- (void)MainPageNewInfoDetailGoBack {
    if (delegate && [delegate respondsToSelector:@selector(MoreKeepHideTarBar:)]) {
        [delegate MoreKeepHideTarBar:NO];
    }
}

@end
