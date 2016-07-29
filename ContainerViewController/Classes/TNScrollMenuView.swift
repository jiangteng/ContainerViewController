//
//  TNScrollMenuView.swift
//  Movie
//
//  Created by JiangTeng on 16/7/1.
//  Copyright © 2016年 dianping. All rights reserved.
//

import UIKit

protocol TNScrollMenuViewDelegate : class {
    func scrollMenuViewSelectedIndex(index: NSInteger);
}

class TNScrollMenuView: UIView {
    
    weak var delegate: TNScrollMenuViewDelegate?
    var scrollView:UIScrollView?
    var itemViewArray:[UILabel]? = [UILabel]()
    var itemSelectedTitleColor = UIColor?()
    
    var menuViewWidth:CGFloat = 70
    var menuViewMargin:CGFloat = 5.0
    var indicatorHeight:CGFloat = 2.0
    
    
    
    
    var viewbackgroundColor:UIColor?{
        
        didSet{
            self.backgroundColor = viewbackgroundColor
        }
    }
    
    var itemfont:UIFont!{
        
        didSet{
            
            for label:UILabel in self.itemViewArray! {
                label.font = itemfont
            }
        }
        
    }
    
    var itemTitleColor = UIColor?(){
        
        didSet{
            for label:UILabel in self.itemViewArray! {
                label.textColor = itemTitleColor
            }
        }
    }
    
    var itemIndicatorColor = UIColor?(){
        
        didSet{
            indicatorView.backgroundColor = itemIndicatorColor
        }
    }
    
    var itemTitleArray:[NSString]? {
        didSet{
            
            var views:[UILabel] = [UILabel]()
            
            for index in 0..<itemTitleArray!.count {
                let frame = CGRectMake(0, 0, menuViewWidth, CGRectGetHeight(self.frame))
                let itemView = UILabel.init(frame: frame)
                self.scrollView?.addSubview(itemView)
                itemView.tag = index
                itemView.text = itemTitleArray![index] as String
                itemView.userInteractionEnabled = true
                itemView.backgroundColor = UIColor.clearColor()
                itemView.textAlignment = .Center
                itemView.font = self.itemfont
                views.append(itemView)
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(itemViewTapAction))
                itemView.addGestureRecognizer(tapGesture)
            }
            
            self.itemViewArray = views
            
            self.indicatorView = UIView.init(frame: CGRectMake(0, self.scrollView!.frame.size.height - indicatorHeight, menuViewWidth, indicatorHeight))
            self.indicatorView.backgroundColor = self.itemIndicatorColor
            self.scrollView?.addSubview(self.indicatorView)
        }
    }

    
    private var indicatorView:UIView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,mwidth:CGFloat = 70,mmargin:CGFloat = 5.0,mindicator:CGFloat = 2.0) {
        super.init(frame: frame)

        viewbackgroundColor = UIColor.whiteColor()
        self.backgroundColor = viewbackgroundColor!
        
        menuViewWidth = mwidth
        menuViewMargin = mmargin
        indicatorHeight = mindicator

        itemfont = UIFont.systemFontOfSize(16)
        itemTitleColor = UIColor.init(colorLiteralRed: 0.866667, green: 0.866667, blue: 0.866667, alpha: 1.0)
        itemSelectedTitleColor = UIColor.init(colorLiteralRed: 0.33333, green: 0.33333, blue: 0.33333, alpha: 1.0)
        itemIndicatorColor = UIColor.init(colorLiteralRed: 0.168627, green: 0.168627, blue: 0.168627, alpha: 1.0)
        
        self.scrollView = UIScrollView.init(frame: bounds)
        self.scrollView!.showsHorizontalScrollIndicator = false
        
        self.addSubview(scrollView!)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
    }
    
    internal func setIndicatorViewFrame(ratio:CGFloat,isNextItem:Bool,toIndex:NSInteger){
        
        var indicatorX:CGFloat = 0.0
        indicatorX = (menuViewMargin + menuViewWidth)*ratio+menuViewWidth*CGFloat(toIndex) + menuViewMargin*CGFloat(toIndex+1);
        
        if (indicatorX < menuViewMargin || indicatorX > self.scrollView!.contentSize.width - (menuViewMargin + menuViewWidth)) {
            return;
        }
        
        self.indicatorView.frame = CGRectMake(indicatorX, (self.scrollView?.frame.size.height)! - indicatorHeight, menuViewWidth, indicatorHeight)

    }
    
    internal func setItem(itemTextColor:UIColor?,selectedItemTextColor:UIColor?,currentIndex:NSInteger){
        
        if itemTextColor != nil {
            self.itemTitleColor = itemTextColor
        }
        
        if selectedItemTextColor != nil {
            self.itemSelectedTitleColor = selectedItemTextColor
        }
        
        
        for index in 0..<self.itemViewArray!.count {
            let label = self.itemViewArray![index]
            if index == currentIndex {
//                label.alpha = 0.0
//                UIView.animateWithDuration(0.75, delay: 0.0, options: [.CurveLinear , .AllowUserInteraction], animations: {
//                    label.alpha = 1.0
                    label.textColor = self.itemSelectedTitleColor
//                    }, completion:nil)
            }else{
                label.textColor = self.itemTitleColor
            }
        }
    }
    
    func setShadowView() {
        
        let view = UIView()
        view.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.width, 0.5)
        view.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(view)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x:CGFloat = menuViewMargin
        
        for index in 0..<self.itemViewArray!.count {
            let width = menuViewWidth
            let iteV:UIView = self.itemViewArray![index] as UIView
            iteV.frame = CGRectMake(x, 0, width, (self.scrollView?.frame.height)!)
            x += width + menuViewMargin
        }
        
        self.scrollView?.contentSize = CGSizeMake(x, (self.scrollView?.frame.height)!)
        
        var fra:CGRect = (self.scrollView?.frame)!
        if self.frame.size.width > x {
            fra.origin.x = (self.frame.size.width - x)*0.5
            fra.size.width = x
        }else{
            fra.origin.x = 0
            fra.size.width = self.frame.size.width
        }
        
        self.scrollView?.frame = fra
        
    }
    
    func itemViewTapAction(Recongnizer:UITapGestureRecognizer){
        let tapGesture = Recongnizer as UITapGestureRecognizer
        self.delegate?.scrollMenuViewSelectedIndex((tapGesture.view?.tag)!)
    }
    
}
