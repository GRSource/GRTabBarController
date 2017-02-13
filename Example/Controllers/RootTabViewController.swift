//
//  RootTabViewController.swift
//  GRTabBarController
//
//  Created by iOS_Dev5 on 2017/2/9.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class RootTabViewController: GRTabBarController, GRTabBarControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewControllers()
        self.customizeTabBarForController()
        self.delegate = self
    }

    //MARK: - Methods
    func setupViewControllers() {
        let firstViewController = GRFirst_RootViewController()
        let firstNavigationController = UINavigationController.init(rootViewController: firstViewController)
        
        let secondViewController = GRSecond_RootViewController()
        let secondNavigationController = UINavigationController.init(rootViewController: secondViewController)
        
        let thirdViewController = GRThird_RootViewController()
        let thirdNavigationController = UINavigationController.init(rootViewController: thirdViewController)
        
        self.viewControllers = [firstNavigationController, secondNavigationController, thirdNavigationController]
        
    }
    
    func customizeTabBarForController() {
        let finishedImage = UIImage(named: "tabbar_selected_background")
        let unfinishedImage = UIImage(named: "tabbar_normal_background")
        let tabBarItemImages = ["first", "second", "third"]
        
        var index = 0
        
        for item in self.tabBar.items {
            item.setBackgroundSelectedImage(finishedImage!, withUnselectedImage: unfinishedImage!)
            let selectedimage = UIImage(named: "\(tabBarItemImages[index])_selected")
            let unselectedimage = UIImage(named: "\(tabBarItemImages[index])_normal")
            item.setFinishedSelectedImage(selectedimage!, withFinishedUnselectedImage: unselectedimage!)
            item.title = tabBarItemImages[index]
            index+=1
        }
    }
    
    //MARK: - RDVTabBarControllerDelegate
    
    func tabBarController(_ tabBarController: GRTabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: GRTabBarController, didSelectViewController viewController: UIViewController) {
        print("select \(viewController.title)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
