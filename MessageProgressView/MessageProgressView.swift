//
//  MessageProgressView.swift
//  MessageProgressView
//
//  Created by Tomonori Ueno on 2016/07/11.
//  Copyright © 2016年 Tomonori Ueno All rights reserved.
//

import UIKit

@IBDesignable public class MessageProgressView: UIView {
    
    @IBInspectable var diameter: CGFloat = 8
    @IBInspectable var margin: CGFloat   = 6
    @IBInspectable var numberOfDots: Int = 3
    @IBInspectable var dotColor: UIColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1.0)
    private var progressLayer: MessageProgressLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if !TARGET_INTERFACE_BUILDER
            commonInit()
        #endif
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        let layerFrame         = CGRect(x: 0, y: 0, width: CGFloat(numberOfDots) * (diameter + margin) + margin, height: diameter)
        progressLayer          = MessageProgressLayer(diameter: diameter, margin: margin, numberOfDots: numberOfDots, dotColor: dotColor)
        progressLayer.frame    = layerFrame
        progressLayer.position = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        layer.addSublayer(progressLayer)
    }
    
    public func startAnimation() {
        progressLayer.startAnimation()
    }
    
    public func stopAnimation() {
        progressLayer.stopAnimation()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
}

private class MessageProgressLayer: CALayer {

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

    required init?(coder aDecoder: NSCoder) {
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
    
    func startAnimation() {
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
    
    func stopAnimation() {
        for i in 0.stride(to: circleShapeLayers.count, by: 1) {
            let layer = circleShapeLayers[i]
            layer.removeAllAnimations()
            layer.transform = CATransform3DIdentity
        }
    }
    
}
