//
//  SetViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-22.
//
//

#import "SetViewController.h"
#import "AboutViewController.h"
#import "ZSSourceModel.h"

@interface SetViewController (){

    NSDictionary *dir;
    NSArray *arry;
    NSArray *arry2;
    UserInfoViewController *userinfoview;
    MoreKeepVC *morekeepvc;
}



@end

@implementation SetViewController
@synthesize newsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [morekeepvc release];
    //[userinfoview release];
    [dir release];
    [arry release];
    [arry2 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSString *path=[[NSBundle mainBundle] pathForResource:@"SetList" ofType:@"plist"];
   // NSString *path = [NSString stringWithFormat:@"%@/%@.plist",[[NSBundle mainBundle] bundlePath],@"SetList"];
    //dir=[[NSDictionary alloc] initWithContentsOfFile:path];
    [self loadtableviewmore];

    //arry=[[NSArray alloc] initWithObjects:@"登  陆",@"注  册",@"获取密码", nil];
    arry2=[[NSArray alloc] initWithObjects:@"收  藏",@"关  于", nil];
    
    newsTableView.delegate=self;
    newsTableView.dataSource=self;
    // Do any additional setup after loading the view from its nib.
}


-(void) loadtableviewmore{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    if([standardUserDefault objectForKey:Key_UserName]!=nil){
        arry=[[NSArray alloc] initWithObjects:@"用户中心",@"退  出", nil];
    }else{
        arry=[[NSArray alloc] initWithObjects:@"登  陆",@"注  册", nil];
        
    }
    [newsTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadtableviewmore];
}


- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section==0){
        return [arry count];
    }else{
        return [arry2 count];
    }
}

-( NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *strreturn=@"";
    switch (section) {
        case 0:
            strreturn=@"";
            break;
        case 1:
            strreturn=@"其它";
            break;
    
        default:
            break;
    }
    return strreturn;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSArray *title=[[NSArray alloc] initWithObjects:@"中国",@"人民", nil];
//    return title;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    [subviews release];
    if(indexPath.section==0){
        cell.textLabel.text=[arry objectAtIndex:indexPath.row];
    }else if(indexPath.section==1){
        cell.textLabel.text=[arry2 objectAtIndex:indexPath.row];
    }
        
    //[cell.imageView setHidden:true];
     cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //  cell.textLabel.text=@"dd";
//    UIView * cellbgview=[[UIView alloc] init];
//    cellbgview.backgroundColor = [UIColor whiteColor];
//    cell.backgroundView = cellbgview;
//    [cellbgview release];
    return cell;
    

    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    MoreDetailViewController *detailViewController=[[MoreDetailViewController alloc] init];
    //    [self.navigationController pushViewController:detailViewController animated:YES];
    //    [detailViewController release];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    if (indexPath.section==0) {
        if([standardUserDefault objectForKey:Key_UserName]!=nil){
            switch (indexPath.row) {
                case 0:
                {
                    if (!userinfoview) {
                        userinfoview=[[UserInfoViewController alloc] init];
                    }
                    UserInfoViewController *userinfoview33=[[UserInfoViewController alloc] init];
                    [self.navigationController pushViewController:userinfoview33 animated:YES];
                    [userinfoview33 release];
                }
                    break;
                case 1:
                {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                   message:@"是否确认退出当前登陆？"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确认"
                                                         otherButtonTitles:@"取消", nil];
                    
                    alert.tag=1;
                    //alert.firstOtherButtonIndex=0;
                    
                    //alert.cancelButtonIndex=2;
                    [alert show];
                    [alert release];

                }
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                {
                    LoginViewController *loginview=[[LoginViewController alloc] init];
                    loginview.delegate = self;
                    [self.navigationController pushViewController:loginview animated:YES];
                    [loginview release];
                }
                break;
                case 1:
                {
                    RegesterViewController *regsterview=[[RegesterViewController alloc] init];
                    [self.navigationController pushViewController:regsterview animated:YES];
                    [regsterview release];
                }
                break;
                default:
                    break;
            }
        }
        
    }else if(indexPath.section==1){
        switch (indexPath.row) {
            case 0:
            {
                morekeepvc=[[MoreKeepVC alloc] init];
               // morekeepvc.delegate = self;
                [self.navigationController pushViewController:morekeepvc animated:YES];
               
            }
                break;
                
            case 1:
            {
                
                AboutViewController *aboutViewController=[[AboutViewController alloc] init];

                [self.navigationController pushViewController:aboutViewController animated:YES];
                [aboutViewController release];
                
            }
                break;
           
            default:
                break;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
        NSLog(@"ddd");
        [[ZSSourceModel defaultSource] setSuccLoginDic:nil];
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        [standardUserDefault setObject:nil  forKey:Key_UserName];
        [self loadtableviewmore];
    }
    
}


#pragma mark - PictureNewsDelegate
- (void)LoginSuccesGoTo{
    [newsTableView reloadData];
   // UserInfoViewController *userinfoview=[[UserInfoViewController alloc] init];
    //[self.navigationController pushViewController:userinfoview animated:YES];
    //[userinfoview release];
}

#pragma mark - RegesterViewDelegate
- (void)RegesterSuccesGoTo{
    [newsTableView reloadData];
    // UserInfoViewController *userinfoview=[[UserInfoViewController alloc] init];
    //[self.navigationController pushViewController:userinfoview animated:YES];
    //[userinfoview release];
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
