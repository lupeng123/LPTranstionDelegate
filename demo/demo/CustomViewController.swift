//
//  CustomViewController.swift
//  aaaa
//
//  Created by 路鹏 on 2019/2/18.
//  Copyright © 2019 路鹏. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow;
        
        let img = UIImageView();
        img.image = UIImage.init(named: "1");
        self.view.addSubview(img);
        img.frame = CGRect.init(x: 0, y: 0, width: AppWidth, height: AppHeight);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
