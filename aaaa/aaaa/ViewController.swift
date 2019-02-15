//
//  ViewController.swift
//  aaaa
//
//  Created by 路鹏 on 2018/11/9.
//  Copyright © 2018 路鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var customDelegate:LPTranstionDelegate?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customDelegate = LPTranstionDelegate();
        
        let btn = UIButton();
        btn.backgroundColor = UIColor.red;
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 150);
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside);
        btn.setBackgroundImage(UIImage.init(named: "1"), for: .normal);
        self.view.addSubview(btn);
    }
    
    
    @objc func btnClick() {
        
        self.customDelegate?.beginFrame = CGRect.init(x: 100, y: 100, width: 100, height: 150);
        let vc = CustomViewController();
        vc.transitioningDelegate = self.customDelegate;
        
        self.navigationController?.present(vc, animated: true, completion: nil);
    }


}

