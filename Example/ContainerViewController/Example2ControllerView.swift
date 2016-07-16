//
//  Example2ControllerView.swift
//  ContainerViewController
//
//  Created by JiangTeng on 16/7/16.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import ContainerViewController

class Example2ControllerView: UIViewController {

    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        title = "example2"
        
        label = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        label.backgroundColor = UIColor.redColor()
        label.text = "我是占位图"
        
        setup()
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }

    func setup() {
        let sampleVC1:UIViewController = UIViewController()
        sampleVC1.title = "sampleVC1"
        sampleVC1.view.backgroundColor = UIColor.blueColor()
        
        let sampleVC2:UIViewController = UIViewController()
        sampleVC2.title = "sampleVC2"
        
        
        let contaninerVC = TNContainerViewController.init(controllers: [sampleVC1,sampleVC2], topBarHeight: 200, parentViewController: self)
        contaninerVC.menuItemFont = UIFont.systemFontOfSize(16)
        contaninerVC.menuBackGroudColor = UIColor.whiteColor()
        contaninerVC.menuWidth = self.view.frame.width * 0.5 - 10.0
        contaninerVC.indicatorHeight = 1.0
        contaninerVC.menuViewHeight = 80
        contaninerVC.delegate = self
        contaninerVC.menuIndicatorColor = UIColor.blueColor()
        contaninerVC.menuItemTitleColor = UIColor.blackColor()
        contaninerVC.menuItemSelectedTitleColor = UIColor.blueColor()
        self.view.addSubview(contaninerVC.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Example2ControllerView : TNContainerViewControllerDelegate{
    func containerViewItem(index: NSInteger, currentController: UIViewController) {
        currentController.viewWillAppear(true)
    }
}
