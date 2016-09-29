//
//  TNContainerViewController.swift
//  Movie
//
//  Created by JiangTeng on 16/7/1.
//  Copyright © 2016年 dianping. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



public protocol TNContainerViewControllerDelegate : class {
   func containerViewItem(_ index: NSInteger, currentController:UIViewController);
}

open class TNContainerViewController: UIViewController {

    open weak var delegate:TNContainerViewControllerDelegate?
    open var contentScrollView : UIScrollView?
    open var titles  = NSMutableArray()
    open var childControllers = NSMutableArray()
    
    open var menuItemFont:UIFont?
    open var menuItemTitleColor:UIColor?
    open var menuItemSelectedTitleColor:UIColor?
    open var menuBackGroudColor:UIColor?
    open var menuIndicatorColor:UIColor?
    
    fileprivate var topBarHeight:CGFloat?
    fileprivate var currentIndex:NSInteger?
    fileprivate var menuView:TNScrollMenuView?
    
    open var bottomHeight:CGFloat = 0.0
    
    open var menuViewHeight:CGFloat = 40
    
    open var menuWidth:CGFloat = 70
    open var menuMargin:CGFloat = 5.0
    open var indicatorHeight:CGFloat = 2.0
    
    public init(controllers:NSArray,topBarHeight:CGFloat,parentViewController:UIViewController){
        super.init(nibName: nil, bundle: nil)
        
        parentViewController.addChildViewController(self)
        self.didMove(toParentViewController: parentViewController)
        
        self.topBarHeight = topBarHeight
                
        self.childControllers = controllers.mutableCopy() as! NSMutableArray
        
        let tit = NSMutableArray()
        for vc:UIViewController in (self.childControllers as NSArray as! [UIViewController]){
            tit.add(vc.value(forKey: "title")!)
        }
        
        self.titles = tit.mutableCopy() as! NSMutableArray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let viewCover = UIView()
        self.view.addSubview(viewCover)
        
        self.contentScrollView = UIScrollView.init()
        self.contentScrollView?.frame = CGRect(x: 0, y: topBarHeight! + menuViewHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - topBarHeight! - menuViewHeight - bottomHeight)
        self.contentScrollView?.backgroundColor = UIColor.clear
        self.contentScrollView?.isPagingEnabled = true
        self.contentScrollView!.delegate = self
        self.contentScrollView?.showsHorizontalScrollIndicator = false
        self.contentScrollView?.scrollsToTop = false
        self.view.addSubview(self.contentScrollView!)
        
        self.contentScrollView?.contentSize = CGSize(width: (self.contentScrollView?.frame.width)! * CGFloat( self.childControllers.count), height: (self.contentScrollView?.frame.height)!)
        
        for index in 0..<self.childControllers.count {
            let obj = self.childControllers.object(at: index)
            if obj is UIViewController {
                let controller:UIViewController = obj as! UIViewController
                let scrollWidth = contentScrollView!.frame.size.width;
                let scrollHeght = contentScrollView!.frame.size.height;
                controller.view.frame = CGRect(x: CGFloat(index) * scrollWidth, y: 0, width: scrollWidth, height: scrollHeght);
                contentScrollView!.addSubview(controller.view)
            }
        }
        
        // meunView
        menuView = TNScrollMenuView.init(frame: CGRect(x: 0, y: topBarHeight!, width: self.view.frame.size.width, height: menuViewHeight),mwidth: menuWidth,mmargin: menuMargin,mindicator: indicatorHeight)
        menuView!.backgroundColor = UIColor.clear
        menuView!.delegate = self;
        menuView!.viewbackgroundColor = self.menuBackGroudColor;
        menuView!.itemfont = self.menuItemFont;
        menuView!.itemTitleColor = self.menuItemTitleColor!;
        menuView!.itemIndicatorColor = self.menuIndicatorColor!;
        menuView!.scrollView!.scrollsToTop = false;
        
        menuView!.itemTitleArray = self.titles as NSArray as? [NSString]
        self.view.addSubview(menuView!)
        
    
        menuView!.setShadowView()
        self.scrollMenuViewSelectedIndex(0)
        
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        self.contentScrollView?.frame = CGRect(x: 0, y: topBarHeight! + menuViewHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - topBarHeight! - menuViewHeight - bottomHeight)

        self.contentScrollView?.contentSize = CGSize(width: (self.contentScrollView?.frame.width)! * CGFloat( self.childControllers.count), height: (self.contentScrollView?.frame.height)!)

        for index in 0..<self.childControllers.count {
            let obj = self.childControllers.object(at: index)
            if obj is UIViewController {
                let controller:UIViewController = obj as! UIViewController
                let scrollWidth = contentScrollView!.frame.size.width;
                let scrollHeght = contentScrollView!.frame.size.height;
                controller.view.frame = CGRect(x: CGFloat(index) * scrollWidth, y: 0, width: scrollWidth, height: scrollHeght);
            }
        }
        
    }
    
    fileprivate func setChildViewController(_ currentIndex:NSInteger){
        for index in 0..<self.childControllers.count {
            let obj = self.childControllers.object(at: index)
            if obj is UIViewController {
                let viewC = obj as! UIViewController
                if index == currentIndex {
                    viewC.willMove(toParentViewController: self)
                    self.addChildViewController(viewC)
                    viewC.didMove(toParentViewController: self)
                }else{
                    viewC.willMove(toParentViewController: self)
                    viewC.removeFromParentViewController()
                    viewC.didMove(toParentViewController: self)
                }
            }

        }
    }
}

extension TNContainerViewController : TNScrollMenuViewDelegate{
    
    func scrollMenuViewSelectedIndex(_ index: NSInteger){
        self.contentScrollView?.setContentOffset(CGPoint(x: CGFloat(index)*(self.contentScrollView?.frame.width)!,y: 0.0), animated: true)
        
        self.menuView?.setItem(self.menuItemTitleColor, selectedItemTextColor: self.menuItemSelectedTitleColor, currentIndex: index)
        
        self.setChildViewController(index)
        if index == self.currentIndex {
            return
        }
        
        self.currentIndex = index
        self.delegate?.containerViewItem(self.currentIndex!, currentController: self.childControllers[self.currentIndex!] as! UIViewController)
        
    }
}

extension TNContainerViewController : UIScrollViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let oldPointX:CGFloat = CGFloat(self.currentIndex!) * scrollView.frame.size.width
        let ratio:CGFloat = (scrollView.contentOffset.x - oldPointX)/scrollView.frame.size.width
        
        let isToNextItem:Bool = self.contentScrollView?.contentOffset.x > oldPointX
        let targetIndex:NSInteger = isToNextItem ? self.currentIndex! + 1 : self.currentIndex! - 1
        
        var currentItemOffsetX:CGFloat = 1.0
        var eachLastItemWidth:CGFloat = 0.0
        
        eachLastItemWidth = (menuView!.scrollView!.contentSize.width - menuView!.scrollView!.frame.size.width) / CGFloat(menuView!.itemViewArray!.count - 1);
        
        currentItemOffsetX = (menuView!.scrollView!.contentSize.width - menuView!.scrollView!.frame.size.width) * CGFloat(self.currentIndex!) / CGFloat(menuView!.itemViewArray!.count - 1);
        
        if targetIndex >= 0 && targetIndex < self.childControllers.count {
            // MenuView Move
            var indicatorUpdateRatio:CGFloat = ratio;
            var offset:CGPoint = menuView!.scrollView!.contentOffset;
            offset.x = eachLastItemWidth * ratio + currentItemOffsetX;
            menuView?.scrollView?.setContentOffset(offset, animated: false);
            menuView?.setIndicatorViewFrame(ratio, isNextItem: isToNextItem, toIndex: self.currentIndex!)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex:Int = Int(scrollView.contentOffset.x / contentScrollView!.frame.size.width)
        
        if (currentIndex == self.currentIndex) { return; }
        self.currentIndex = currentIndex;
        
        menuView?.setItem(self.menuItemTitleColor, selectedItemTextColor: self.menuItemSelectedTitleColor, currentIndex: currentIndex)
        
        self.delegate?.containerViewItem(self.currentIndex!, currentController: self.childControllers[self.currentIndex!] as! UIViewController)
        self.setChildViewController(self.currentIndex!)
    }
    
    
}
