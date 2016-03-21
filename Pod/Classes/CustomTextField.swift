//
//  LeftButtonTextField.swift
//  Tou
//
//  Created by 王海晨 on 16/1/25.
//  Copyright © 2016年 36kr. All rights reserved.
//

import UIKit
import Ruler

public class CustomTextField: UITextField {
    public var leftButtonTitle: String? {
        didSet {
            updateLeftButton()
        }
    }
    
    public var rightFlag: Bool = false
    
    public func leftButtonAddTarget(target: AnyObject, action: Selector) {
        leftButton?.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    private var leftButton: UIButton? {
        didSet {
            leftButton?.titleLabel?.lineBreakMode = .ByWordWrapping
        }
    }
    
    private let underlineLayer = CALayer()
    
    private lazy var verticalLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    private let underlineWidth: CGFloat = Constants.Layout.onePixel
    
    private var horizontalSpacing: CGFloat {
        return 15
    }
    
    private var editingSpacing: CGFloat = 20
    
    private var accessaryButtonWH: CGFloat = 15.0
    
    private var rightPadding: CGFloat = 5
    
    private var rightAreaWidth: CGFloat = 60
    
    private let textFieldInsets = CGPoint(x: 0, y: 0)
    
    private var leftButtonXOffset: CGFloat {
        if let button = self.leftButton {
            return button.frame.width + horizontalSpacing
        }
        return 0
    }

    private lazy var cleanButton: UIButton = {
        let button = UIButton(type: .System)
        button.setImage(UIImage(named: "login_icon_bounced_close@3x"), forState: .Normal)
        button.tintColor = UIColor.grayColor()
        button.addTarget(self, action: Selector("cleanAction"), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.hidden = true
        return button
    }()
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "login_icon_eye@3x"), forState: .Normal)
        button.setImage(UIImage(named: "login_icon_eye_highlight@3x"), forState: .Highlighted)
        button.tintColor = UIColor.grayColor()
        button.addTarget(self, action: Selector("showPasswordAction"), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.hidden = true
        return button
    }()
    
    // MARK: - override
    
    override public func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        if leftButtonXOffset > 0 {
            x = leftButtonXOffset + horizontalSpacing
        }
        var rect = CGRectOffset(bounds, textFieldInsets.x + x, textFieldInsets.y)
        
        let padding = CGFloat(Ruler.iPhoneVertical(0, 0, 0, editingSpacing - x).value)
        rect.size.width = CGRectGetMinX(cleanButton.frame) - padding
        
        return rect
    }
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        if leftButtonXOffset > 0 {
            x = leftButtonXOffset + horizontalSpacing
        }
        var rect = CGRectOffset(bounds, textFieldInsets.x + x, textFieldInsets.y)
        rect.size.width = CGRectGetMinX(cleanButton.frame) - editingSpacing - x
        return rect
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        if leftButtonXOffset > 0 {
            x = leftButtonXOffset + horizontalSpacing
        }
        var rect = CGRectOffset(bounds, textFieldInsets.x + x, textFieldInsets.y)
        rect.size.width = CGRectGetMinX(cleanButton.frame) - editingSpacing - x
        return rect
    }
    
    override public func drawRect(rect: CGRect) {
        updateAccessaryButtons()
        updatePlacehold()
        updateUnderline()
        addSubview(cleanButton)
        
        if secureTextEntry && tag != 99 {
            showPasswordButton.selected = true
            addSubview(showPasswordButton)
        }
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let _ = newSuperview {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChange:"), name: UITextFieldTextDidChangeNotification, object: self)
        }
    }
    
    override public func becomeFirstResponder() -> Bool {
        underlineLayer.backgroundColor = Constants.Color.prompt.CGColor
        if let text = text {
            cleanButton.hidden = text.isEmpty
            showPasswordButton.hidden = text.isEmpty && secureTextEntry
        }else {
            cleanButton.hidden = true
            showPasswordButton.hidden = true
        }
        return super.becomeFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        underlineLayer.backgroundColor = Constants.Color.empty.CGColor
        cleanButton.hidden = true
        showPasswordButton.hidden = true
        return super.resignFirstResponder()
    }

    // MARK: - private
    
    private func updateUnderline() {
        underlineLayer.frame = rectForUnderline(underlineWidth)
        underlineLayer.backgroundColor = Constants.Color.empty.CGColor
        layer.addSublayer(underlineLayer)
    }
    
    private func updatePlacehold() {
        setValue(Constants.Color.prompt, forKeyPath: "_placeholderLabel.textColor")
    }
    
    private func updateAccessaryButtons() {
        var left: CGFloat = 0
        let right: CGFloat = rightFlag ?  rightAreaWidth + rightPadding : rightPadding
        
        if secureTextEntry && tag != 99 {
            left = showPasswordButton.frame.width + horizontalSpacing
            var showPasswordButtonFrame = showPasswordButton.frame
            showPasswordButtonFrame.size.width = accessaryButtonWH
            showPasswordButtonFrame.origin.x = frame.width - showPasswordButtonFrame.width - right
            showPasswordButtonFrame.size.height = accessaryButtonWH
            showPasswordButtonFrame.origin.y = (frame.height - showPasswordButtonFrame.size.height) / 2.0
            showPasswordButton.frame = showPasswordButtonFrame
        }
        var cleanButtonFrame = cleanButton.frame
        cleanButtonFrame.size.width = accessaryButtonWH
        cleanButtonFrame.origin.x = frame.width - cleanButtonFrame.width - left - right
        cleanButtonFrame.size.height = accessaryButtonWH
        cleanButtonFrame.origin.y = (frame.height - cleanButtonFrame.size.height) / 2.0
        cleanButton.frame = cleanButtonFrame
    }
    
    private func updateLeftButton() {
        if leftButton == nil {
            leftButton = UIButton(type: .System)
            leftButton?.titleLabel?.font = font
            addSubview(leftButton!)
            layer.addSublayer(verticalLayer)
            verticalLayer.backgroundColor = Constants.Color.empty.CGColor
        }
        leftButton?.setTitle(leftButtonTitle, forState: .Normal)
        layoutLeftButton()
        layoutVerticalLayer()
    }
    
    func showPasswordAction() {
        showPasswordButton.selected = !showPasswordButton.selected
        resignFirstResponder()
        secureTextEntry = showPasswordButton.selected
        becomeFirstResponder()
        let temp = text
        text = " "
        text = temp
    }
    
    func cleanAction() {
        text = ""
        endEditing(true)
        cleanButton.hidden = text == nil || text!.isEmpty
        showPasswordButton.hidden = text == nil || text!.isEmpty
    }
    
    private func rectForUnderline(thickness: CGFloat) -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
    }
    
    func textDidChange(notification: NSNotification) {
        guard let object = notification.object as? CustomTextField where object == self, let text = text else { return }
        cleanButton.hidden = text.isEmpty
        showPasswordButton.hidden = text.isEmpty && secureTextEntry
    }
    
    // MARK: - layout 
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutLeftButton()
    }
    
    private func layoutLeftButton() {
        guard let button = leftButton else { return }
        button.sizeToFit()
        var frame = button.frame
        frame.size.height = bounds.height
        frame.origin.x = 0
        frame.origin.y = 0
        button.frame = frame
    }
    
    private func layoutVerticalLayer() {
        guard let _ = leftButton else { return }
        var frame = CGRect.zero
        frame.size.width = Constants.Layout.onePixel
        
        if let lineHeight = font?.lineHeight {
            frame.size.height = lineHeight
            frame.origin.y = (self.frame.height - lineHeight) * 0.5
        }
        frame.origin.x = leftButtonXOffset
        verticalLayer.frame = frame
    }
}
