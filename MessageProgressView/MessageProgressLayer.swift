//
//  MessageProgressLayer.swift
//  MessageProgressView
//
//  Created by 上野奉勲 on 2016/07/19.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

public class MessageProgressLayer: CALayer {
    
    private let diameter: CGFloat
    private let margin: CGFloat
    private let numberOfDots: Int
    private let dotColor: UIColor
    private var circleShapeLayers: [CAShapeLayer] = []
    
    init(diameter: CGFloat, margin: CGFloat, numberOfDots: Int, dotColor: UIColor) {
        self.diameter     = diameter
        self.margin       = margin
        self.numberOfDots = numberOfDots
        self.dotColor     = dotColor
        super.init()
        initShapeLayers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initShapeLayers() {
        for i in 0.stride(to: numberOfDots, by: 1) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path      = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: diameter, height: diameter)).CGPath
            shapeLayer.fillColor = dotColor.CGColor
            shapeLayer.position  = CGPoint(x: CGFloat(i) * (diameter + margin) + margin, y: 0)
            addSublayer(shapeLayer)
            circleShapeLayers.append(shapeLayer)
        }
    }
    
    public func startAnimation() {
        let duration                     = 0.3
        let group                        = CAAnimationGroup()
        group.repeatCount                = Float.infinity
        group.duration                   = duration * 3
        let yTranslation                 = CABasicAnimation(keyPath: "transform.translation.y")
        yTranslation.fromValue           = 0
        yTranslation.toValue             = diameter * -1
        yTranslation.duration            = duration
        yTranslation.removedOnCompletion = false
        yTranslation.autoreverses        = true
        for i in 0.stride(to: circleShapeLayers.count, by: 1) {
            let layer = circleShapeLayers[i]
            group.beginTime = CACurrentMediaTime() + Double(i) * yTranslation.duration * 0.5
            group.animations = [yTranslation]
            layer.addAnimation(group, forKey: "jump")
        }
    }
    
    public func stopAnimation() {
        for i in 0.stride(to: circleShapeLayers.count, by: 1) {
            let layer = circleShapeLayers[i]
            layer.removeAllAnimations()
            layer.transform = CATransform3DIdentity
        }
    }
    
}
