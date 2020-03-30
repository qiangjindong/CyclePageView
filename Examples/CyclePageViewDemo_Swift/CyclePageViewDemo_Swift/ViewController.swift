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
        // Do any additional setup after loading the view.
        let cyclePageView = CyclePageView()
        cyclePageView.dataSource = self
        cyclePageView.delegate = self
        cyclePageView.register(CyclePageViewCell.self, forCellWithReuseIdentifier: cellId)
        cyclePageView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 300)
        cyclePageView.backgroundColor = .green
        cyclePageView.scrollDirection = .horizontal
        cyclePageView.interval = 1
        cyclePageView.pageControl.selectedImage = UIImage(named: "home_banner_select")
        cyclePageView.pageControl.unselectedImage = UIImage(named: "home_banner_unselect")
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
