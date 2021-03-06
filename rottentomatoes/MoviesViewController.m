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
@property (nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movies";
        self.loadCount = 1;
        self.dataUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=3aw6qppb5a4efy3mn9q5twth";
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
    NSString *url = self.dataUrl;
    
    // NSLog(@"count of loads %d", self.loadCount);
    if(self.loadCount % 2 == 0) {
        // set invalid url to show error message
        url = @"foo-bar";
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        self.loadCount++;
        // NSLog(@"%@", connectionError);
        // NSLog(@"%@", data);
        
        if(connectionError) {
            self.errorMessageView.hidden = NO;
            self.errorMessageView.text = @"Network error, please pull to retry.";
        } else {
            self.errorMessageView.hidden = YES;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // NSLog(@"%@", object);
        

            self.movies = object[@"movies"];
            [self.tableView reloadData];
        }
    }];

    
    [self.refreshControl endRefreshing];
    [self.hud hide:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    if(self.selectedIndexPath != nil) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}


#pragma mark - our table view implementation

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"cell for row %d", indexPath.row);
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *imageUrl = movie[@"posters"][@"thumbnail"];
    
    // NSURL *url = [NSURL URLWithString:imageUrl];

    // [cell.posterImgView setImageWithURL:url];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL                                                           URLWithString:imageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [cell.posterImgView setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"1x1"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.posterImgView.image = image;
        [UIView animateWithDuration:1.0 animations:^{
            cell.posterImgView.alpha = 1.0;
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"Navigation Controller: %@", self.navigationController);
    
    MovieCell *selectedCell = [tableView cellForRowAtIndexPath: indexPath];
    
    // save index path to restore on pop of view controller
    self.selectedIndexPath = indexPath;
    
    // change selected cell background color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor yellowColor];
    [selectedCell setSelectedBackgroundView:bgColorView];

    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieViewController *mvc = [[MovieViewController alloc] init];
    mvc.movieTitle = selectedCell.titleLabel.text;
    mvc.movieDescription = selectedCell.synopsisLabel.text;
    mvc.movieBgThumbnailImageUrl = movie[@"posters"][@"thumbnail"];
    mvc.movieBgDetailedImageUrl = movie[@"posters"][@"original"];
    [self.navigationController pushViewController:mvc animated:YES];

}


@end
