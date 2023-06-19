//
//  NavAnimation.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/1/7.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit

@objc protocol NavAnimationDelegate : NSObjectProtocol {
    func didFinishTransition()
}

class NavAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    weak var delegate : NavAnimationDelegate?
    var isPush : Bool = false
    var cellColor = UIColor.black
    var origionRect : CGRect = CGRect.zero
    var desRect : CGRect = CGRect.zero
    //转场时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.37
    }
    
    //动画细节
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {return}//
//        guard let fromViewController = transitionContext.viewController(forKey: .from) else {return}//
        let containerView = transitionContext.containerView //获取父视图
//        container.addSubview(fromViewController.view)
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
        
        let contentView = UIView()
        contentView.frame = self.isPush ? self.origionRect : self.desRect
        contentView.backgroundColor = self.cellColor
        
        containerView.addSubview(contentView)
        
        
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            toViewController.view.alpha = 1
            contentView.frame = self.isPush ? self.desRect : self.origionRect
        } completion: { finished in
            transitionContext.completeTransition(finished)
            if (((self.delegate?.responds(to: #selector(NavAnimationDelegate.didFinishTransition))) != nil) && self.isPush == true) {
                self.delegate?.didFinishTransition()
            }
            
            contentView.removeFromSuperview()
            if !self.isPush {
                
            }
        }
    }
}
