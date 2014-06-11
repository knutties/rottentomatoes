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
@property (weak, nonatomic) IBOutlet UITextView *movieDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *movieBGView;
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
    
    //self.movieTitleLabel.text = self.movieTitle;
    
    self.movieDescriptionTextView.text = self.movieDescription;
    
    NSString *imageUrl = self.movieBgImageUrl;
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    [self.movieBGView setImageWithURL:url];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
