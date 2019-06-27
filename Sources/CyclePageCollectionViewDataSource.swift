//
//  CyclePageCollectionViewDataSource.swift
//  CyclePageView
//
//  Created by QiangJindong on 2019/6/16.
//  Copyright © 2019 QiangJindong. All rights reserved.
//

import UIKit



class CyclePageCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var owner: CyclePageView?
    
    init(owner: CyclePageView) {
        self.owner = owner;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = owner?.dataSource?.numberOfItems(in: owner!)
        owner?.itemCount = count!
        owner?.resetScrollPosition(atPageIndex: 0)
        owner?.pageControl.numberOfPages = count!
        owner?.startTimer()
        return count! > 1 ? count! * CyclePageView.numberOfCycles : count!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = owner?.dataSource?.cyclePageView(owner!, cellForItemAtIndex: indexPath.item % owner!.itemCount)
//        let cell = owner?.dataSource?.cyclePageView(owner!, cellForItemAtIndex: indexPath.item)
//        print("\(indexPath.item % owner!.itemCount)" + " -- \(indexPath.item)")
        return cell!
    }
    

}
