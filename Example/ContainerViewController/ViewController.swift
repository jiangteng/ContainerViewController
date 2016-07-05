//
//  ViewController.swift
//  ContainerViewController
//
//  Created by JiangTeng on 07/05/2016.
//  Copyright (c) 2016 JiangTeng. All rights reserved.
//

import UIKit
import ContainerViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.title = "example"
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        let playListVC:UIViewController = UIViewController()
        playListVC.title = "playListVC"
        playListVC.view.backgroundColor = UIColor.blackColor()
        
        let artistVC:UIViewController = UIViewController()
        artistVC.title = "artistVC"
        
        let sampleVC1:UIViewController = UIViewController()
        sampleVC1.title = "sampleVC1"
        sampleVC1.view.backgroundColor = UIColor.blueColor()
        
        let sampleVC2:UIViewController = UIViewController()
        sampleVC2.title = "sampleVC2"
        
        let sampleVC3:UIViewController = UIViewController()
        sampleVC3.title = "sampleVC3"
        sampleVC3.view.backgroundColor = UIColor.redColor()
        
        let sampleVC4:UIViewController = UIViewController()
        sampleVC4.title = "sampleVC4"
        
        let sampleVC5:UIViewController = UIViewController()
        sampleVC5.title = "sampleVC5"
        sampleVC5.view.backgroundColor = UIColor.grayColor()
        
        // ContainerView
        let statusHeight:CGFloat = UIApplication.sharedApplication().statusBarFrame.height
        let navigationHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
        
        
        let contaninerVC = TNContainerViewController.init(controllers: [playListVC,artistVC,sampleVC1,sampleVC2,sampleVC3,sampleVC4,sampleVC5], topBarHeight: statusHeight + navigationHeight, parentViewController: self)
        contaninerVC.menuItemFont = UIFont.systemFontOfSize(16)
        contaninerVC.delegate = self
        contaninerVC.menuIndicatorColor = UIColor.init(colorLiteralRed: 0.168627, green: 0.168627, blue: 0.168627, alpha: 1.0)
        contaninerVC.menuItemTitleColor = UIColor.init(colorLiteralRed: 0.866667, green: 0.866667, blue: 0.866667, alpha: 1.0)
        contaninerVC.menuItemSelectedTitleColor = UIColor.init(colorLiteralRed: 0.33333, green: 0.33333, blue: 0.33333, alpha: 1.0)
        self.view.addSubview(contaninerVC.view)
    }
}

extension ViewController : TNContainerViewControllerDelegate{
    func containerViewItem(index: NSInteger, currentController: UIViewController) {
        currentController.viewWillAppear(true)
    }
}


