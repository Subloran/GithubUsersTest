//
//  MainViewController.m
//  GithubUsersTest
//
//  Created by Artem on 29/08/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <UIScrollView+InfiniteScroll.h>
#import <UIImageView+ProgressView.h>

#import "MainViewController.h"
#import "GithubAPI.h"
#import "Constants.h"

@interface MainViewController ()

@property (nonatomic, retain) UITableView* table;
@property (nonatomic, retain) NSMutableArray* users;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _users = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:self.view.bounds];
    _table.delegate = self;
    _table.dataSource = self;
    __weak MainViewController* weakself = self;
    [_table addInfiniteScrollWithHandler:^(UIScrollView *scrollView) {
        [weakself loadUsers];
    }];
    [self.view addSubview:_table];
    _table.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _table.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _table.scrollIndicatorInsets = _table.contentInset;
    _table.hidden = YES;
    
    [self loadUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* login = [[UILabel alloc] init];
        login.tag = 10;
        UIImageView* avatar = [[UIImageView alloc] init];
        avatar.tag = 100;
        avatar.clipsToBounds = YES;
        avatar.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:login];
        [login setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:avatar];
        [avatar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
                                           [NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
                                           [NSLayoutConstraint constraintWithItem:login attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[login]-5-[avatar(==50)]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(login, avatar)]];
    }
    UILabel* login = (UILabel*)[cell.contentView viewWithTag:10];
    UIImageView* avatar = (UIImageView*)[cell.contentView viewWithTag:100];
    NSDictionary* user = _users[indexPath.row];
    login.text = user[githubLoginKey];
    [avatar sd_setImageWithURL:[NSURL URLWithString:user[githubAvatarUrlKey]] usingProgressView:[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault]];
    return cell;
}

#pragma mark - Loading data

- (void)loadUsers
{
    // Looks like "since" parameter is an "id" of user
    NSNumber* since = _users.count > 0 ? [NSNumber numberWithInteger:[_users.lastObject[@"id"] integerValue]] : [NSNumber numberWithInt:0];
    [[GithubAPI sharedInstance] GET:APIGithubUsers parameters: @{@"since": since} onCompletion:^(APIResponse *response) {
        if (response.requestFailed)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Упс" message:@"Не получается загрузить" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Попробовать еще", nil];
            [alert show];
        }
        else
        {
            [_users addObjectsFromArray:response.json];
            [_table reloadData];
            [_table finishInfiniteScroll];
            _table.hidden = NO;
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
            [self loadUsers];
            break;
            
        default:
            [_table finishInfiniteScroll];
            break;
    }
}

@end
