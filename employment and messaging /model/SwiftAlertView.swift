//
//  SwiftAlertView.swift
//  SwiftAlertView
//
//  Created by Dinh Quan on 8/26/15.
//  Copyright (c) 2015 Dinh Quan. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

open class SwiftAlertView: UIView {
    
    
    open var setFrame: Bool = false
    // MARK: Public Properties
    open weak var delegate: SwiftAlertViewDelegate? // delegate
    open var titleLabel: UILabel! // access titleLabel to customize the title font, color
    open var messageLabel: UILabel! // access messageLabel to customize the message font, color
    
    open var cancelButtonIndex: Int! // default is 0, set this property if you want to change the position of cancel button

    open var backgroundImage: UIImage?
    // public var backgroundColor: UIColor? // inherits from UIView
    
    open var buttonTitleColor: UIColor! // to change the title color of all buttons
    open var buttonHeight: Double! // default is 44
    
    open var separatorColor: UIColor! // to change the separator color
    open var hideSeparator: Bool! // to hide the separater color
    open var cornerRadiusS: Double! // default is 8 px

    open var dismissOnOtherButtonClicked: Bool! // default is true, if you want the alert view will not be dismissed when clicking on other buttons, set this property to false
    open var highlightOnButtonClicked: Bool! // default is true
    open var dimBackgroundWhenShowing: Bool! // default is true
    open var dimAlpha: Double! // default is 0.2
    open var dismissOnOutsideClicked: Bool! // default is false

    open var appearTime: Double! // default is 0.2 second
    open var disappearTime: Double! // default is 0.1 second

    open var appearType: SwiftAlertViewAppearType! // to change the appear type
    open var disappearType: SwiftAlertViewDisappearType! // to change the disappear type
    
    // customize the margin & spacing of title & message
    open var titleSideMargin: Double!  // default is 20 px
    open var messageSideMargin: Double!  // default is 20 px
    open var titleTopMargin: Double!  // default is 20 px
    open var messageBottomMargin: Double! // default is 20 px
    open var titleToMessageSpacing: Double! // default is 10 px

    // closure for handling button clicked action
    open var clickedButtonAction:((_ buttonIndex: Int) -> (Void))? // all buttons
    open var clickedCancelButtonAction:((Void) -> (Void))? // for cancel button
    open var clickedOtherButtonAction:((_ buttonIndex: Int) -> (Void))? // sometimes you want to handle the other button click event but don't want to write if/else in clickedButtonAction closure, use this property

    /** Example of using these closures
    alertView.clickedButtonAction = {(buttonIndex) -> Void in
        println("Button Clicked At Index \(buttonIndex)")
    }
    alertView.clickedCancelButtonAction = {
        println("Cancel Button Clicked")
    }
    alertView.clickedOtherButtonAction = {(buttonIndex) -> Void in
        println("Other Button Clicked At Index \(buttonIndex)")
    }
    */
    
    // MARK: Constants
    
    fileprivate let kSeparatorWidth = 0.5
    fileprivate let kDefaultWidth = 270.0
    fileprivate let kDefaultHeight = 144.0
    fileprivate let kDefaultTitleSizeMargin = 20.0
    fileprivate let kDefaultMessageSizeMargin = 20.0
    fileprivate let kDefaultButtonHeight = 44.0
    fileprivate let kDefaultCornerRadius = 0.0
    fileprivate let kDefaultTitleTopMargin = 20.0
    fileprivate let kDefaultTitleToMessageSpacing = 10.0
    fileprivate let kDefaultMessageBottomMargin = 20.0
    fileprivate let kDefaultDimAlpha = 0.4
    
    
    // MARK: Private Properties
    fileprivate var contentView: UIView?
    fileprivate var buttons = [UIButton]()
    fileprivate var backgroundImageView: UIImageView?
    fileprivate var dimView: UIView?
    fileprivate var title: String?
    fileprivate var message: String?
    fileprivate var cancelButtonTitle: String?
    fileprivate var otherButtonTitles = [String]()
    fileprivate var viewWidth: Double!
    fileprivate var viewHeight: Double!
    
    
    // MARK: Init
    
    // init with title and message, set title to nil to make alert be no title, same with message
    public init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    // init with title and message, use this constructor in case of only one button
    public init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }
    
    public init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    // init with custom content view
    public init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    public init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }
    
    public init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    // init with custom nib file from main bundle, make sure this file exists
    public init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
    
        let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as? UIView
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    
    public init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as? UIView

        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }
    
    public init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        
        let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as? UIView
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
    public init(contentView: UIView!){
        super.init(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        setUp(nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: nil, otherButtonTitles: nil)

    }
    
    // MARK: Public Functions
    
    // access the buttons to customize their font & color
    open func buttonAtIndex(_ index: Int) -> UIButton? {
        if index >= 0 && index < buttons.count {
            return buttons[index]
        }
        
        return nil
    }
    
    // show the alert view at center of screen
    open func show() {
        if let window: UIWindow = UIApplication.shared.keyWindow {
            show(window)
        }
    }
    
    // show the alert view at center of a view
    open func show(_ view: UIView) {
        layoutElementBeforeShowing()
        
        if setFrame == false {
            self.frame = CGRect(x: (Double(view.frame.size.width) - viewWidth)/2, y: (Double(view.frame.size.height) - viewHeight)/2, width: viewWidth, height: viewHeight)
        }else {
            self.frame = CGRect(x: 0, y: Double(view.frame.size.height) - viewHeight, width: viewWidth, height: viewHeight)
        }
        

        if dimBackgroundWhenShowing == true {
            dimView = UIView(frame: view.bounds)
            dimView!.backgroundColor = UIColor(white: 0, alpha: CGFloat(dimAlpha))
            view.addSubview(dimView!)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(outsideClicked(_:)))
            dimView!.addGestureRecognizer(recognizer)
        }
        
        if delegate?.responds(to: #selector(SwiftAlertViewDelegate.willPresentAlertView(_:))) == true {
            delegate?.willPresentAlertView!(self)
        }
        
        view.addSubview(self)
        view.bringSubview(toFront: self)
        
        switch appearType! {
        case .fadeIn:
            self.alpha = 0
            UIView.animate(withDuration: appearTime, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.alpha = 1
                }, completion: { (finished) -> Void in
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didPresentAlertView(_:))) == true {
                        self.delegate?.didPresentAlertView!(self)
                    }
            })
            break
        case .flyFromTop:
            let tempFrame = self.frame
            self.frame = CGRect(x: self.frame.origin.x, y: 0 - self.frame.size.height - 10, width: self.frame.size.width, height: self.frame.size.height)
            UIView.animate(withDuration: appearTime, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.frame = tempFrame
                }, completion: { (finished) -> Void in
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didPresentAlertView(_:))) == true {
                        self.delegate?.didPresentAlertView!(self)
                    }
            })
            break
        case .flyFromLeft:
            let tempFrame = self.frame
            self.frame = CGRect(x: 0 - self.frame.size.width - 10, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            UIView.animate(withDuration: appearTime, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.frame = tempFrame
                }, completion: { (finished) -> Void in
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didPresentAlertView(_:))) == true {
                        self.delegate?.didPresentAlertView!(self)
                    }
            })
            break
        default:
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.alpha = 0.6
            UIView.animate(withDuration: appearTime, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
                self.alpha = 1
            }, completion: { (finished) -> Void in
                if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didPresentAlertView(_:))) == true {
                    self.delegate?.didPresentAlertView!(self)
                }
            }) 
            break
        }
    }
    
    // programmatically dismiss the alert view
    open func dismiss() {
        if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.willDismissAlertView(_:))) == true {
            self.delegate?.willDismissAlertView!(self)
        }
        
        if dimView != nil {
            UIView.animate(withDuration: disappearTime, animations: { () -> Void in
                self.dimView?.alpha = 0
                }, completion: { (finished) -> Void in
                    self.dimView?.removeFromSuperview()
                    self.dimView = nil
            })
        }
        
        if disappearType == SwiftAlertViewDisappearType.default {
            self.transform = CGAffineTransform.identity
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.alpha = 0
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didDismissAlertView(_:))) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        } else if disappearType == SwiftAlertViewDisappearType.fadeOut {
            self.alpha = 1
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.alpha = 0
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didDismissAlertView(_:))) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        } else if disappearType == SwiftAlertViewDisappearType.flyToBottom {
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.frame = CGRect(x: self.frame.origin.x, y: self.superview!.frame.size.height + 10, width: self.frame.size.width, height: self.frame.size.height)
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didDismissAlertView(_:))) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        } else if disappearType == SwiftAlertViewDisappearType.flyToRight {
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.frame = CGRect(x: self.superview!.frame.size.width + 10, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
                }) { (finished) -> Void in
                    self.removeFromSuperview()
                    if self.delegate?.responds(to: #selector(SwiftAlertViewDelegate.didDismissAlertView(_:))) == true {
                        self.delegate?.didDismissAlertView!(self)
                    }
            }
        }



    }
    
    // declare the closure to handle clicked button event
    open func handleClickedButtonAction(_ action: @escaping (_ buttonIndex: Int) -> (Void)) {
        clickedButtonAction = action
    }
    

    // MARK: Private Functions

    fileprivate func setUp(_ title: String?, message: String?, contentView: UIView?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        self.delegate = delegate
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        if otherButtonTitles != nil {
            self.otherButtonTitles = otherButtonTitles!
        }
        if contentView != nil {
            self.contentView = contentView
        }
        setUpDefaultValue()
        setUpElements()
        setUpDefaultAppearance()
        if contentView != nil {
            viewWidth = Double(self.contentView!.frame.size.width)
        }
        
        if title == nil || message == nil {
            titleToMessageSpacing = 0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    @objc func deviceDidRotate(_ aNotifitation: Notification) -> Void {
        dimView?.removeFromSuperview()
        dimView = nil
        show()
    }

    fileprivate func setUpDefaultValue() {
        clipsToBounds = true
        viewWidth = kDefaultWidth
        viewHeight = kDefaultHeight
        titleSideMargin = kDefaultTitleSizeMargin
        messageSideMargin = kDefaultMessageSizeMargin
        buttonHeight = kDefaultButtonHeight
        titleTopMargin = kDefaultTitleTopMargin
        titleToMessageSpacing = kDefaultTitleToMessageSpacing
        messageBottomMargin = kDefaultMessageBottomMargin
        dimAlpha = kDefaultDimAlpha
        dimBackgroundWhenShowing = true
        dismissOnOtherButtonClicked = true
        highlightOnButtonClicked = true
        dismissOnOutsideClicked = false
        hideSeparator = false
        cornerRadiusS = kDefaultCornerRadius
        cancelButtonIndex = 0
        appearTime = 0.2
        disappearTime = 0.1
        appearType = SwiftAlertViewAppearType.default
        disappearType = SwiftAlertViewDisappearType.default
        separatorColor = UIColor(red: 196.0/255, green: 196.0/255, blue: 201.0/255, alpha: 1.0)
        buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        layer.cornerRadius = CGFloat(cornerRadiusS)
    }
    func setCornerRadius(_ corner:Int){
        layer.cornerRadius = CGFloat(corner)
    }
    fileprivate func setUpElements() {
        titleLabel = UILabel(frame: CGRect.zero)
        messageLabel = UILabel(frame: CGRect.zero)
        
        if title != nil {
            titleLabel.text = title
            addSubview(titleLabel)
        }
        if message != nil {
            messageLabel.text = message
            addSubview(messageLabel)
        }
        
        if let contentView = contentView {
            contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
            
            addSubview(contentView)
        }
        
        if let cancelTitle = cancelButtonTitle {
            let cancelButton = UIButton(type: UIButtonType.custom)
            cancelButton.setTitle(cancelTitle, for: UIControlState())
            buttons.append(cancelButton)
            addSubview(cancelButton)
        }
        
        for otherTitle in otherButtonTitles {
            let otherButton = UIButton(type: UIButtonType.custom)
            
            otherButton.setTitle(otherTitle, for: UIControlState())
            buttons.append(otherButton)
            addSubview(otherButton)
        }
    }
    
    fileprivate func setUpDefaultAppearance() {
        self.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        if let backgroundImage = backgroundImage {
            backgroundImageView = UIImageView(frame: self.bounds)
            backgroundImageView?.image = backgroundImage
            addSubview(backgroundImageView!)
            sendSubview(toBack: backgroundImageView!)
        }
        
        if title != nil {
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.backgroundColor = UIColor.clear
        }
        
        if message != nil {
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            messageLabel.textColor = UIColor.black
            messageLabel.font = UIFont.systemFont(ofSize: 13)
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.backgroundColor = UIColor.clear
        }
        
        var i = 0
        for button in buttons {
            button.tag = i
            i += 1
            button.backgroundColor = UIColor.clear
            button.setTitleColor(buttonTitleColor, for: UIControlState())
            if button.tag == cancelButtonIndex {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    fileprivate func layoutElementBeforeShowing() {
        // Reorder buttons
        if cancelButtonTitle != nil {
            if cancelButtonIndex > 0 && cancelButtonIndex < buttons.count {
                let cancelButton = buttons.remove(at: 0)
                buttons.insert(cancelButton, at: cancelButtonIndex)
            }
        }
        
        var i = 0
        for button in buttons {
            button.tag = i
            i += 1
            
            if !buttonTitleColor.isEqual(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)) {
                button.setTitleColor(buttonTitleColor, for: UIControlState())
            }
            
            button.addTarget(self, action: #selector(SwiftAlertView.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        }
        
        if title != nil {
            titleLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - titleSideMargin*2, height: 0)
            labelHeightToFit(titleLabel)
        }
        if message != nil {
            messageLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - messageSideMargin*2, height: 0)
            labelHeightToFit(messageLabel)
        }
        if title != nil {
            titleLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + Double(titleLabel.frame.size.height)/2)
        }
        if message != nil {
            messageLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + Double(titleLabel.frame.size.height) + titleToMessageSpacing + Double(messageLabel.frame.size.height)/2)
        }
        
        let topPartHeight = (contentView == nil) ? (Double(titleTopMargin) + Double(titleLabel.frame.size.height) + Double(titleToMessageSpacing) + Double(messageLabel.frame.size.height) + messageBottomMargin) : Double(contentView!.frame.size.height)
        
        if buttons.count == 2 {
            viewHeight = topPartHeight + buttonHeight
            let leftButton = buttons[0]
            let rightButton = buttons[1]
            leftButton.frame = CGRect(x: 0, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            rightButton.frame = CGRect(x: viewWidth/2, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            
            if hideSeparator == false {
                let horLine = UIView(frame: CGRect(x: 0, y: Double(leftButton.frame.origin.y), width: viewWidth, height: kSeparatorWidth))
                horLine.backgroundColor = separatorColor
                addSubview(horLine)
                
                let verLine = UIView(frame: CGRect(x: viewWidth/2, y: Double(leftButton.frame.origin.y), width: kSeparatorWidth, height: Double(leftButton.frame.size.height)))
                verLine.backgroundColor = separatorColor
                addSubview(verLine)
            }

        } else {
            viewHeight = topPartHeight + buttonHeight * Double(buttons.count)
            var j = 1
            
            for button in buttons.reversed() {
                button.frame = CGRect(x: 0, y: viewHeight-buttonHeight*Double(j), width: viewWidth, height: buttonHeight)
                j += 1
                if hideSeparator == false {
                    let lineView = UIView(frame: CGRect(x: 0, y: Double(button.frame.origin.y), width: viewWidth, height: kSeparatorWidth))
                    lineView.backgroundColor = separatorColor
                    addSubview(lineView)
                }
            }
        }
    }
    
    
    // MARK: Actions
    
    @objc func buttonClicked(_ button: UIButton) {
        if (highlightOnButtonClicked == true) {
            let originColor = button.backgroundColor?.withAlphaComponent(0)
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.1)
            let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { () -> Void in
                button.backgroundColor = originColor
            })
        }
        
        let buttonIndex = button.tag
        
        if delegate?.responds(to: #selector(SwiftAlertViewDelegate.alertView(_:clickedButtonAtIndex:))) == true {
            delegate?.alertView!(self, clickedButtonAtIndex: buttonIndex)
        }
        
        if clickedButtonAction != nil {
            clickedButtonAction!(buttonIndex)
        }
        
        if buttonIndex == cancelButtonIndex {
            if clickedCancelButtonAction != nil {
                dismiss()
            }
        } else {
            if clickedOtherButtonAction != nil {
                clickedOtherButtonAction!(buttonIndex)
            }
        }
        
        if dismissOnOtherButtonClicked == true {
            dismiss()
        } else if buttonIndex == cancelButtonIndex {
            dismiss()
        }
    }
    
    @objc func outsideClicked(_ recognizer: UITapGestureRecognizer) {
        print("Hello")
          dismiss()
        if let v = dismissOnOutsideClicked {
            if v{
                delegate?.touchDismissAlertView!(self);
            }
        }
    }
    
    
    // MARK: Utils
    
    fileprivate func labelHeightToFit(_ label: UILabel) {
        let maxWidth = label.frame.size.width
        let maxHeight : CGFloat = 10000
        let rect = label.attributedText?.boundingRect(with: CGSize(width: maxWidth, height: maxHeight),
            options: .usesLineFragmentOrigin, context: nil)
        var frame = label.frame
        frame.size.height = rect!.size.height
        label.frame = frame
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftAlertView {
    
    public static func show(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?, configureAppearance:(_ alertView: SwiftAlertView)->(Void), clickedButtonAction:@escaping (_ buttonIndex: Int)->(Void)){
        let alertView = SwiftAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
        alertView.handleClickedButtonAction(clickedButtonAction)
        configureAppearance(alertView)
        alertView.show()
    }
}


public enum SwiftAlertViewAppearType : Int {
    
    case `default`
    case fadeIn
    case flyFromTop
    case flyFromLeft
}


public enum SwiftAlertViewDisappearType : Int {
    
    case `default`
    case fadeOut
    case flyToBottom
    case flyToRight
}


@objc public protocol SwiftAlertViewDelegate : NSObjectProtocol{
    
    // Called when a button is clicked.
    @objc optional func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int)
    
    @objc optional func willPresentAlertView(_ alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didPresentAlertView(_ alertView: SwiftAlertView) // after animation
    
    @objc optional func willDismissAlertView(_ alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didDismissAlertView(_ alertView: SwiftAlertView) // after animation

    @objc optional func touchDismissAlertView(_ alertView: SwiftAlertView) // before animation and showing view


}
