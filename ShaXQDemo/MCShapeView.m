//
//  MCShapeView.m
//  ShaXQDemo
//
//  Created by swhl on 16/3/7.
//  Copyright © 2016年 sprite. All rights reserved.
//

#import "MCShapeView.h"

@interface MCShapeView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

//=====================
@property (nonatomic, strong) UIView  *originView;
@property (nonatomic, strong) UIView  *moveView;



@end

@implementation MCShapeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.layer.cornerRadius = self.bounds.size.width / 2;

        _maxDistance = 50;
        
        [self _initSubViewsSec:frame];
        
        
//        [self _initSubViews:frame];
    }
    return self;
}



-(void)_initSubViewsSec:(CGRect)rect
{
    [self addSubview:self.originView];
    [self addSubview:self.moveView];
    [self.layer addSublayer:self.shapeLayer];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:pan];
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer*)sender
{
    CGPoint panPoint = [sender translationInView:self];

//    NSLog(@"panPoint--%@",NSStringFromCGPoint(panPoint));
    
    CGPoint changeCenter = self.moveView.center;
    changeCenter.x += panPoint.x;
    changeCenter.y += panPoint.y;
    self.moveView.center = changeCenter;
    [sender setTranslation:CGPointZero inView:self];

    
    CGFloat dist = [self pointToPoitnDistanceWithPoint:self.center potintB:self.moveView.center];
    
    
//     NSLog(@"dist--%.3f",dist);
    
    if (dist < 300) {
        
        if ( dist > 0) {
            //画不规则矩形
//            self.originView.hidden = NO;
//            self.shapeLayer.hidden = NO;

            NSLog(@"dist--%.3f",dist);
            CGFloat cornerRadius = self.bounds.size.width/2;
            CGFloat samllCrecleRadius = cornerRadius - dist / 10;
            _originView.bounds = CGRectMake(0, 0, samllCrecleRadius * (2 - 0.5), samllCrecleRadius * (2 - 0.5));
            _originView.layer.cornerRadius = _originView.bounds.size.width / 2;
            
            self.shapeLayer.path = [self pathWithBigCirCleView:_moveView smallCirCleView:_originView].CGPath;
        }
        
    }else {
        self.originView.hidden = YES;
        self.shapeLayer.hidden = YES;

    }
    
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (dist > _maxDistance) {
            
            
           
        } else {
            
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.center = self.originView.center;
                
            } completion:^(BOOL finished) {
                
                self.originView.hidden = NO;
            }];
        }
    }

    
}

-(void)setMaxDistance:(NSInteger)maxDistance
{
    _maxDistance = maxDistance;
}


- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor redColor].CGColor;
    }
    
    return _shapeLayer;
}

-(UIView *)originView
{
    if (!_originView) {
        _originView = [[UIView alloc] initWithFrame:self.bounds];
        _originView.backgroundColor = [UIColor redColor];
        _originView.layer.cornerRadius = self.bounds.size.width / 2;
    }
    return _originView;
}
-(UIView *)moveView
{
    if (!_moveView) {
        _moveView = [[UIView alloc] initWithFrame:self.bounds];
        _moveView.backgroundColor = [UIColor redColor];
        _moveView.layer.cornerRadius = self.bounds.size.width / 2;
    }
    return _moveView;
}

#pragma mark - 俩个圆心之间的距离
- (CGFloat)pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB
{
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    
    return dist;
}
#pragma mark - 不规则路径
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat d = [self pointToPoitnDistanceWithPoint:self.originView.center potintB:self.moveView.center];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

#pragma mark - 设置长按时候左右摇摆的动画
- (void)startShake
{
    [self.layer removeAnimationForKey:@"shake"];
    //长按左右晃动的幅度大小
    CGFloat shake = 10;
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
    keyAnim.keyPath = @"transform.translation.x";
    keyAnim.values = @[@(-shake), @(shake), @(-shake)];
    keyAnim.removedOnCompletion = NO;
    keyAnim.repeatCount = MAXFLOAT;
    //左右晃动一次的时间
    keyAnim.duration = 0.3;
    [self.layer addAnimation:keyAnim forKey:@"shake"];
}

-(void)_initSubViews:(CGRect)rect{
    
    //创建出CAShapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;//设置shapeLayer的尺寸和位置
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds /*CGRectMake(0,-40, 40, 40)*/];
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    //添加并显示
    [self.layer addSublayer:self.shapeLayer];
}

@end
