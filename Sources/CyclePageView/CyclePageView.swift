//
//  CyclePageView.swift
//  CyclePageView
//
//  Created by QiangJindong on 2019/6/16.
//  Copyright © 2019 QiangJindong. All rights reserved.
//

import UIKit

public protocol CyclePageViewDataSource: NSObjectProtocol {
    func numberOfItems(in cyclePageView: CyclePageView) -> Int
    func cyclePageView(_ cyclePageView: CyclePageView, cellForItemAtIndex index: Int) -> CyclePageViewCell
}

@objc public protocol CyclePageViewDelegate: NSObjectProtocol {
    @objc optional func cyclePageView(_ cyclePageView: CyclePageView, didSelectItemAtIndex index: Int)
}

open class CyclePageView: UIView {
    static var numberOfCycles: Int = 99
    
    open weak var dataSource: CyclePageViewDataSource?
    open weak var delegate: CyclePageViewDelegate?
    
    open var interval: Double = 3
    
    open var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = scrollDirection
            if oldValue == .horizontal, scrollDirection == .vertical {
                pageControl.transform = CGAffineTransform(rotationAngle: .pi / 2)
            } else if oldValue == .vertical, scrollDirection == .horizontal {
                pageControl.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            }
            pageControl.scrollDirection = scrollDirection
        }
    }
    
    open lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    open lazy var pageControl: PageControl = {
        let pageControl = PageControl()
        return pageControl
    }()
    
    open var isShowPageControl: Bool = false {
        didSet {
            pageControl.isHidden = !isShowPageControl
        }
    }
    
    var collectionViewDataSource: CyclePageCollectionViewDataSource!
    
    var timer: Timer?
    
    var itemCount: Int = 0 {
        didSet {}
    }
    
    var currentPageIndex: Int = 0
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionViewDataSource = CyclePageCollectionViewDataSource(owner: self)
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = bounds.size
        collectionView.frame = bounds
//        pageControl.sizeToFit()
//        pageControl.center = center
//        pageControl.frame.size.height = 20
    }
}

#if DEBUG
func DLog(_ items: Any) {
    print(items)
}
#endif

// MARK: - <UICollectionViewDelegate>

extension CyclePageView: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 设置collectionView的flowLayout.scrollDirection 会先调用此方法
        if itemCount <= 0 { return }
        switch scrollDirection {
        case .vertical:
            currentPageIndex = Int(scrollView.contentOffset.y / bounds.height + 0.5)
        case .horizontal:
            currentPageIndex = Int(scrollView.contentOffset.x / bounds.width + 0.5)
        @unknown default:
            fatalError()
        }
        pageControl.currentPage = currentPageIndex % itemCount
    }
    
    // 代码调用滑动, 比如scrollToItem(at:at:animated:)带动画, 结束后会调用此方法, 手动拖拽的滑动不会走此方法
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        resetScrollPosition(atPageIndex: currentPageIndex)
    }
    
    // 用户手动操作才会触发
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    // 用户手动操作才会触发
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    // 用户手动操作才会触发
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var page: Int
        switch scrollDirection {
        case .vertical:
            page = Int(scrollView.contentOffset.y / bounds.height + 0.5)
        case .horizontal:
            page = Int(scrollView.contentOffset.x / bounds.width + 0.5)
        @unknown default:
            fatalError()
        }
        resetScrollPosition(atPageIndex: page)
    }
    
    // 重置collectionView到中间位置
    func resetScrollPosition(atPageIndex page: Int) {
        var position: Int = 0
        if page >= itemCount * CyclePageView.numberOfCycles - 1 {
            // 中间最后一个位置
            position = itemCount * (CyclePageView.numberOfCycles + 1) / 2 - 1
        } else if page <= 0 {
            // 中间最开始位置
            position = itemCount * (CyclePageView.numberOfCycles - 1) / 2
        } else {
            return
        }
        
//        collectionView.scrollToItem(at: .init(item: position, section: 0), at: [], animated: false)
        switch scrollDirection {
        case .vertical:
            collectionView.contentOffset.y = bounds.height * CGFloat(position)
        case .horizontal:
            collectionView.contentOffset.x = bounds.width * CGFloat(position)
        @unknown default:
            fatalError()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cyclePageView?(self, didSelectItemAtIndex: indexPath.item % itemCount)
    }
}

// MARK: - public function

extension CyclePageView {
    open func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    open func dequeueReusableCell(withReuseIdentifier identifier: String, forIndex index: Int) -> CyclePageViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: .init(item: index, section: 0)) as! CyclePageViewCell
    }
}

// MARK: - 定时器

extension CyclePageView {
    func startTimer() {
        if itemCount <= 1 { return }
        timer = Timer(timeInterval: interval, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func nextPage() {
        let nextPage = currentPageIndex + 1
        collectionView.scrollToItem(at: .init(item: nextPage, section: 0), at: [], animated: true)
    }
}
