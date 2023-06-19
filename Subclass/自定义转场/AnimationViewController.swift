//
//  AnimationViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/1/10.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit

class AnimationViewController: UINavigationController {

    weak var animationDelegate : NavAnimationDelegate?

    var isPush = false
    var origionRect : CGRect = CGRect.zero
    var desRect : CGRect = CGRect.zero
    var cellColor = UIColor.black
    @objc func pustTest() {
        print("跳转啊~~~~")
    }
    
    @objc func pushViewController(viewController: UIViewController, imageView: UIView, origionRect: CGRect, desRect: CGRect, delegate: NavAnimationDelegate) {
        self.delegate = self
        self.isPush = true
        self.animationDelegate = delegate
        self.origionRect = origionRect
        self.desRect = desRect
        self.cellColor = imageView.backgroundColor ?? .black
        super.pushViewController(viewController, animated: true)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.isPush = false
        return super.popViewController(animated: animated)
    }
}

extension AnimationViewController : UINavigationControllerDelegate {
    //转场代理 创建返回自定义的转场对象  动画对象是任何遵守UIViewControllerAnimatedTransitioning协议的对象
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = NavAnimation()
        animation.delegate = self.animationDelegate
        animation.isPush = self.isPush
        animation.origionRect = self.origionRect
        animation.desRect = self.desRect
        animation.cellColor = self.cellColor
        if self.isPush == false, (self.delegate != nil) {
            self.delegate = nil
        }
        return animation
    }
}
