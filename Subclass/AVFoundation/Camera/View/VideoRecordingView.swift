//
//  VideoRecodingView.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/11/18.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit

class VideoRecodingView: UIView {

    var progress = 0.0
    
    var radius = 5.0
    
    var lineWidth = 1.5
    
    var cycleColor: UIColor = .red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawRact(rect: CGRect) {
        let contex = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: radius, y: radius)
        let radius = radius - lineWidth / 2.0 * progress
        let startA = .pi / 2.0
        let endA = .pi / 2.0 + .pi * 2
//
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
        contex?.setLineWidth(lineWidth)
        contex?.setStrokeColor(cycleColor.cgColor)
        contex?.setLineCap(.round)
        contex?.addPath(path.cgPath)
        
        contex?.strokePath()//渲染
        
    }
    
}
