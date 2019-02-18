//
//  ViewController.swift
//  demo
//
//  Created by 路鹏 on 2019/2/18.
//  Copyright © 2019 路鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var custonTanstionDelegate:LPTranstionDelegate!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.custonTanstionDelegate = LPTranstionDelegate();
        
        let btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 150));
        btn.setBackgroundImage(UIImage.init(named: "1"), for: .normal);
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside);
        self.view.addSubview(btn);
    }
    
    @objc func btnClick(sender:UIButton) {
        self.custonTanstionDelegate.beginFrame = CGRect.init(x: 100, y: 100, width: 100, height: 150);
        
        let vc = CustomViewController();
        vc.transitioningDelegate = self.custonTanstionDelegate;
        self.present(vc, animated: true, completion: nil);
        
    }


}

