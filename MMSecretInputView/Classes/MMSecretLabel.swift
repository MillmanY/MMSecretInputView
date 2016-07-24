//
//  SecretLabel.swift
//  Ezpay_Wallet2.0
//
//  Created by MILLMAN on 2016/7/19.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//

import UIKit

enum SecretLabelStatus {
    case None
    case Value
    case Error
}

@IBDesignable
class MMSecretLabel: UIView {

    lazy var centerLayer:CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        self.centerLayer.frame = self.bounds
        var bound = self.bounds
        let minR = min(CGRectGetWidth(bound), CGRectGetHeight(bound))/2
        bound.origin.x = (CGRectGetWidth(bound) - minR * 2) / 2
        bound.origin.y =  (CGRectGetHeight(bound) - minR  * 2) / 2
        bound.size.width = minR * 2
        bound.size.height = minR  * 2
        let bezier = UIBezierPath.init(ovalInRect: CGRectInset(bound, minR * 0.7, minR * 0.7))
        bezier.lineWidth = 1.0
        
        self.centerLayer.frame = self.bounds
        self.centerLayer.path = bezier.CGPath
    }
        
    func setStatus(status:SecretLabelStatus,color:UIColor,border:CGFloat) {
        self.layoutIfNeeded()
        self.centerLayer.transform = (status == .None) ? CATransform3DMakeScale(0.001, 0.001, 0) : CATransform3DMakeScale(1, 1, 0)
        self.setBorder(border, radius: 0.0, color: color)
        self.centerLayer.fillColor = color.CGColor
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
 

}
