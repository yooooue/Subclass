//
//  DetailViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/1/11.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController  {

    @objc var cellColor:UIColor = UIColor.black
    
    @objc var ration = 1.0
    
    lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.black
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        view.addSubview(self.contentView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController : NavAnimationDelegate {
    func didFinishTransition() {
        self.contentView.backgroundColor = self.cellColor
        self.contentView.frame = CGRect(x: 0, y: NAVBAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_WIDTH*ration)
    }
}

