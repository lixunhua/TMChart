//
//  TMViewController.m
//  TMChartSampleDemo
//
//  Created by baiwulong on 02/05/2018.
//  Copyright (c) 2018 baiwulong. All rights reserved.
//

#import "TMViewController.h"
#import "TMCircleChart.h"
@interface TMViewController ()
{
    TMCircleChart *chart;
    TMCircleChart *chart2;
}
@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    chart = [[TMCircleChart alloc]initWithFrame:CGRectMake(30, 100, 100, 100)];
    [self.view addSubview:chart];
    chart.config.gradientColors = @[[UIColor redColor],[UIColor yellowColor],[UIColor greenColor]];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [chart updateProgress: random()%100/100.0 withDuration:2];
    }];
    
    chart2 = [[TMCircleChart alloc]initWithFrame:CGRectMake(30, 300, 100, 100)];
    [self.view addSubview:chart2];
    chart2.config.gradientColors = @[[UIColor redColor],[UIColor yellowColor],[UIColor greenColor]];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        image.backgroundColor = [UIColor redColor];
        chart2.endPointImageView = image;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [chart2 updateProgress: random()%100/100.0 withDuration:2];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
