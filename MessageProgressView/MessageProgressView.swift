//
//  MessageProgressView.swift
//  MessageProgressView
//
//  Created by Tomonori Ueno on 2016/07/11.
//  Copyright © 2016年 Tomonori Ueno All rights reserved.
//

import UIKit

@IBDesignable
open class MessageProgressView: UIView {
    
    @IBInspectable open var diameter: CGFloat = 8
    @IBInspectable open var margin: CGFloat   = 6
    @IBInspectable open var numberOfDots: Int = 3
    @IBInspectable open var dotColor: UIColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1.0)
    fileprivate var progressLayer: MessageProgressLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if !TARGET_INTERFACE_BUILDER
            commonInit()
        #endif
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    fileprivate func commonInit() {
        let layerFrame         = CGRect(x: 0, y: 0, width: CGFloat(numberOfDots) * (diameter + margin) + margin, height: diameter)
        progressLayer          = MessageProgressLayer(diameter: diameter, margin: margin, numberOfDots: numberOfDots, dotColor: dotColor)
        progressLayer.frame    = layerFrame
        progressLayer.position = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        layer.addSublayer(progressLayer)
    }
    
    open func startAnimation() {
        progressLayer.startAnimation()
    }
    
    open func stopAnimation() {
        progressLayer.stopAnimation()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
}
