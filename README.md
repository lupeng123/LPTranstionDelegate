# LPTranstionDelegate
控制器转场特效，手动滑动缩放返回

###使用方法
```objc
self.custonTanstionDelegate.beginFrame = CGRect.init(x: 100, y: 100, width: 100, height: 150);
let vc = CustomViewController();
vc.transitioningDelegate = self.custonTanstionDelegate;
self.present(vc, animated: true, completion: nil);
```

![image](https://github.com/lupeng123/LPImgUrlStore/blob/master/1.gif?raw=true)
