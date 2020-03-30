## CyclePageView

![](https://img.shields.io/cocoapods/v/CyclePageView.svg?style=flat) ![](https://img.shields.io/badge/language-swift-orange.svg)

封装无限循环轮播图，swift语言实现。类似的UICollectionview的Api，由代理提供数据源及响应事件处理。一样的配方，熟悉的味道。

## 安装方式

### CocoaPods

```ruby
pod 'CyclePageView'
```

### Swift Package Manager

```swift
.package(url: "https://github.com/qiangjindong/CyclePageView.git", .upToNextMajor(from: "0.0.3"))
```

## 用法

**创建好cyclePageView放在合适的位置，并设置好属性。**


```swift
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
```

**为cyclePageView设置好数据源**

```SWIFT
extension ViewController: CyclePageViewDataSource {
    func numberOfItems(in cyclePageView: CyclePageView) -> Int {
        return imageNames.count
    }

    func cyclePageView(_ cyclePageView: CyclePageView, 
                       cellForItemAtIndex index: Int) -> CyclePageViewCell {
        let cell = cyclePageView.dequeueReusableCell(withReuseIdentifier: cellId, forIndex: index)
        cell.backgroundImageView.image = UIImage(named: imageNames[index])
        cell.textLabel.text = "\(index)"
        return cell
    }
}
```

**点击的代理，可选**

```swift
extension ViewController: CyclePageViewDelegate {
    func cyclePageView(_ cyclePageView: CyclePageView, didSelectItemAtIndex index: Int) {
        print(index)
    }
}
```

