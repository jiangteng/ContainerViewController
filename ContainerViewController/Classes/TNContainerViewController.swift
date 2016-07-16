//
//  TNContainerViewController.swift
//  Movie
//
//  Created by JiangTeng on 16/7/1.
//  Copyright © 2016年 dianping. All rights reserved.
//

import UIKit


public protocol TNContainerViewControllerDelegate : class {
   func containerViewItem(index: NSInteger, currentController:UIViewController);
}

public class TNContainerViewController: UIViewController {

    public weak var delegate:TNContainerViewControllerDelegate?
    public var contentScrollView : UIScrollView?
    public var titles  = NSMutableArray()
    public var childControllers = NSMutableArray()
    
    public var menuItemFont:UIFont?
    public var menuItemTitleColor:UIColor?
    public var menuItemSelectedTitleColor:UIColor?
    public var menuBackGroudColor:UIColor?
    public var menuIndicatorColor:UIColor?
    
    private var topBarHeight:CGFloat?
    private var currentIndex:NSInteger?
    private var menuView:TNScrollMenuView?
    
    public var bottomHeight:CGFloat = 0.0
    
    public var menuViewHeight:CGFloat = 40
    
    public var menuWidth:CGFloat = 70
    public var menuMargin:CGFloat = 5.0
    public var indicatorHeight:CGFloat = 2.0
    
    public init(controllers:NSArray,topBarHeight:CGFloat,parentViewController:UIViewController){
        super.init(nibName: nil, bundle: nil)
        
        parentViewController.addChildViewController(self)
        self.didMoveToParentViewController(parentViewController)
        
        self.topBarHeight = topBarHeight
                
        self.childControllers = controllers.mutableCopy() as! NSMutableArray
        
        let tit = NSMutableArray()
        for vc:UIViewController in (self.childControllers as NSArray as! [UIViewController]){
            tit.addObject(vc.valueForKey("title")!)
        }
        
        self.titles = tit.mutableCopy() as! NSMutableArray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let viewCover = UIView()
        self.view.addSubview(viewCover)
        
        self.contentScrollView = UIScrollView.init()
        self.contentScrollView?.frame = CGRectMake(0, topBarHeight! + menuViewHeight, self.view.frame.size.width, self.view.frame.size.height - topBarHeight! - menuViewHeight - bottomHeight)
        self.contentScrollView?.backgroundColor = UIColor.clearColor()
        self.contentScrollView?.pagingEnabled = true
        self.contentScrollView!.delegate = self
        self.contentScrollView?.showsHorizontalScrollIndicator = false
        self.contentScrollView?.scrollsToTop = false
        self.view.addSubview(self.contentScrollView!)
        
        self.contentScrollView?.contentSize = CGSizeMake((self.contentScrollView?.frame.width)! * CGFloat( self.childControllers.count), (self.contentScrollView?.frame.height)!)
        
        for index in 0..<self.childControllers.count {
            let obj = self.childControllers.objectAtIndex(index)
            if obj is UIViewController {
                let controller:UIViewController = obj as! UIViewController
                let scrollWidth = contentScrollView!.frame.size.width;
                let scrollHeght = contentScrollView!.frame.size.height;
                controller.view.frame = CGRectMake(CGFloat(index) * scrollWidth, 0, scrollWidth, scrollHeght);
                contentScrollView!.addSubview(controller.view)
            }
        }
        
        // meunView
        menuView = TNScrollMenuView.init(frame: CGRectMake(0, topBarHeight!, self.view.frame.size.width, menuViewHeight),mwidth: menuWidth,mmargin: menuMargin,mindicator: indicatorHeight)
        menuView!.backgroundColor = UIColor.clearColor()
        menuView!.delegate = self;
        menuView!.viewbackgroundColor = self.menuBackGroudColor;
        menuView!.itemfont = self.menuItemFont;
        menuView!.itemTitleColor = self.menuItemTitleColor;
        menuView!.itemIndicatorColor = self.menuIndicatorColor;
        menuView!.scrollView!.scrollsToTop = false;
        
        menuView!.itemTitleArray = self.titles as NSArray as? [NSString]
        self.view.addSubview(menuView!)
        
    
        menuView!.setShadowView()
        self.scrollMenuViewSelectedIndex(0)
        
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        self.contentScrollView?.frame = CGRectMake(0, topBarHeight! + menuViewHeight, self.view.frame.size.width, self.view.frame.size.height - topBarHeight! - menuViewHeight - bottomHeight)

        self.contentScrollView?.contentSize = CGSizeMake((self.contentScrollView?.frame.width)! * CGFloat( self.childControllers.count), (self.contentScrollView?.frame.height)!)

        for index in 0..<self.childControllers.count {
            let obj = self.childControllers.objectAtIndex(index)
            if obj is UIViewController {
                let controller:UIViewController = obj as! UIViewController
                let scrollWidth = contentScrollView!.frame.size.width;
                let scrollHeght = contentScrollView!.frame.size.height;
                controller.view.frame = CGRectMake(CGFloat(index) * scrollWidth, 0, scrollWidth, scrollHeght);
            }
        }
        
    }
    
    private func setChildViewController(currentIndex:NSInteger){
        for index in 0..<self.childControllers.count {
            let obj = self.childControllers.objectAtIndex(index)
            if obj is UIViewController {
                let viewC = obj as! UIViewController
                if index == currentIndex {
                    viewC.willMoveToParentViewController(self)
                    self.addChildViewController(viewC)
                    viewC.didMoveToParentViewController(self)
                }else{
                    viewC.willMoveToParentViewController(self)
                    viewC.removeFromParentViewController()
                    viewC.didMoveToParentViewController(self)
                }
            }

        }
    }
}

extension TNContainerViewController : TNScrollMenuViewDelegate{
    
    func scrollMenuViewSelectedIndex(index: NSInteger){
        self.contentScrollView?.setContentOffset(CGPointMake(CGFloat(index)*(self.contentScrollView?.frame.width)!,0.0), animated: true)
        
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
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let oldPointX:CGFloat = CGFloat(self.currentIndex!) * scrollView.frame.size.width
        let ratio:CGFloat = (scrollView.contentOffset.x - oldPointX)/scrollView.frame.size.width
        
        let isToNextItem:Bool = self.contentScrollView?.contentOffset.x > oldPointX
        let targetIndex:NSInteger = isToNextItem ? self.currentIndex! + 1 : self.currentIndex! - 1
        
        var  nextItemOffsetX:CGFloat = 1.0
        var currentItemOffsetX:CGFloat = 1.0
        
        
        nextItemOffsetX = (menuView!.scrollView!.contentSize.width - menuView!.scrollView!.frame.size.width) * CGFloat(targetIndex) / CGFloat(menuView!.itemViewArray!.count - 1);
        currentItemOffsetX = (menuView!.scrollView!.contentSize.width - menuView!.scrollView!.frame.size.width) * CGFloat(self.currentIndex!) / CGFloat(menuView!.itemViewArray!.count - 1);
        
        if targetIndex >= 0 && targetIndex < self.childControllers.count {
            // MenuView Move
            var indicatorUpdateRatio:CGFloat = ratio;
            if isToNextItem {
                
                var offset:CGPoint = menuView!.scrollView!.contentOffset;
                offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX;
                menuView?.scrollView?.setContentOffset(offset, animated: false)
                
                indicatorUpdateRatio = indicatorUpdateRatio * 1;
                menuView?.setIndicatorViewFrame(indicatorUpdateRatio, isNextItem: isToNextItem, toIndex: self.currentIndex!)
            } else {
                
                var offset:CGPoint = menuView!.scrollView!.contentOffset;
                offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
                menuView?.scrollView?.setContentOffset(offset, animated: false)
                
                indicatorUpdateRatio = indicatorUpdateRatio * -1;
                menuView?.setIndicatorViewFrame(indicatorUpdateRatio, isNextItem: isToNextItem, toIndex: targetIndex)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentIndex:Int = Int(scrollView.contentOffset.x / contentScrollView!.frame.size.width)
        
        if (currentIndex == self.currentIndex) { return; }
        self.currentIndex = currentIndex;
        
        menuView?.setItem(self.menuItemTitleColor, selectedItemTextColor: self.menuItemSelectedTitleColor, currentIndex: currentIndex)
        
        self.delegate?.containerViewItem(self.currentIndex!, currentController: self.childControllers[self.currentIndex!] as! UIViewController)
        self.setChildViewController(self.currentIndex!)
    }
    
    
}
