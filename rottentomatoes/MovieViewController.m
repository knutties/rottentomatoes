//
//  MovieViewController.m
//  rottentomatoes
//
//  Created by Natarajan Kannan on 6/8/14.
//  Copyright (c) 2014 Y.CORP.YAHOO.COM\natarajk. All rights reserved.
//

#import "MovieViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *movieBGView;
@property (strong, nonatomic) UIScrollView *movieDetailsScrollView;
@property (strong, nonatomic) UILabel *movieTitleLabel;
@property (strong, nonatomic) UILabel *movieSynopsisLabel;
@property (strong, nonatomic) UIView *movieContentView;
@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movie Name";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.movieTitle;
    
    // set thumbnail for faster download
    NSString *imageURL = self.movieBgThumbnailImageUrl;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    self.movieBGView.image = [UIImage imageWithData:imageData];
    
    // load high res image
    NSURL *detailUrl = [NSURL URLWithString:self.movieBgDetailedImageUrl];
    [self.movieBGView setImageWithURL:detailUrl];
    
    // setup movie title
    self.movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
    self.movieTitleLabel.text = self.movieTitle;
    self.movieTitleLabel.textColor = [UIColor whiteColor];
    self.movieTitleLabel.backgroundColor = [UIColor clearColor];
    self.movieTitleLabel.numberOfLines = 1;
    [self.movieTitleLabel setFont:[UIFont boldSystemFontOfSize:20]];;
    
    // setup movie synopsis
    self.movieSynopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.movieTitleLabel.frame.origin.x, self.movieTitleLabel.frame.size.height + 5., 300, 320)];
    self.movieSynopsisLabel.text = self.movieDescription;
    self.movieSynopsisLabel.textColor = [UIColor whiteColor];
    self.movieSynopsisLabel.backgroundColor = [UIColor clearColor];
    self.movieSynopsisLabel.numberOfLines = 0;
    [self.movieSynopsisLabel sizeToFit];

    float totalHeight = self.movieTitleLabel.frame.size.height + self.movieSynopsisLabel.frame.size.height + 300.;
    
    // setup movie content view
    self.movieContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, totalHeight)];
    [self.movieContentView addSubview:self.movieTitleLabel];
    [self.movieContentView addSubview:self.movieSynopsisLabel];
    self.movieContentView.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
    
    // setup scrollview
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.movieDetailsScrollView = [[UIScrollView alloc]initWithFrame:fullScreenRect];
    [self.movieDetailsScrollView addSubview:self.movieContentView];
    [self.movieDetailsScrollView setContentSize:self.movieContentView.frame.size];


    // add scrollview to view
    [self.view addSubview:self.movieDetailsScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
