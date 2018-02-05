//
//  TMCircleChart.m
//  TMChart
//
//  Created by 黎迅华 on 2018/1/2.
//  Copyright © 2018年 黎迅华. All rights reserved.
//

#import "TMCircleChart.h"

///=====================================================================================
/// TMCircleConfig圆环配置类
///=====================================================================================
@implementation TMCircleConfig
///获取默认配置
+(TMCircleConfig *)defaultConfig{
    TMCircleConfig *defaultConfig = [[TMCircleConfig alloc]init];
    defaultConfig.total = @(100);
    defaultConfig.current = @(0);
    defaultConfig.progress = [defaultConfig.current floatValue]/[defaultConfig.total floatValue];
    defaultConfig.duration = 2;
    defaultConfig.offsetAngle = -90;
    defaultConfig.startAngle = 0.0f;
    defaultConfig.endAngle = 360.0f;
    defaultConfig.lineWidth = 8.0f;
    defaultConfig.clockwise = YES;
    defaultConfig.trackColor = [UIColor grayColor];
    defaultConfig.strokeColor = [UIColor greenColor];
    defaultConfig.gradientDerection = TMCircleGradientDerectionLevel;
    defaultConfig.isShowLabel = YES;
    return defaultConfig;
}

@end


///=====================================================================================
///  TMCircleChart
///=====================================================================================
@interface TMCircleChart()
///图层
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) CAShapeLayer *circleBackgroundLayer;
@property (nonatomic,strong) CAShapeLayer *gradientMaskLayer;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@end

@implementation TMCircleChart

///初始化,使用默认config配置
+(instancetype)circleWithFrame:(CGRect)frame{
    return [[TMCircleChart alloc]initWithFrame:frame];
}

///初始化,使用默认config配置
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

///初始化,设置config配置对象
+(instancetype)circleWithFrame:(CGRect)frame withConfig:(TMCircleConfig *)config{
    return [[TMCircleChart alloc]initWithFrame:frame withConfig:config];
}

///初始化,设置config配置对象
- (instancetype)initWithFrame:(CGRect)frame withConfig:(TMCircleConfig *)config{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        [self setup];
    }
    return self;
}

///初始化配置
-(void)setup{
    if (!self.config) {
        self.config = [TMCircleConfig defaultConfig];
    }
    //创建贝塞尔对象,目的是为了拿到圆环的路径path
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                              radius:(self.frame.size.height * 0.5) - (self.config.lineWidth/2.0f)
                                                          startAngle:(self.config.startAngle+self.config.offsetAngle)/180.0 * M_PI
                                                            endAngle:(self.config.endAngle+self.config.offsetAngle)/180.0 * M_PI
                                                           clockwise:self.config.clockwise];

    
    //1.添加圆环背景图层(放置在最下面一层)
    self.circleBackgroundLayer             = [CAShapeLayer layer];          //创建图层
    self.circleBackgroundLayer.path        = circlePath.CGPath;             //图层路径形状
    self.circleBackgroundLayer.lineCap     = kCALineCapRound;               //圆环边线的端点形状类型
    self.circleBackgroundLayer.lineWidth   = self.config.lineWidth;         //圆环宽度(线宽度)
    self.circleBackgroundLayer.fillColor   = [UIColor clearColor].CGColor;  //图层中间颜色(挖空)
    self.circleBackgroundLayer.strokeColor = self.config.trackColor.CGColor;//图层边线(边线条颜色)
    self.circleBackgroundLayer.strokeEnd   = 1.0;
    self.circleBackgroundLayer.zPosition   = -1;
    [self.layer addSublayer:self.circleBackgroundLayer];

    
    //2.添加圆环图层(中间层:第2层)(叠加在第一层上面)
    //覆盖轨道图层,通过设置该图层的绘制长度strokeEnd,来叠加控制显示圆环进度
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.path          = circlePath.CGPath;
    self.circleLayer.lineCap       = kCALineCapRound;
    self.circleLayer.fillColor     = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = self.config.strokeColor.CGColor;
    self.circleLayer.lineWidth     = self.config.lineWidth;
    self.circleLayer.zPosition     = 1;
    [self.layer addSublayer:self.circleLayer];
    
    
    ///3 添加了渐变图层,就需要将圆环图层设为透明色,不然圆环图层会遮挡住底部的图层(会影响轨道颜色)
    //3.1设置图形图层(假如需要设置渐变色,就需要执行这部分)
    //通过控制这个图层的strokeEnd属性来控制渐变图层的显示部分(如不懂蒙版,百度一下蒙版原理)
    self.gradientMaskLayer = [CAShapeLayer layer];
    self.gradientMaskLayer.path = self.circleLayer.path;
    self.gradientMaskLayer.fillColor = [[UIColor clearColor] CGColor];   //设置为透明色,使用蒙版时,过滤删除渐变图层中该部分的渐变颜色
    self.gradientMaskLayer.strokeColor = [[UIColor blackColor] CGColor]; //设置一种颜色,使用蒙版工具可以检测到有颜色,就保存该部分的渐变颜色
    self.gradientMaskLayer.lineWidth = self.config.lineWidth;
    self.gradientMaskLayer.lineCap = kCALineCapRound;
    CGRect gradientFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    //3.2为上面的图形图层添加蒙版图层-渐变图层
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = gradientFrame;
    self.gradientMaskLayer.frame = gradientFrame;
    NSMutableArray *colorArray =[[NSMutableArray alloc]init];
    NSMutableArray *colorLocationArray =[[NSMutableArray alloc]init];
    for (int i =0 ; i<self.config.gradientColors.count ; i++ ) {
        UIColor *color = self.config.gradientColors[i];
        [colorArray addObject:(__bridge id)color.CGColor];
        [colorLocationArray addObject:@(i*1.0/(self.config.gradientColors.count-1)+0.01)];
    }
    self.gradientLayer.colors = colorArray;
    self.gradientLayer.mask = self.gradientMaskLayer; //设置渐变图层为gradientMaskLayer的蒙版图层
    [self.circleLayer addSublayer:self.gradientLayer]; //添加渐变图层到圆环图层
    //通过设置开始与结束点的位置来控制渐变颜色
    self.gradientLayer.locations = colorLocationArray;
    //设置渐变色的渐变方向
    switch (self.config.gradientDerection) {
        case TMCircleGradientDerectionLevel:
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        case TMCircleGradientDerectionVertical:
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            break;
        case TMCircleGradientDerectionDownwardDiagonal:
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 1);
            break;
        case TMCircleGradientDerectionUpwardDiagonal:
            self.gradientLayer.startPoint = CGPointMake(0, 1);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        default:
            break;
    }
    self.gradientMaskLayer.strokeEnd = self.config.progress;//控制蒙版显示部分(通过控制该部分的颜色多少来蒙版处理显示多少渐变色)

    
    ///percentLabel(可有可无的控件)
    self.percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.1, self.frame.size.height/2-15, self.frame.size.width*0.8, 30)];
    [self addSubview:self.percentLabel];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    self.percentLabel.textColor = [UIColor grayColor];

    ///自定义端点视图(自定义端点必须要定义一个视图)
    if (_config.endPointImageView) {
        _config.endPointImageView.layer.masksToBounds = true;
        _config.endPointImageView.layer.cornerRadius = _config.endPointImageView.bounds.size.width/2;
        [self addSubview:_config.endPointImageView];
    }
}

/** 更新圆环进度 */
- (void)updateProgress:(CGFloat)progress isAnimated:(BOOL)animated{
    [self updateProgress:progress withAnimated:animated withDuration:self.config.duration];
}

/** 更新圆环进度,动画时间 */
- (void)updateProgress:(CGFloat)progress withDuration:(NSTimeInterval)duration{
    [self updateProgress:progress withAnimated:YES withDuration:duration];
}

/** 更新圆环进度*/
-(void)updateProgress:(CGFloat)progress withAnimated:(BOOL)animated withDuration:(NSTimeInterval)duration{
    if (_config.endPointImageView) {
        duration = 0.1;
        CGFloat lastProgress = self.config.progress;
        [CATransaction begin];
        [CATransaction setDisableActions:!animated];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [CATransaction setAnimationDuration:duration];
        [self strokeWithProgress:progress];
        [CATransaction commit];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
        animation.keyPath = @"position";
        //设置动画时间
        animation.duration = duration;
        // 告诉在动画结束的时候不要移除
        animation.removedOnCompletion = NO;
        // 始终保持最新的效果
        animation.fillMode = kCAFillModeBoth;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //贝塞尔曲线
        
        // 设置贝塞尔曲线路径
        CGFloat startAngle = lastProgress*M_PI*2+_config.offsetAngle/180.0*M_PI;
        CGFloat endAngle =  progress*M_PI*2+_config.offsetAngle/180.0*M_PI;
        BOOL clockwise = YES;
        if (startAngle>endAngle) {
            clockwise = NO;
        }else{
            clockwise = YES;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2.0f-self.config.lineWidth/2.0f startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        animation.path = path.CGPath;
        // 将动画对象添加到视图的layer上
        [_config.endPointImageView.layer addAnimation:animation forKey:nil];
    }else{
        [CATransaction begin];
        [CATransaction setDisableActions:!animated];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setAnimationDuration:duration];
        [self strokeWithProgress:progress];
        [CATransaction commit];
    }
}

//绘制圆环进度
-(void)strokeWithProgress:(CGFloat)progress{
    self.config.progress = progress;
    if (self.config.gradientColors) { //假如设置了渐变色,圆环图层设为透明色
        if (self.gradientLayer.locations.count==0) {
            //设置渐变色的渐变位置
            NSMutableArray *colorArray =[[NSMutableArray alloc]init];
            NSMutableArray *colorLocationArray =[[NSMutableArray alloc]init];
            for (int i =0 ; i<self.config.gradientColors.count ; i++ ) {
                UIColor *color = self.config.gradientColors[i];
                [colorArray addObject:(__bridge id)color.CGColor];
                [colorLocationArray addObject:@(i*1.0/(self.config.gradientColors.count-1)+0.01)];
            }
            self.gradientLayer.colors = colorArray;
            self.gradientLayer.locations = colorLocationArray;
            self.circleLayer.strokeColor = [UIColor clearColor].CGColor;
            self.circleLayer.fillColor = [UIColor clearColor].CGColor;
        }
        self.gradientMaskLayer.strokeEnd = progress;
    }else{
        self.gradientMaskLayer.strokeColor = [UIColor clearColor].CGColor;
        self.gradientMaskLayer.fillColor = [UIColor clearColor].CGColor;
        self.circleLayer.strokeEnd = progress;
    }
    if (self.config.isShowLabel) {
        self.percentLabel.text = [NSString stringWithFormat:@"%.1f",progress];
    }
}

///设置自定义端点视图
-(void)setEndPointImageView:(UIImageView *)endPointImageView{
    _config.endPointImageView = endPointImageView;
    _config.endPointImageView.layer.masksToBounds = true;
    _config.endPointImageView.layer.cornerRadius = _config.endPointImageView.bounds.size.width/2;
    [self.circleLayer addSublayer:_config.endPointImageView.layer];
}

//更新自定义端点视图的的center位置
-(CGPoint)getEndDotViewCenterPoint{
    //转成弧度
    CGFloat radianAngle = M_PI*2*_config.progress;
    float radius = (self.bounds.size.width)/2.0-_config.lineWidth/2;
    int index = (radianAngle)/M_PI_2;//用户区分在第几象限内
    float needAngle = radianAngle - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 0:
            // NSLog(@"第一象限");
            x = self.config.lineWidth/2.0f + radius + sinf(needAngle)*radius;
            y = self.config.lineWidth/2.0f + radius - cosf(needAngle)*radius;
            break;
        case 1:
            // NSLog(@"第二象限");
            x = self.config.lineWidth/2.0f + radius + cosf(needAngle)*radius;
            y = self.config.lineWidth/2.0f + radius + sinf(needAngle)*radius;
            break;
        case 2:
            // NSLog(@"第三象限");
            x = self.config.lineWidth/2.0f + radius - sinf(needAngle)*radius;
            y = self.config.lineWidth/2.0f + radius + cosf(needAngle)*radius;
            break;
        case 3:
            // NSLog(@"第四象限");
            x = self.config.lineWidth/2.0f + radius - cosf(needAngle)*radius;
            y = self.config.lineWidth/2.0f + radius - sinf(needAngle)*radius;
            break;
        default:
            break;
    }
    return CGPointMake(x, y);
}

@end
