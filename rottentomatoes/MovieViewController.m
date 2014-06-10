//
//  MovieViewController.m
//  rottentomatoes
//
//  Created by Natarajan Kannan on 6/8/14.
//  Copyright (c) 2014 Y.CORP.YAHOO.COM\natarajk. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()
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
    
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(320, 480);
    
    UILabel *movieDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];

    
    movieDescriptionLabel.text = self.movieDescription;

    // set number of lines to zero
    movieDescriptionLabel.numberOfLines = 0;
    // resize label
    [movieDescriptionLabel sizeToFit];
    
    // set scroll view size
    tempScrollView.contentSize = CGSizeMake(tempScrollView.contentSize.width, movieDescriptionLabel.frame.size.height);
    // add myLabel
    [tempScrollView addSubview:movieDescriptionLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
