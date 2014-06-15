//
//  MoviesViewController.m
//  rottentomatoes
//
//  Created by Natarajan Kannan on 6/7/14.
//  Copyright (c) 2014 Y.CORP.YAHOO.COM\natarajk. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"


@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic) int loadCount;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movies";
        self.loadCount = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.errorMessageView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil]
         forCellReuseIdentifier:@"MovieCell"];
    
    self.tableView.rowHeight = 120;
    
    // show loading icon
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading";
    
    [self reloadMoviesFromServer];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadMoviesFromServer) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadMoviesFromServer
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=3aw6qppb5a4efy3mn9q5twth";
    
    NSLog(@"%d", self.loadCount);
    if(self.loadCount % 2 == 0) {
        // set invalid url to show error message
        url = @"foo-bar";
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        self.loadCount++;
        NSLog(@"%@", connectionError);
        
        if(connectionError) {
            self.errorMessageView.hidden = NO;
            self.errorMessageView.text = @"Network error, please pull to retry.";
        } else {
            self.errorMessageView.hidden = YES;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", object);
        

            self.movies = object[@"movies"];
            [self.tableView reloadData];
        }
    }];

    
    [self.refreshControl endRefreshing];
    [self.hud hide:YES];
}

#pragma mark - our table view implementation

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"cell for row %d", indexPath.row);
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *imageUrl = movie[@"posters"][@"thumbnail"];
    
    NSURL *url = [NSURL URLWithString:imageUrl];

    [cell.posterImgView setImageWithURL:url];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Navigation Controller: %@", self.navigationController);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MovieCell *selectedCell = [tableView cellForRowAtIndexPath: indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    

    MovieViewController *mvc = [[MovieViewController alloc] init];
    mvc.movieTitle = selectedCell.titleLabel.text;
    mvc.movieDescription = selectedCell.synopsisLabel.text;
    mvc.movieBgImageUrl = movie[@"posters"][@"detailed"];
    [self.navigationController pushViewController:mvc animated:YES];

}


@end
