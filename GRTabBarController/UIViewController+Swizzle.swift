//
//  UIViewController+Swizzle.swift
//  GRTabBarController
//
//  Created by iOS_Dev5 on 2017/2/10.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

extension UIViewController {
    private struct AssociatedKeys {
        static var DescroptiveName = "cutScreenImageView"
    }
    var tabBarImageView: UIImageView? {
        get {
            let tabBarImageV = objc_getAssociatedObject(self, &AssociatedKeys.DescroptiveName)
            
            return tabBarImageV as! UIImageView?
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.DescroptiveName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    open override class func initialize() {
        if self != UIViewController.self {
            return
        }
        
        
        let swizzlingClosure: () = {
            UIViewController().methodSwizzled(originalSelector: #selector(UIViewController.viewDidAppear(_:)), to: #selector(UIViewController.customviewDidAppear(animated:)))
            UIViewController().methodSwizzled(originalSelector: #selector(UIViewController.viewWillDisappear(_:)), to: #selector(UIViewController.customviewWillDisappear(animated:)))
            UIViewController().methodSwizzled(originalSelector: #selector(UIViewController.viewWillAppear(_:)), to: #selector(UIViewController.customviewWillAppear(animated:)))
            UIViewController().methodSwizzled(originalSelector: #selector(UIViewController.viewDidLoad), to: #selector(UIViewController.customviewDidLoad))
            
            
        }()
        swizzlingClosure
    }
    @objc private func customviewDidLoad() {
        
        let viewControllerName = NSStringFromClass(type(of: self)) as NSString
        if viewControllerName.range(of: "_RootViewController").location != NSNotFound {
            
        }
        self.customviewDidLoad()
    }
    
    
    
    @objc private func customviewWillAppear(animated: Bool) {
        
        if let childVCs = self.navigationController?.childViewControllers {
            if childVCs.count > 1 {
                self.gr_tabBarController?.tabBarHidden = true
            }
        }
        
        self.customviewWillAppear(animated: animated)
    }
    
    @objc private func customviewDidAppear(animated: Bool) {
        
        let barButtonItem = UIBarButtonItem.init(customView: UIView())
        self.navigationItem.backBarButtonItem = barButtonItem
        barButtonItem.title = ""
        
        let viewControllerName = NSStringFromClass(type(of: self)) as NSString
        if viewControllerName.range(of: "_RootViewController").location != NSNotFound {
            let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentNavigationVC = (kAppDelegate.window!.rootViewController as! RootTabViewController).selectedViewController as! UINavigationController
            if currentNavigationVC == self.navigationController {
                self.tabBarImageView?.isHidden = true
                self.gr_tabBarController?.tabBarHidden = false
            }
            
        }
        if let childVCs = self.navigationController?.childViewControllers {
            if childVCs.count > 1 {
                self.gr_tabBarController?.tabBarHidden = true
            }
        }
        self.customviewDidAppear(animated: animated)
    }

    
    @objc private func customviewWillDisappear(animated: Bool) {
        
        let viewControllerName = NSStringFromClass(type(of: self)) as NSString
        if viewControllerName.range(of: "_RootViewController").location != NSNotFound {
            if self.tabBarImageView == nil {
                self.tabBarImageView = UIImageView()
                self.tabBarImageView?.isHidden = true
                self.tabBarImageView?.backgroundColor = .red
                self.tabBarImageView?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
                self.tabBarImageView?.frame = CGRect(x: 0, y: self.view.frame.size.height-self.gr_tabBarController!.tabBar.tabbarHeight, width: self.view.frame.size.width, height: self.gr_tabBarController!.tabBar.tabbarHeight)
                if self.view.subviews.contains(self.tabBarImageView!) == false {
                    self.view.addSubview(self.tabBarImageView!)
                }
            }
            if self.tabBarImageView!.isHidden {
                self.tabBarImageView?.isHidden = false
                self.cutScreen()
            }
        }
        
        self.customviewWillDisappear(animated: animated)
        
    }
    
    
    private func methodSwizzled(originalSelector: Selector, to swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        let flag = class_addMethod(UIViewController.self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if flag {
            class_replaceMethod(UIViewController.self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    private func cutScreen() {

        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.gr_tabBarController!.tabBar.frame.size.width, height: self.gr_tabBarController!.tabBar.frame.size.height), true, 0.0)
        self.gr_tabBarController?.tabBar.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.tabBarImageView?.image = image
        
    }

}
