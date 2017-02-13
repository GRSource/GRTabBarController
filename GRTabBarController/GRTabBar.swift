//
//  GRTabBar.swift
//  GRTabBarController
//
//  Created by iOS_Dev5 on 2017/2/9.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

protocol GRTabBarProtocol: NSObjectProtocol {
    
    /**
     Asks the delegate if the specified tab bar item should be selected.
     */
    func tabBar(_ tabBar: GRTabBar, shouldSelectItemAtIndex index: Int) -> Bool
    /**
     Tells the delegate that the specified tab bar item is now selected.
     */
    func tabBar(_ tabBar: GRTabBar, didSelectItemAtIndex index: Int)
    
}
class GRTabBar: UIView {

    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    private func commonInitialization() {
        addSubview(backgroundView)
        self.translucent = false
    }
    
    /**
     * The background view of the tab bar
     */
    lazy private var backgroundView: UIView = {
        self.backgroundView = UIView()
        return self.backgroundView
    }()
    
    /**
     * The tab bar’s delegate object.
     */
    weak var delegate: GRTabBarProtocol?
    
    /*
     * Enable or disable tabBar translucency. Default is false.
     */
    var translucent: Bool! {
        didSet {
            let alpha: CGFloat = (translucent == true ? 0.9 : 1.0)
            backgroundView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: alpha)
        }
    }
    
    var tabbarHeight: CGFloat = 49.0
    
    /**
     * The items displayed on the tab bar.
     */
    var items: [GRTabBarItem]! {
        didSet {
            
            for item in items {
                item.removeFromSuperview()
            }
            for item in items {
                item.addTarget(self, action: #selector(tabBarItemWasSelected(_:)), for: .touchDown)
                self.addSubview(item)
            }
        }
    }
    
    /**
     * The currently selected item on the tab bar.
     */
    var selectedItem: GRTabBarItem! {
        willSet {
            if selectedItem == nil || newValue == selectedItem {
                return
            }
            selectedItem.isSelected = false
        }
        didSet {
            selectedItem.isSelected = true
        }
    }
    
    /*
     * contentEdgeInsets can be used to center the items in the middle of the tabBar.
     */
    var contentEdgeInsets: UIEdgeInsets = .zero
    
    /**
     * The width of item
     */
    private var itemWidth: CGFloat = 0
    
    /**
     * Returns the minimum height of tab bar's items.
     */
    func minimumContentHeight() -> CGFloat {
        var minimumTabBarContentHeight = self.frame.size.height
        
        for item in self.items {
            let itemHeight = item.itemHeight
            if itemHeight != 0 && itemHeight < minimumTabBarContentHeight {
                minimumTabBarContentHeight = itemHeight
            }
        }
        return minimumTabBarContentHeight
    }
    
    //MARK: - Item selection
    func tabBarItemWasSelected(_ sender: GRTabBarItem) {
        let index = self.items.index(of: sender)
        let isShouldSelect = self.delegate?.tabBar(self, shouldSelectItemAtIndex: index!)
        if isShouldSelect == nil || isShouldSelect! == false {
            return
        }
        
        self.selectedItem = sender
        self.delegate?.tabBar(self, didSelectItemAtIndex: index!)
    }
    
    override func layoutSubviews() {
        let frameSize = self.frame.size
        let minimumContentHeight = self.minimumContentHeight()
        
        backgroundView.frame = CGRect(x: 0, y: frameSize.height - minimumContentHeight, width: frameSize.width, height: frame.height)
        self.itemWidth = CGFloat(roundf(Float((frameSize.width - contentEdgeInsets.left - contentEdgeInsets.right) / CGFloat(items.count))))
        
        var index = 0
        
        for item in items {
            var itemHeight = item.itemHeight
            if itemHeight == 0 {
                itemHeight = frameSize.height
            }
    
            item.frame = CGRect(x: self.contentEdgeInsets.left + (CGFloat(index) * itemWidth), y: CGFloat(roundf(Float(frameSize.height - itemHeight))) - contentEdgeInsets.top, width: self.itemWidth, height: itemHeight - contentEdgeInsets.bottom)
            item.setNeedsDisplay()
            index+=1
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
