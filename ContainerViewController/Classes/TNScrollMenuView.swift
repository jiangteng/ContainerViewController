//
//  TNScrollMenuView.swift
//  Movie
//
//  Created by JiangTeng on 16/7/1.
//  Copyright © 2016年 dianping. All rights reserved.
//

import UIKit

protocol TNScrollMenuViewDelegate : class {
    func scrollMenuViewSelectedIndex(_ index: NSInteger);
}

class TNScrollMenuView: UIView {
    
    weak var delegate: TNScrollMenuViewDelegate?
    var scrollView:UIScrollView?
    var itemViewArray:[UILabel]? = [UILabel]()
    var itemSelectedTitleColor = UIColor.black
    
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
    
    var itemTitleColor = UIColor.black{
        
        didSet{
            for label:UILabel in self.itemViewArray! {
                label.textColor = itemTitleColor
            }
        }
    }
    
    var itemIndicatorColor = UIColor.black{
        
        didSet{
            indicatorView.backgroundColor = itemIndicatorColor
        }
    }
    
    var itemTitleArray:[NSString]? {
        didSet{
            
            var views:[UILabel] = [UILabel]()
            
            for index in 0..<itemTitleArray!.count {
                let frame = CGRect(x: 0, y: 0, width: menuViewWidth, height: self.frame.height)
                let itemView = UILabel.init(frame: frame)
                self.scrollView?.addSubview(itemView)
                itemView.tag = index
                itemView.text = itemTitleArray![index] as String
                itemView.isUserInteractionEnabled = true
                itemView.backgroundColor = UIColor.clear
                itemView.textAlignment = .center
                itemView.font = self.itemfont
                views.append(itemView)
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(itemViewTapAction))
                itemView.addGestureRecognizer(tapGesture)
            }
            
            self.itemViewArray = views
            
            self.indicatorView = UIView.init(frame: CGRect(x: 0, y: self.scrollView!.frame.size.height - indicatorHeight, width: menuViewWidth, height: indicatorHeight))
            self.indicatorView.backgroundColor = self.itemIndicatorColor
            self.scrollView?.addSubview(self.indicatorView)
        }
    }

    
    fileprivate var indicatorView:UIView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,mwidth:CGFloat = 70,mmargin:CGFloat = 5.0,mindicator:CGFloat = 2.0) {
        super.init(frame: frame)

        viewbackgroundColor = UIColor.white
        self.backgroundColor = viewbackgroundColor!
        
        menuViewWidth = mwidth
        menuViewMargin = mmargin
        indicatorHeight = mindicator

        itemfont = UIFont.systemFont(ofSize: 16)
        itemTitleColor = UIColor.init(colorLiteralRed: 0.866667, green: 0.866667, blue: 0.866667, alpha: 1.0)
        itemSelectedTitleColor = UIColor.init(colorLiteralRed: 0.33333, green: 0.33333, blue: 0.33333, alpha: 1.0)
        itemIndicatorColor = UIColor.init(colorLiteralRed: 0.168627, green: 0.168627, blue: 0.168627, alpha: 1.0)
        
        self.scrollView = UIScrollView.init(frame: bounds)
        self.scrollView!.showsHorizontalScrollIndicator = false
        
        self.addSubview(scrollView!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    internal func setIndicatorViewFrame(_ ratio:CGFloat,isNextItem:Bool,toIndex:NSInteger){
        
        var indicatorX:CGFloat = 0.0
        indicatorX = (menuViewMargin + menuViewWidth)*ratio+menuViewWidth*CGFloat(toIndex) + menuViewMargin*CGFloat(toIndex+1);
        
        if (indicatorX < menuViewMargin || indicatorX > self.scrollView!.contentSize.width - (menuViewMargin + menuViewWidth)) {
            return;
        }
        
        self.indicatorView.frame = CGRect(x: indicatorX, y: (self.scrollView?.frame.size.height)! - indicatorHeight, width: menuViewWidth, height: indicatorHeight)

    }
    
    internal func setItem(_ itemTextColor:UIColor?,selectedItemTextColor:UIColor?,currentIndex:NSInteger){
        
        if itemTextColor != nil {
            self.itemTitleColor = itemTextColor!
        }
        
        if selectedItemTextColor != nil {
            self.itemSelectedTitleColor = selectedItemTextColor!
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
        view.frame = CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.width, height: 0.5)
        view.backgroundColor = UIColor.lightGray
        self.addSubview(view)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x:CGFloat = menuViewMargin
        
        for index in 0..<self.itemViewArray!.count {
            let width = menuViewWidth
            let iteV:UIView = self.itemViewArray![index] as UIView
            iteV.frame = CGRect(x: x, y: 0, width: width, height: (self.scrollView?.frame.height)!)
            x += width + menuViewMargin
        }
        
        self.scrollView?.contentSize = CGSize(width: x, height: (self.scrollView?.frame.height)!)
        
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
    
    func itemViewTapAction(_ Recongnizer:UITapGestureRecognizer){
        let tapGesture = Recongnizer as UITapGestureRecognizer
        self.delegate?.scrollMenuViewSelectedIndex((tapGesture.view?.tag)!)
    }
    
}
