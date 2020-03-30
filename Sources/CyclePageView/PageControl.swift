//
//  PageControl.swift
//  CyclePageView
//
//  Created by QiangJindong on 2019/6/27.
//  Copyright © 2019 QiangJindong. All rights reserved.
//

import UIKit

private let margin: CGFloat = 0

open class PageControl: UIPageControl {
    open var selectedImage: UIImage? {
        set {
            setValue(newValue, forKeyPath: "_currentPageImage")
        }
        get {
            return value(forKeyPath: "_currentPageImage") as? UIImage
        }
    }
    
    open var unselectedImage: UIImage? {
        set {
            setValue(newValue, forKeyPath: "_pageImage")
        }
        get {
            return value(forKeyPath: "_pageImage") as? UIImage
        }
    }
    
    open override var currentPage: Int {
        didSet {
            resetSubviewsFrame()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        resetSubviewsFrame()
    }
    
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    func resetSubviewsFrame() {
        let unselectedImageWidth = (unselectedImage != nil) ? unselectedImage!.size.width : subviews.last?.frame.size.width ?? 0
        let selectedImageWidth = (selectedImage != nil) ? unselectedImage!.size.width : unselectedImageWidth
        let width = CGFloat(numberOfPages - 1) * (unselectedImageWidth + margin) + selectedImageWidth
        
        frame.size.width = width
        frame.size.height = (unselectedImage != nil) ? unselectedImage!.size.height : subviews.last?.frame.size.height ?? 0
        
        switch scrollDirection {
        case .vertical:
            center.x = (superview?.frame.width ?? 0) - frame.width / 2 - 15
            center.y = (superview?.frame.height ?? 0) / 2 - frame.width / 2
        case .horizontal:
            center.x = (superview?.frame.width ?? 0) / 2
            center.y = (superview?.frame.height ?? 0) - 15
        @unknown default:
            fatalError()
        }
        
        for i in 0..<subviews.count {
            let image = subviews[i]
            if i < currentPage {
                image.frame.origin.x = (margin + unselectedImageWidth) * CGFloat(i)
                image.frame.size.width = unselectedImageWidth
            } else if i == currentPage {
                image.frame.origin.x = (margin + unselectedImageWidth) * CGFloat(i)
                image.frame.size.width = selectedImageWidth
            } else {
                image.frame.origin.x = (margin + unselectedImageWidth) * CGFloat(i - 1) + selectedImageWidth + margin
                image.frame.size.width = unselectedImageWidth
            }
        }
    }
}
