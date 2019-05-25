//
//  ViewController.m
//  TableViewTest
//
//  Created by GikkiAres on 2019/5/6.
//  Copyright © 2019 TinyWind. All rights reserved.
//

#import "ViewController.h"
#import "GaDisplayManager.h"

@interface ViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GaHudView *hudView;
@property (nonatomic,strong) NSArray *arr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _arr = @[@"ActivityIndicator",@"ActivityIndicator with label",@"ActivityIndicator with label and detail",@"ActivityIndicator with label and detail and btn",@"Only title",@"Custom indicator"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSString * str = _arr[indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    switch (indexPath.row) {
        case 0:{
            //仅仅只有转圈
            GaHudView * hudView = [GaDisplayManager displayActivityInSuperview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [GaDisplayManager disappearHudView:hudView];
            });
            break;
        }
        case 1:{
            //转圈+标题
           GaHudView * hudView = [GaDisplayManager displayActivityIndicatorWithTitle:@"Loading..." detail:nil buttonTitle:nil inSuperview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [GaDisplayManager disappearHudView:hudView];
            });
            break;
        }
        case 2:{
            //转圈+标题+详情
           GaHudView * hudView = [GaDisplayManager displayActivityIndicatorWithTitle:@"Loading..." detail:@"Please wait for a moment" buttonTitle:nil inSuperview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [GaDisplayManager disappearHudView:hudView];
            });
            
            break;
        }
        case 3:{
            //转圈+标题+详情+按钮
            GaHudView * hudView = [GaDisplayManager displayActivityIndicatorWithTitle:@"Loading..." detail:@"请稍等片刻,马上就要处理完毕了" buttonTitle:@"Confirm" inSuperview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [GaDisplayManager disappearHudView:hudView];
            });
            break;
        }
        case 4:{
            //文字
            [GaDisplayManager displayMessage:@"Hello,World!" inSuperview:self.view interval:2];
            break;
        }
        case 5:{
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Saber.jpg"]];
            GaHudView * hudView = [GaDisplayManager displayIndicatorView:iv title:@"Loading..." detail:@"请稍等片刻,马上就要处理完毕了" buttonTitle:@"Confirm" inSuperview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [GaDisplayManager disappearHudViewFromSuper:hudView];
            });
            break;
        }
            
        default:{
            break;
        }
    }
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}


@end
