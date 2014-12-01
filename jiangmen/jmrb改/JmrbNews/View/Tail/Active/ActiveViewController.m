//
//  ActiveViewController.m
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import "ActiveViewController.h"

@interface ActiveViewController ()

@end

@implementation ActiveViewController
@synthesize newsTableView;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    
    newsTableView.dataSource=self;
    newsTableView.delegate=self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.newsTableView setTableFooterView:v];
    [v release];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 36, 36)];
            imageView1.image=[UIImage imageNamed:@"baoniaoactiveicon.png"];
            [cell.contentView addSubview:imageView1];
            [imageView1 release],imageView1=nil;
            
            NSString *title1=@"报料";
            UILabel *lblTtitle1=[[UILabel alloc] initWithFrame:CGRectMake(60, 12, 160, 26)];
            lblTtitle1.backgroundColor=[UIColor clearColor];
            lblTtitle1.font=[UIFont boldSystemFontOfSize:18];
            lblTtitle1.textColor=[UIColor grayColor];
            lblTtitle1.text=title1;
            [cell.contentView addSubview:lblTtitle1];
        }
            break;
        case 1:
        {
            UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 36, 36)];
            imageView2.image=[UIImage imageNamed:@"toupiaoactiveicon.png"];
            [cell.contentView addSubview:imageView2];
            [imageView2 release],imageView2=nil;
            
            NSString *title2=@"投票";
            UILabel *lblTtitle2=[[UILabel alloc] initWithFrame:CGRectMake(60, 12, 160, 26)];
            lblTtitle2.backgroundColor=[UIColor clearColor];
            lblTtitle2.textColor=[UIColor grayColor];
            lblTtitle2.font=[UIFont boldSystemFontOfSize:18];
            lblTtitle2.text=title2;
            [cell.contentView addSubview:lblTtitle2];
        }
            break;
        case 2:
        {
            UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 36, 36)];
            imageView3.image=[UIImage imageNamed:@"choujiangactiveicon.png"];
            [cell.contentView addSubview:imageView3];
            [imageView3 release],imageView3=nil;
            
            NSString *title3=@"抽奖";
            UILabel *lblTtitle3=[[UILabel alloc] initWithFrame:CGRectMake(60, 12, 160, 26)];
            lblTtitle3.backgroundColor=[UIColor clearColor];
            lblTtitle3.textColor=[UIColor grayColor];
            lblTtitle3.font=[UIFont boldSystemFontOfSize:18];
            lblTtitle3.text=title3;
            [cell.contentView addSubview:lblTtitle3];
        }
        break;
       
        default:
            break;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右边箭头
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:{
            BaoLiaoActiveViewController *personnewsvc=[[BaoLiaoActiveViewController alloc] init];
            personnewsvc.delegate=self;
            [self.navigationController pushViewController:personnewsvc animated:YES];
            //[self presentModalViewController:personnewsvc animated:YES];
            [personnewsvc release];
        }
            break;
            
        case 1:{
            TouPiaoActiveViewController *touPiao=[[TouPiaoActiveViewController alloc] init];
            [self.navigationController pushViewController:touPiao animated:YES];
            [touPiao release];

        }
            break;
        case 2:{
            NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *objectDic =  [standardUserDefault objectForKey:Key_UserName];
            if(objectDic!=nil){
                AwardViewController *award=[[AwardViewController alloc] init];
                [self.navigationController pushViewController:award animated:YES];
                [award release];
            }else{
                UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登陆,请登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alterview show];
                [alterview release];
            }
            

        }
            break;

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}


#pragma mark - BaoLiaoActiveViewDelegate
- (void)BaoLiaoActiveViewHideTarBar:(BOOL)isHide{
    if (delegate && [delegate respondsToSelector:@selector(ActiveViewHideTarBar:)]) {
        [delegate ActiveViewHideTarBar:isHide];
    }
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
