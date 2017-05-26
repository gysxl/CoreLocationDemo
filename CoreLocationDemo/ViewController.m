//
//  ViewController.m
//  CoreLocationDemo
//
//  Created by didi on 2017/5/26.
//  Copyright © 2017年 didi. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic,strong) UILabel *cityLable;
@property (nonatomic,strong) UIButton *selectCityButton;
@property (nonatomic,strong) NSString *currentCity;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)*0.5-30, CGRectGetHeight(self.view.bounds)*0.5-80, 60, 100)];
    self.cityLable.text = @"城市名";
    self.cityLable.textColor = [UIColor redColor];
    self.selectCityButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)*0.5-50, CGRectGetHeight(self.view.bounds)*0.5+30, 100, 40)];
    [self.selectCityButton setBackgroundColor:[UIColor redColor]];
//    self.selectCityButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    //    UIButton *selectCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.selectCityButton setFrame:CGRectMake(10, 10, 22, 22)];
    [self.selectCityButton setTitle:@"定位城市" forState:UIControlStateNormal];
    [self.selectCityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.selectCityButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.cityLable];
    [self.view addSubview:self.selectCityButton];
    [self.selectCityButton addTarget:self action:@selector(loate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)loate:(UIButton*)button{
    //判断是否开启定位功能
    if ([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1;
        [self.locationManager requestWhenInUseAuthorization];
        self.currentCity = [[NSString alloc] init];
        [self.locationManager startUpdatingLocation];
    }
}

//定位失败的异常处理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //    [self.delegate showLocationAlert];
    //    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //打开定位设置
    //        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //        [[UIApplication sharedApplication] openURL:settingsURL];
    //    }];
    //    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //
    //    }];
    //    [alertVC addAction:cancel];
    //    [alertVC addAction:ok];
    //    [self presentViewController:alertVC animated:YES completion:nil];
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        if (placemarks.count > 0){
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity){
                self.currentCity = @"无法定位当前城市";
            }
            self.cityLable.text = self.currentCity;
            NSLog(@"%@",self.currentCity);
        }
        else if (error == nil&& placemarks.count ==0){
            NSLog(@"No location and error return");
        }
        else if (error){
            NSLog(@"location error: %@ ",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
