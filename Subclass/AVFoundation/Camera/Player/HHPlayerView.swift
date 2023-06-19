//
//  HHPlayerView.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/8/29.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import AVFoundation

class HHPlayerView: UIView {
    
    var overLayView = HHOverLayView()
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        backgroundColor = .black
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        if let layer = layer as? AVPlayerLayer {
            layer.player = player
        }
        player.rate
        //interv:通知周期间隔的CMTime值   queue:通知发送的线程，一般是主线程
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 2), queue: DispatchQueue.main) { time in
            //在指定时间间隔中将会在队列上调用的回调模块。传递一个CMTime值用于指示播放器的当前时间
        }
        
//        player.addBoundaryTimeObserver(forTimes: <#T##[NSValue]#>, queue: <#T##DispatchQueue?#>, using: <#T##() -> Void#>)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overLayView.frame = self.bounds
    }
}
