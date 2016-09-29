//
//  ViewController.swift
//  ContainerViewController
//
//  Created by JiangTeng on 07/05/2016.
//  Copyright (c) 2016 JiangTeng. All rights reserved.
//

import UIKit
import ContainerViewController

class Example1ControllerView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "example1"

        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "right-arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.tapExample2))
        navigationItem.rightBarButtonItem = rightButton;

        
        setup()
    }
    
    func tapExample2() {
        navigationController?.pushViewController(Example2ControllerView(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        let playListVC:UIViewController = UIViewController()
        playListVC.title = "playListVC"
        playListVC.view.backgroundColor = UIColor.red
        
        let artistVC:UIViewController = UIViewController()
        artistVC.title = "artistVC"
        
        let sampleVC1:UIViewController = UIViewController()
        sampleVC1.title = "sampleVC1"
        sampleVC1.view.backgroundColor = UIColor.blue
        
        let sampleVC2:UIViewController = UIViewController()
        sampleVC2.title = "sampleVC2"
        
        let sampleVC3:UIViewController = UIViewController()
        sampleVC3.title = "sampleVC3"
        sampleVC3.view.backgroundColor = UIColor.red
        
        let sampleVC4:UIViewController = UIViewController()
        sampleVC4.title = "sampleVC4"
        
        let sampleVC5:UIViewController = UIViewController()
        sampleVC5.title = "sampleVC5"
        sampleVC5.view.backgroundColor = UIColor.gray
        
        // ContainerView
        let statusHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        let navigationHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
        
        let contaninerVC = TNContainerViewController.init(controllers: [playListVC,artistVC,sampleVC1,sampleVC2,sampleVC3,sampleVC4,sampleVC5], topBarHeight: statusHeight + navigationHeight, parentViewController: self)
        contaninerVC.menuItemFont = UIFont.systemFont(ofSize: 16)
        contaninerVC.menuBackGroudColor = UIColor.white
        contaninerVC.menuWidth = 100
        contaninerVC.delegate = self
        contaninerVC.menuIndicatorColor = UIColor.blue
        contaninerVC.menuItemTitleColor = UIColor.black
        contaninerVC.menuItemSelectedTitleColor = UIColor.blue
        self.view.addSubview(contaninerVC.view)
    }
}

extension Example1ControllerView : TNContainerViewControllerDelegate{
    func containerViewItem(_ index: NSInteger, currentController: UIViewController) {
        currentController.viewWillAppear(true)
    }
}


