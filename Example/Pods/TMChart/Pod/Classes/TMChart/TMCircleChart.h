//
//  TMCircleChart.h
//  TMChart
//
//  Created by 黎迅华 on 2018/1/2.
//  Copyright © 2018年 黎迅华. All rights reserved.
//

#import <UIKit/UIKit.h>

///=====================================================================================
///设计实现思路：
    ///  圆环进度显示,实质是不同图层的圆环图形的粗线条的叠加
    ///  实现思路:创建4个图层(轨道图层)
    ///  第1个图层:轨道图层,负责显示轨道颜色
    ///  第2个图层:进度图层,负责显示进度条颜色
    ///  第3和4个图层:进度与渐变图层,渐变圆环需要两个图层来配合,
    ///  ---- 一个是普通图层,负责绘制圆环进度,通过绘制该圆环图形的颜色进度
    ///  ---- 另外一个是渐变图层,作为普通图层的蒙版图层,通过控制普通图层的进度条来显示渐变颜色(蒙版:有普通图层中有颜色的部分就显示渐变图层的渐变颜色,没有颜色部分就空白)
    /// 渐变图层的重要知识点:
    //colors 渐变的颜色
    //locations 渐变颜色的分割点
    //startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
///=====================================================================================


///====================================================================
/// 枚举类型 - 渐变色的渐变方向
///====================================================================
typedef NS_ENUM (NSUInteger, TMCircleGradientDerection) {
    TMCircleGradientDerectionLevel,                 // 水平方向渐变
    TMCircleGradientDerectionVertical,              // 垂直方向渐变
    TMCircleGradientDerectionDownwardDiagonal,      //向下对角线渐变
    TMCircleGradientDerectionUpwardDiagonal,        //向上对角线渐变
};

///====================================================================
/// TMCircleConfig圆环配置类，配合TMCircleChart圆环工具类使用
///====================================================================
NS_ASSUME_NONNULL_BEGIN

@interface TMCircleConfig : NSObject

//圆环配置
///总进度(默认:100)
@property (nonatomic,strong) NSNumber *total;
/** 当前进度(默认:0) */
@property (nonatomic,strong) NSNumber *current;
/** 进度百分比(0~1) */
@property (nonatomic,assign) CGFloat progress;
/** 动画时间 (默认:2s) */
@property (nonatomic,assign) NSTimeInterval duration;
/** 开始角度 (默认:0) */
@property (nonatomic,assign) CGFloat startAngle;
/** 结束角度 (默认:360) */
@property (nonatomic,assign) CGFloat endAngle;
/** 偏移角度，调整开始、结束角度 (默认:-90) */
@property (nonatomic,assign) CGFloat offsetAngle;
/** 是否顺时针(默认:YES) */
@property (nonatomic,assign) BOOL clockwise;

/** 圆环宽度 (默认:8.0f)*/
@property (nonatomic,assign) CGFloat lineWidth;
/** 圆环轨道颜色 (默认:gray)*/
@property (nonatomic,strong) UIColor * trackColor;
/** 圆环颜色 (默认:white)*/
@property (nonatomic,strong) UIColor * strokeColor;
/** 圆环颜色 (默认:clear)*/
@property (nonatomic,strong) UIColor * shadowColor;
/** 圆环渐变颜色数组 */
@property (nonatomic,strong) NSArray <UIColor *>* gradientColors;
/** 圆环渐变颜色-渐变方向类型 */
@property (nonatomic,assign) TMCircleGradientDerection gradientDerection;
/** 圆环端点-自定义视图 */
@property (nonatomic,strong) UIImageView *endPointImageView;

/** 是否显示圆环中心Label */
@property (nonatomic,assign) BOOL isShowLabel;

/** 获取默认圆环配置 */
+(TMCircleConfig *)defaultConfig;

@end
NS_ASSUME_NONNULL_END


///====================================================================
/// TMCircleChart圆环工具类，可实现圆弧，自定义端点
///====================================================================
NS_ASSUME_NONNULL_BEGIN

@interface TMCircleChart : UIView

/** 圆环配置 */
@property (nonatomic,strong) TMCircleConfig *config ;
/** 文本 */
@property (nonatomic,strong) UILabel *percentLabel ;
///设置自定义端点视图(注意，设置了该属性，动画duration将失效，都设置为0.1秒)
@property (nonatomic,strong) UIImageView *endPointImageView;

///+类方法初始化,使用默认config配置
+(instancetype)circleWithFrame:(CGRect)frame;
///+类方法初始化,设置config配置对象，如需自定义端点视图，可自定义配置
+(instancetype)circleWithFrame:(CGRect)frame withConfig:(TMCircleConfig *)config;

///-对象方法初始化,设置config配置对象，如需自定义端点视图，可自定义配置
-(instancetype)initWithFrame:(CGRect)frame withConfig:(TMCircleConfig *)config;

/** 更新圆环进度(0~1) */
- (void)updateProgress:(CGFloat)progress isAnimated:(BOOL)animated;
/** 更新圆环进度,动画时间 */
- (void)updateProgress:(CGFloat)progress withDuration:(NSTimeInterval)duration;

///获取自定义端点中心点center的CGPoint
-(CGPoint)getEndDotViewCenterPoint;

@end
NS_ASSUME_NONNULL_END
