//
//  LPTranstionInteractive.swift
//  aaaa
//
//  Created by 路鹏 on 2019/1/7.
//  Copyright © 2019 路鹏. All rights reserved.
//

import UIKit
public let AppWidth: CGFloat = UIScreen.main.bounds.size.width
public let AppHeight: CGFloat = UIScreen.main.bounds.size.height
class LPTranstionInteractive: NSObject,UIViewControllerInteractiveTransitioning,UIGestureRecognizerDelegate {
    weak var dismissVC:UIViewController!;
    var dismissView:UIView!;
    var transitionContext:UIViewControllerContextTransitioning!;
    var isGesture = false//是否响应手势
    public var beginFrame:CGRect!//从外部传入
    var beginCenter:CGPoint!
    let duration = 0.3;//动画时间
    var scrollArr:[UIScrollView]! = [];//用来处理手势冲突
    var bgView:UIView!;//底部遮罩
    lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:  #selector(self.handlePan(gesture:)))
    
    override init() {
        super.init()
        let bgView = UIView();
        bgView.backgroundColor = UIColor.black;
        bgView.frame = CGRect.init(x: 0, y: 0, width: AppWidth, height: AppHeight);
        self.bgView = bgView;
    }
    
    //MARK: - 系统返回present使用的动画
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext;
        
        let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!;
        let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!;
        let containView = transitionContext.containerView
        let toView: UIView
        let fromView: UIView
        if transitionContext.responds(to:NSSelectorFromString("viewForKey:")) {
            // 通过这种方法获取到view不一定是对应controller.view
            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        } else { // Apple文档中提到不要直接使用这种方法来获取fromView和toView
            toView = toVc.view
            fromView = fromVc.view
        }
        containView.addSubview(toView);
        let isPresenting = toVc.presentingViewController == fromVc
        if isPresenting {
            self.dismissVC = toVc;
            self.dismissView = toView;
            
            self.setGesture(forView: containView);
            
            toView.center = CGPoint.init(x: self.beginFrame.origin.x+self.beginFrame.size.width/2, y: self.beginFrame.origin.y+self.beginFrame.size.height/2);
            toView.bounds = CGRect.init(x: 0, y: 0, width: AppWidth, height: AppHeight);
            toView.transform = CGAffineTransform.init(scaleX: self.beginFrame.size.width/AppWidth, y: self.beginFrame.size.height/AppHeight);
        } else {
            containView.insertSubview(toView, belowSubview: fromView)
            self.bgView.alpha = 1;
            toView.addSubview(self.bgView)
        }
        
        if self.isGesture {
            return;
        }
        self.isGesture = false;
        
        UIView.animate(withDuration: duration, animations: {
            if isPresenting {
                toView.transform = CGAffineTransform.init(scaleX: 1, y: 1);
                toView.center = CGPoint.init(x: AppWidth/2, y: AppHeight/2);
            } else {
                self.bgView.alpha = 0;
                fromView.transform = CGAffineTransform.init(scaleX: self.beginFrame.size.width/AppWidth, y: self.beginFrame.size.height/AppHeight);
                fromView.center = CGPoint.init(x: self.beginFrame.origin.x+self.beginFrame.size.width/2, y: self.beginFrame.origin.y+self.beginFrame.size.height/2);
            }
        }) { (_) in
            self.bgView.removeFromSuperview();
            transitionContext.finishInteractiveTransition();
            transitionContext.completeTransition(true);
            self.transitionContext = nil;
        }
    }
    
    //MARK: - 添加手势
    func setGesture(forView:UIView) {
        self.panGesture.delegate = self;
        forView.addGestureRecognizer(self.panGesture)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.scrollArr = [];
        return true;
    }
    
    //MARK: - 处理手势冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            if let scroll = otherGestureRecognizer.view as? UIScrollView {
                if (scroll.contentOffset.x <= 0 || scroll.contentOffset.y <= 0) {
                    self.scrollArr.append(scroll);
                    return true;
                }
            }
        }
        return false;
    }
    
    //MARK: - 手势返回使用的动画
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let location = gesture.location(in: gesture.view);
        let velocity = gesture.velocity(in: gesture.view);
        
        if (gesture.state == .began) {
            self.isGesture = false;
            if (velocity.x > 0 || velocity.y > 0) {
                var isScrollX = true;
                var isScrollY = true;
                for scroll in self.scrollArr {
                    if scroll.contentOffset.x > 0 {
                        isScrollX = false;
                    }
                    if scroll.contentOffset.y > 0 {
                        isScrollY = false;
                    }
                }
                
                let velocityH = abs(velocity.x) > abs(velocity.y) ? velocity.x : velocity.y;
                if (velocityH > 0) {
                    if (isScrollX && velocity.x == velocityH) {
                        self.isGesture = true;
                    }
                    if (isScrollY && velocity.y == velocityH) {
                        self.isGesture = true;
                    }
                    if (isScrollX && isScrollY) {
                        self.isGesture = true;
                    }
                }
                
                if self.isGesture {
                    for scroll in self.scrollArr {
                        scroll.panGestureRecognizer.isEnabled = false;
                    }
                    self.dismissVC.dismiss(animated: true, completion: nil);
                    
                    self.setAnchorPoint(anchorPoint: CGPoint.init(x: location.x/AppWidth, y: location.y/AppHeight), forView: self.dismissView);
                    self.beginCenter = self.dismissView.center;
                }
            }
        }
        if (self.isGesture == false) {
            return;
        }
        
        let yPercent = abs(translation.y / AppHeight)
        let xPercent = abs(translation.x / AppWidth)
        var percent = xPercent;
        if (xPercent > yPercent) {
            percent = xPercent;
        }else{
            percent = yPercent;
        }
        percent = 1-percent;
        if (percent < self.beginFrame.size.width/AppWidth) {
            percent = self.beginFrame.size.width/AppWidth;
        }
        if (percent < self.beginFrame.size.height/AppHeight) {
            percent = self.beginFrame.size.height/AppHeight;
        }
        
        var maxPercent = self.beginFrame.size.width/AppWidth;
        if (self.beginFrame.size.width/AppWidth < self.beginFrame.size.height/AppHeight) {
            maxPercent = self.beginFrame.size.height/AppHeight
        }
        if (gesture.state == .changed) {
            self.bgView.alpha = (percent-maxPercent)/(1-maxPercent);
            self.dismissView.transform = CGAffineTransform.init(scaleX: percent, y: percent);
            self.dismissView.center = CGPoint.init(x: self.beginCenter.x+translation.x, y: self.beginCenter.y+translation.y)
        }
        
        if (gesture.state == .cancelled || gesture.state == .ended) {
            self.isGesture = false;
            self.finishBy(isDisMiss: percent < 0.85)
            for scroll in self.scrollArr {
                scroll.panGestureRecognizer.isEnabled = true;
            }
        }
    }
    
    func setAnchorPoint(anchorPoint:CGPoint, forView:UIView) {
        let oldOrigin = forView.frame.origin;
        forView.layer.anchorPoint = anchorPoint;
        let newOrigin = forView.frame.origin;

        let transition = CGPoint.init(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y);
        forView.center = CGPoint.init(x: self.dismissView.center.x - transition.x, y: self.dismissView.center.y - transition.y)
    }
    
    func finishBy(isDisMiss:Bool) {
        self.setAnchorPoint(anchorPoint: CGPoint.init(x: 0.5, y: 0.5), forView: self.dismissView)
        UIView.animate(withDuration: duration, animations: {
            if isDisMiss {
                self.bgView.alpha = 0;
                self.dismissView.transform = CGAffineTransform.init(scaleX: self.beginFrame.size.width/AppWidth, y: self.beginFrame.size.height/AppHeight);
                self.dismissView.center = CGPoint.init(x: self.beginFrame.origin.x+self.beginFrame.size.width/2, y: self.beginFrame.origin.y+self.beginFrame.size.height/2);
            } else {
                self.bgView.alpha = 1;
                self.dismissView.transform = CGAffineTransform.init(scaleX: 1, y: 1);
                self.dismissView.center = CGPoint.init(x: AppWidth/2, y: AppHeight/2);
            }
        }) { (_) in
            if isDisMiss {
                self.bgView.removeFromSuperview();
                self.transitionContext.finishInteractiveTransition();
                self.transitionContext.completeTransition(true)
                self.transitionContext = nil;
            }else{
                self.transitionContext.cancelInteractiveTransition();
                self.transitionContext.completeTransition(false);
            }
        }
    }
    
}
