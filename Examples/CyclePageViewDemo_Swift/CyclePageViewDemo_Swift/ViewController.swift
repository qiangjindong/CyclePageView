//
//  ViewController.swift
//  CyclePageView
//
//  Created by QiangJindong on 2019/6/16.
//  Copyright © 2019 QiangJindong. All rights reserved.
//

import CyclePageView
import UIKit

private let cellId = "ViewController_CyclePageViewCell"

let imageNames = ["img_00", "img_01", "img_02"]

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
// 创建CyclePageView
let cyclePageView = CyclePageView()
// 设置frame
cyclePageView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 300)
// 设置数据源
cyclePageView.dataSource = self
// 设置代理
cyclePageView.delegate = self
// 注册cell
cyclePageView.register(CyclePageViewCell.self, forCellWithReuseIdentifier: cellId)

// 滚动方向
cyclePageView.scrollDirection = .horizontal
// 滚动间隔
cyclePageView.interval = 3.0
// 当前小圆点图片
cyclePageView.pageControl.selectedImage = UIImage(named: "home_banner_select")
// 其他小圆点图片
cyclePageView.pageControl.unselectedImage = UIImage(named: "home_banner_unselect")
// 是否显示pageControl
cyclePageView.isShowPageControl = true

view.addSubview(cyclePageView)
    }
}

extension ViewController: CyclePageViewDataSource {
    func numberOfItems(in cyclePageView: CyclePageView) -> Int {
        return imageNames.count
    }

    func cyclePageView(_ cyclePageView: CyclePageView, cellForItemAtIndex index: Int) -> CyclePageViewCell {
        let cell = cyclePageView.dequeueReusableCell(withReuseIdentifier: cellId, forIndex: index)
        cell.backgroundImageView.image = UIImage(named: imageNames[index])
        cell.textLabel.text = "\(index)"
        return cell
    }
}

extension ViewController: CyclePageViewDelegate {
    func cyclePageView(_ cyclePageView: CyclePageView, didSelectItemAtIndex index: Int) {
        print(index)
    }
}
