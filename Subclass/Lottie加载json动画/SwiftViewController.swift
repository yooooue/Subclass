//
//  SwiftViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2021/7/20.
//  Copyright © 2021 yy. All rights reserved.
//

import UIKit
import Lottie

@objc class SwiftViewController: UIViewController {

    lazy var animatingView: AnimationView = {
        let animatingView = AnimationView.init(name: "data5")
        animatingView.frame = CGRect.init(x: 0, y: 0, width: 400, height: 400)
        animatingView.center = view.center
        animatingView.contentMode = .scaleAspectFill
        animatingView.loopMode = .playOnce
        animatingView.animationSpeed = 1
        animatingView.backgroundColor = .lightGray
        animatingView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(touchPlay)))
        return animatingView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setu""p after loading the view.
        
        view.addSubview(animatingView)
//        animatingView.play()
    }
    
    @objc func touchPlay() {
        animatingView.play()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        animatingView.play()
    }
    
}

