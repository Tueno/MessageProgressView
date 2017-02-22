//
//  MessageProgressLayer.swift
//  MessageProgressView
//
//  Created by 上野奉勲 on 2016/07/19.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

open class MessageProgressLayer: CALayer {
    
    fileprivate let diameter: CGFloat
    fileprivate let margin: CGFloat
    fileprivate let numberOfDots: Int
    fileprivate let dotColor: UIColor
    fileprivate var circleShapeLayers: [CAShapeLayer] = []
    
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
    
    fileprivate func initShapeLayers() {
        for i in stride(from: 0, to: numberOfDots, by: 1) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path      = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter)).cgPath
            shapeLayer.fillColor = dotColor.cgColor
            shapeLayer.position  = CGPoint(x: CGFloat(i) * (diameter + margin) + margin, y: 0)
            addSublayer(shapeLayer)
            circleShapeLayers.append(shapeLayer)
        }
    }
    
    open func startAnimation() {
        let duration                     = 0.3
        let group                        = CAAnimationGroup()
        group.repeatCount                = Float.infinity
        group.duration                   = duration * 3
        let yTranslation                 = CABasicAnimation(keyPath: "transform.translation.y")
        yTranslation.fromValue           = 0
        yTranslation.toValue             = diameter * -1
        yTranslation.duration            = duration
        yTranslation.isRemovedOnCompletion = false
        yTranslation.autoreverses        = true
        for i in stride(from: 0, to: circleShapeLayers.count, by: 1) {
            let layer = circleShapeLayers[i]
            group.beginTime = CACurrentMediaTime() + Double(i) * yTranslation.duration * 0.5
            group.animations = [yTranslation]
            layer.add(group, forKey: "jump")
        }
    }
    
    open func stopAnimation() {
        for i in stride(from: 0, to: circleShapeLayers.count, by: 1) {
            let layer = circleShapeLayers[i]
            layer.removeAllAnimations()
            layer.transform = CATransform3DIdentity
        }
    }
    
}
