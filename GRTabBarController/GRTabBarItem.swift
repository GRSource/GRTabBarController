//
//  GRTabBarItem.swift
//  GRTabBarController
//
//  Created by iOS_Dev5 on 2017/2/9.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class GRTabBarItem: UIControl {

    /**
     * itemHeight is an optional property. When set it is used instead of tabBar's height.
     */
    var itemHeight: CGFloat = 0
    
    //MARK: - Title configuration
    
    /**
     * The title displayed by the tab bar item.
     */
    var title: String?
    
    /**
     * The offset for the rectangle around the tab bar item's title.
     */
    var titlePositionAdjustment: UIOffset = .zero
    
    /**
     * The offset for the rectangle around the tab bar item's image.
     */
    var imagePositionAdjustment: UIOffset = .zero
    
    /**
     * The title attributes dictionary used for tab bar item's unselected state.
     */
    var unselectedTitleAttributes: [String: Any]!
    
    /**
     * The title attributes dictionary used for tab bar item's selected state.
     */
    var selectedTitleAttributes: [String: Any]!
    
    
    /**
     * The selected image of the item
     */
    private var selectedImage: UIImage?
    
    /**
     * The unselected image of the item
     */
    private var unselectedImage: UIImage?
    
    /**
     * The selected background image of the item
     */
    private var selectedBackgroundImage: UIImage?
    
    /**
     * The unselected background image of the item
     */
    private var unselectedBackgroundImage: UIImage?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInitialization() {
        self.backgroundColor = .clear
        
        unselectedTitleAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                                     NSForegroundColorAttributeName: UIColor.black]
        selectedTitleAttributes = unselectedTitleAttributes
        
    }
    
    //MARK: - Image configuration
    
    /**
     * The image used for tab bar item's selected state.
     */
    func finishedSelectedImage() -> UIImage? {
        return self.selectedImage
    }
    
    /**
     * The image used for tab bar item's unselected state.
     */
    func finishedUnselectedImage() -> UIImage? {
        return self.unselectedImage
    }
    
    
    /**
     * Sets the tab bar item's selected and unselected images.
     */
    func setFinishedSelectedImage(_ selectedImage: UIImage, withFinishedUnselectedImage unselectedImage: UIImage) {
        if selectedImage != self.selectedImage {
            self.selectedImage = selectedImage
        }
        
        if unselectedImage != self.unselectedImage {
            self.unselectedImage = unselectedImage
        }
    }
    
    //MARK: - Background configuration
    
    /**
     * The background image used for tab bar item's selected state.
     */
    func backgroundSelectedImage() -> UIImage? {
        return self.selectedBackgroundImage
    }
    
    /**
     * The background image used for tab bar item's unselected state.
     */
    func backgroundUnselectedImage() -> UIImage? {
        return self.unselectedBackgroundImage
    }
    
    /**
     * Sets the tab bar item's selected and unselected background images.
     */
    func setBackgroundSelectedImage(_ selectedImage: UIImage, withUnselectedImage unselectedImage: UIImage) {
        if selectedImage != self.selectedBackgroundImage {
            self.selectedBackgroundImage = selectedImage
        }
        if unselectedImage != self.unselectedBackgroundImage {
            self.unselectedBackgroundImage = unselectedImage
        }
    }

    override func draw(_ rect: CGRect) {
        if self.selectedImage == nil && self.unselectedImage == nil {
            return
        }
        let frameSize = self.frame.size
        var imageSize = CGSize.zero
        var titleSize = CGSize.zero
        var titleAttributes: [String: Any]?
        var imageStartingY: CGFloat = 0.0
        var image: UIImage?
        var backgroundImage: UIImage?
        
        if self.isSelected {
            image = self.selectedImage
            backgroundImage = self.selectedBackgroundImage
            titleAttributes = self.selectedTitleAttributes
        }else {
            image = self.unselectedImage
            backgroundImage = self.unselectedBackgroundImage
            titleAttributes = self.unselectedTitleAttributes
        }
        
        imageSize = image!.size
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        backgroundImage?.draw(in: self.bounds)
        
        if title == nil {
            image?.draw(in: CGRect(x: CGFloat(roundf(Float(frameSize.width / 2 - imageSize.width / 2))) + imagePositionAdjustment.horizontal, y: CGFloat(roundf(Float(frameSize.height / 2 - imageSize.height / 2))) + imagePositionAdjustment.vertical, width: imageSize.width, height: imageSize.height))
        }else {
            titleSize = ((title! as NSString).boundingRect(with: CGSize(width: frameSize.width, height: 20), options: .usesLineFragmentOrigin, attributes: titleAttributes, context: nil)).size
            imageStartingY = CGFloat(roundf(Float(frameSize.height - imageSize.height - titleSize.height) / 2))
            image?.draw(in: CGRect(x: CGFloat(roundf(Float(frameSize.width / 2 - imageSize.width / 2))) + imagePositionAdjustment.horizontal, y: imageStartingY + imagePositionAdjustment.vertical, width: imageSize.width, height: imageSize.height))
            context?.setFillColor((titleAttributes![NSForegroundColorAttributeName] as! UIColor).cgColor)
            (title! as NSString).draw(in: CGRect(x: CGFloat(roundf(Float(frameSize.width / 2 - titleSize.width / 2))) + titlePositionAdjustment.horizontal, y: imageStartingY + imageSize.height + titlePositionAdjustment.vertical, width: titleSize.width, height: titleSize.height), withAttributes: titleAttributes)
        }
        context?.restoreGState()
    }
}
