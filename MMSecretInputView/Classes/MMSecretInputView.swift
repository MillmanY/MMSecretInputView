//
//  SecretInputView.swift
//  Ezpay_Wallet2.0
//
//  Created by MILLMAN on 2016/7/19.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//

import UIKit
@IBDesignable
public class MMSecretInputView: UIView,UIKeyInput {
    let labelIdx = 1000
    public var completedBlock:((value:String)->Void)?
    
    private var numberArray = [String]() {
        
        didSet {
            self.setNeedsDisplay()
            if let c = self.completedBlock where self.numberArray.count == self.numberDigits && self.numberArray.count != 0{
                c(value: (self.numberArray as NSArray).componentsJoinedByString(""))
            }
        }
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.becomeFirstResponder()
        let show = UITapGestureRecognizer.init(target: self, action: #selector(MMSecretInputView.showKeyboard))
        self.addGestureRecognizer(show)
        self.setNeedsDisplay()
    }
    
    func showKeyboard () {
        self.becomeFirstResponder()
    }
    
    @IBInspectable public var numberDigits:Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var margin:Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderWidth:Int = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var normalColor: UIColor = UIColor.blackColor() {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var setValueColor: UIColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var errorColor: UIColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override public func drawRect(rect: CGRect) {
        // Drawing code
        
        let width = CGRectGetWidth(rect)
        
        let perLabWidth = (width - CGFloat((numberDigits+1) * margin)) / CGFloat(numberDigits)
        
        for i in 0..<numberDigits {
            let currentIdx = labelIdx + i
            if let lab = self.viewWithTag(currentIdx) as? MMSecretLabel {
                self.setSecretLabel(lab, idx: i)
            } else {
                let l = MMSecretLabel()
                // This line is use to designable show
                l.frame = CGRectMake(CGFloat(margin), CGFloat(margin), perLabWidth, perLabWidth)
                
                l.translatesAutoresizingMaskIntoConstraints = false
                l.tag = labelIdx + i
                l.backgroundColor = UIColor.clearColor()
                self.addSubview(l)
                self.setSecretLabel(l, idx: i)

                let leftLayout = (i == 0) ? NSLayoutConstraint.init(item: l, attribute: .Left, relatedBy: .Equal, toItem: l.superview!, attribute: .Left, multiplier: 1.0, constant: CGFloat(margin)) :
                    NSLayoutConstraint.init(item: l, attribute: .Left, relatedBy: .Equal, toItem: self.viewWithTag(currentIdx - 1)!, attribute: .Right, multiplier: 1.0, constant: CGFloat(margin))
                let heightLayout = (perLabWidth < self.frame.height - CGFloat(2*margin)) ?
                    NSLayoutConstraint.init(item: l, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: CGFloat(perLabWidth)):
                    NSLayoutConstraint.init(item: l, attribute: .Bottom, relatedBy: .Equal, toItem: l.superview!, attribute: .Bottom, multiplier: 1.0, constant: CGFloat(-margin))
                let constraint = [
                    NSLayoutConstraint.init(item: l, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: CGFloat(perLabWidth)),
                    leftLayout,
                    NSLayoutConstraint.init(item: l, attribute: .Top, relatedBy: .Equal, toItem: l.superview!, attribute: .Top, multiplier: 1.0, constant: CGFloat(margin)),
                    heightLayout]
                self.addConstraints(constraint)
            }
        }
    }
    
   public func setSecretLabelError(completed:(()->Void)) {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.shakeWith(self.center)
            for i in 0..<self.numberDigits {
                let currentIdx = self.labelIdx + i
                if let lab = self.viewWithTag(currentIdx) as? MMSecretLabel {
                    self.setSecretLabel(lab, idx: -1)
                }
            }
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.numberArray.removeAll()
                completed()
            }
        }
    }
    
    func shakeWith(originPoint:CGPoint) {
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(originPoint.x-5,originPoint.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(originPoint.x+5,originPoint.y))
        self.layer.addAnimation(animation, forKey: "Position")
    }
    
    func setSecretLabel(label:MMSecretLabel,idx:Int){
        let border = CGFloat(borderWidth)
        
        if numberArray.count <= idx || numberArray.count == 0{
            label.setStatus(.None, color: normalColor,border: border)
            
        } else  if (idx == -1) {
            label.setStatus(.Error, color:self.errorColor,border: border)
            
        } else {
            label.setStatus(.Value, color:setValueColor,border: border)
        }
    }
    
    override public func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    public func hasText() -> Bool {
        return true
    }
    
    public func insertText(text: String){
        if numberDigits > numberArray.count {
            numberArray.append(text)
            self.setNeedsDisplay()
        }
    }
    
    public func clearAllText() {
        self.numberArray.removeAll()
    }
    
    public func deleteBackward() {
        if numberArray.count > 0 {
            numberArray.removeLast()
        }
        self.setNeedsDisplay()
    }
    
    public var keyboardType: UIKeyboardType {
        get { return .NumberPad }
        set{ /* do nothing */ }
    }
}

extension UIView{

    func setBorder(width:CGFloat,radius:CGFloat,color:UIColor?){
        self.layer.cornerRadius = radius
        self.layer.borderWidth  = width
        
        if let borderColor = color{
            self.layer.borderColor  = borderColor.CGColor
        }
    }
}
