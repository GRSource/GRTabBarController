//
//  GRTabBarController.swift
//  GRTabBarController
//
//  Created by iOS_Dev5 on 2017/2/9.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit


protocol GRTabBarControllerProtocol: NSObjectProtocol {
    
    /**
     * Asks the delegate whether the specified view controller should be made active.
     */
    func tabBarController(_ tabBarController: GRTabBarController, shouldSelectViewController viewController:UIViewController) -> Bool
    /**
     * Tells the delegate that the user selected an item in the tab bar.
     */
    func tabBarController(_ tabBarController: GRTabBarController, didSelectViewController viewController:UIViewController)
    
}

class GRTabBarController: UIViewController, GRTabBarProtocol {

    /**
     * An array of the root view controllers displayed by the tab bar interface.
     */
    var viewControllers: [UIViewController]? {
        
        willSet {
            
            if viewControllers != nil && viewControllers!.count != 0 {
                for viewController in viewControllers! {
                    viewController.willMove(toParentViewController: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParentViewController()
                }
            }
            
            if newValue != nil {
                var tabBarItems = [GRTabBarItem]()
                for viewController in newValue! {
                    let tabBarItem = GRTabBarItem()
                    tabBarItem.title = viewController.title
                    tabBarItems.append(tabBarItem)
                    viewController.gr_setTabBarController(self)
                }
                self.tabBar.items = tabBarItems
            }else {
                if viewControllers != nil {
                    for viewController in viewControllers! {
                        viewController.gr_setTabBarController(nil)
                    }
                }

            }
        }
        
    }
    
    /**
     * The tab bar controller’s delegate object.
     */
    weak var delegate: GRTabBarControllerProtocol?
    
    /**
     * The tab bar view associated with this controller.
     */
    lazy var tabBar: GRTabBar = {
        self.tabBar = GRTabBar()
        self.tabBar.backgroundColor = .clear
        self.tabBar.delegate = self
        self.tabBar.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        return self.tabBar
    }()
    
    /**
     * The content view associated with this view of controller.
     */
    lazy private var contentView: UIView = {
        self.contentView = UIView()
        self.contentView.backgroundColor = .white
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        return self.contentView
    }()
    
    /**
     * The view controller associated with the currently selected tab item.
     */
    var selectedViewController: UIViewController? {
        get {
            return viewControllers?[selectedIndex]
        }
    }
    
    /**
     * The index of the view controller associated with the currently selected tab item. default 0
     */
    var selectedIndex:Int = 0 {
        willSet {
            if selectedViewController != nil {
                selectedViewController!.willMove(toParentViewController: nil)
                selectedViewController!.view.removeFromSuperview()
                selectedViewController?.removeFromParentViewController()
            }
        }
        didSet {
            if viewControllers == nil || selectedIndex >= viewControllers!.count {
                return
            }
            tabBar.selectedItem = tabBar.items[selectedIndex]
            self.addChildViewController(selectedViewController!)
            self.selectedViewController?.view.frame = self.contentView.bounds
            self.contentView.addSubview(selectedViewController!.view)
            self.selectedViewController?.didMove(toParentViewController: self)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    
    /**
     * A Boolean value that determines whether the tab bar is hidden.
     */
    var tabBarHidden: Bool = false {
        didSet {
            let viewSize = self.view.bounds.size
            var tabBarStartingY = viewSize.height
            if !tabBarHidden {
                tabBarStartingY -= self.tabBar.tabbarHeight
            }
            self.tabBar.frame = CGRect(x: 0, y: tabBarStartingY, width: viewSize.width, height: self.tabBar.tabbarHeight)
            self.contentView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        }
    }
    

    /**
     * Changes the visibility of the tab bar.
     */
//    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
//        tabBarHidden = hidden
//        let block:(()->()) = {
////            self.tabBar.frame = CGRect.init(x: 0, y: 568-49, width: 320, height: 49)
//        }
//        
//        let completion:((Bool)->()) = { finished in
//            
//        }
//        
//        if animated {
//            UIView.animate(withDuration: 0.24, animations: block, completion: completion)
//        }else {
//            block()
//            completion(true)
//        }
//    }
    
    //MARK: - GRTabBarProtocol
    func tabBar(_ tabBar: GRTabBar, shouldSelectItemAtIndex index: Int) -> Bool {
        let isShouldSelect = self.delegate?.tabBarController(self, shouldSelectViewController: self.viewControllers![index])
        if isShouldSelect == nil || isShouldSelect! == false {
            return false
        }
        
        if selectedViewController != nil && selectedViewController! == self.viewControllers![index] {
            if self.selectedViewController!.isKind(of: UINavigationController.self) {
                let selectedController = self.selectedViewController as! UINavigationController
                if selectedController.topViewController != selectedController.viewControllers[0] {
                    selectedController.popToRootViewController(animated: true)
                }
            }
            return false
        }
        return true
    }
    
    func tabBar(_ tabBar: GRTabBar, didSelectItemAtIndex index: Int) {
        if index < 0 || index >= self.viewControllers!.count {
            return
        }
        self.selectedIndex = index
        self.delegate?.tabBarController(self, didSelectViewController: self.viewControllers![index])
    }
    
    func indexForViewController(_ viewController: UIViewController) -> Int {
        var searchedController = viewController
        if searchedController.navigationController != nil {
            searchedController = searchedController.navigationController!
        }
        return (self.viewControllers?.index(of: searchedController))!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = selectedIndex
        selectedIndex = index
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.addSubview(tabBar)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension UIViewController {
    
    private struct AssociatedKeys_VC {
        static var DescriptiveName_VC = "gr_tabBarController"
    }
    
    var gr_tabBarController: GRTabBarController? {
        get {
            var tabBarController = objc_getAssociatedObject(self, &AssociatedKeys_VC.DescriptiveName_VC)
            if tabBarController == nil && self.parent != nil {
                tabBarController = self.parent?.gr_tabBarController
            }
            return tabBarController as? GRTabBarController
        }
    }
    
    
    func gr_setTabBarController(_ tabBarController: GRTabBarController?) {
        objc_setAssociatedObject(self, &AssociatedKeys_VC.DescriptiveName_VC, tabBarController, .OBJC_ASSOCIATION_ASSIGN)
    }

    var gr_tabBarItem: GRTabBarItem? {
        get {
            let tabBarController = self.gr_tabBarController
            let index = tabBarController?.indexForViewController(self)
            return tabBarController?.tabBar.items?[index!]
        }
        set {
            let tabBarController = self.gr_tabBarController
            if tabBarController == nil {
                return
            }
            
            let tabBar = tabBarController?.tabBar
            let index = tabBarController?.indexForViewController(self)
            
            let tabBarItems = NSMutableArray.init(array: (tabBar?.items)!)
            tabBarItems.replaceObject(at: index!, with: tabBarItem)
        }
    }
}

