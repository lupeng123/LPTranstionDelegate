//
//  LPTranstionDelegate.swift
//  aaaa
//
//  Created by 路鹏 on 2019/1/7.
//  Copyright © 2019 路鹏. All rights reserved.
//

import UIKit

class LPTranstionDelegate: NSObject,UIViewControllerTransitioningDelegate {
    var beginFrame:CGRect! = CGRect.init(x: AppWidth/2-50, y: AppHeight/2-50, width: 100, height: 100) {
        didSet{
            self.interactive?.beginFrame = beginFrame;
        }
    }
    var interactive:LPTranstionInteractive?;
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return LPTranstionAnimation();
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LPTranstionAnimation();
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return  interactive
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive
    }
    
    override init() {
        super.init();
        self.interactive = LPTranstionInteractive();
        self.interactive?.beginFrame = self.beginFrame;
    }
}
