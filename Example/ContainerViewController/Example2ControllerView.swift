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
        self.view.backgroundColor = UIColor.white
        title = "example2"
        
        label = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        label.backgroundColor = UIColor.red
        label.text = "我是占位图"
        
        setup()
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }

    func setup() {
        let sampleVC1:UIViewController = UIViewController()
        sampleVC1.title = "sampleVC1"
        sampleVC1.view.backgroundColor = UIColor.blue
        
        let sampleVC2:UIViewController = UIViewController()
        sampleVC2.title = "sampleVC2"
        
        
        let contaninerVC = TNContainerViewController.init(controllers: [sampleVC1,sampleVC2], topBarHeight: 200, parentViewController: self)
        contaninerVC.menuItemFont = UIFont.systemFont(ofSize: 16)
        contaninerVC.menuBackGroudColor = UIColor.white
        contaninerVC.menuWidth = self.view.frame.width * 0.5 - 10.0
        contaninerVC.indicatorHeight = 1.0
        contaninerVC.menuViewHeight = 80
        contaninerVC.delegate = self
        contaninerVC.menuIndicatorColor = UIColor.blue
        contaninerVC.menuItemTitleColor = UIColor.black
        contaninerVC.menuItemSelectedTitleColor = UIColor.blue
        self.view.addSubview(contaninerVC.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Example2ControllerView : TNContainerViewControllerDelegate{
    func containerViewItem(_ index: NSInteger, currentController: UIViewController) {
        currentController.viewWillAppear(true)
    }
}
