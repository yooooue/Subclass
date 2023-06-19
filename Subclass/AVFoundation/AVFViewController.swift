//
//  AVFViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/8/25.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

@objc(AVFViewController)
class AVFViewController: UIViewController {

    var asset: AVAsset?
    var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
//        Bundle.main.loadNibNamed("", owner: self, options: nil)
//        mp3()
//        airplay()
        let btn = UIButton(frame: CGRectMake(50, 100, 100, 50))
        btn.backgroundColor = .black
        btn.setTitle("相机", for: .normal)
        btn.addTarget(self, action: #selector(cameraBtnClick), for: .touchUpInside)
        view.addSubview(btn)
        
        let btn2 = UIButton(frame: CGRectMake(250, 100, 100, 50))
        btn2.backgroundColor = .black
        btn2.setTitle("相册", for: .normal)
        btn2.addTarget(self, action: #selector(cameraBtnClick), for: .touchUpInside)
        view.addSubview(btn2)
    }
    
    @objc func cameraBtnClick() {
        navigationController?.pushViewController(CameraViewController(), animated: true)
    }
    
    func albumBtnClick() {
        
    }
    
    func mp3() {
        let url = Bundle.main.url(forResource: "cc", withExtension: "MP4")
        let asset = AVURLAsset(url: url!)
        self.asset = asset
//        let f = asset.availableMetadataFormats
//        let metadata = asset.metadata(forFormat: .unknown)
//        for item in metadata {
//            print("%@: %@", item.key!, item.value!)
//        }
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer.init(playerItem: item)
        self.player = player
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspect
//        view.layer.addSublayer(playerLayer)
//        playerLayer.player?.play()
        
//        mediaCharacteristics()
        playerVC()
    }
    
    func mp3Asset() {
        let url = Bundle.main.url(forResource: "aa", withExtension: "mp3")
        let asset = AVURLAsset(url: url!)
        let keys = ["availableMetadataFormats"]
        asset.loadValuesAsynchronously(forKeys: keys) {
            var metadata = Array<AVMetadataItem>()
            for  format in asset.availableMetadataFormats {
                metadata.append(contentsOf:(asset.metadata(forFormat: format)))
            }
            
            let keySpace = AVMetadataKeySpace.iTunes
            let artistKey = AVMetadataKey.iTunesMetadataKeyArtist
            let albumKey = AVMetadataKey.iTunesMetadataKeyAlbum
            let artistMetadata = AVMetadataItem.metadataItems(from: metadata, withKey: artistKey, keySpace: keySpace)
            let albumMetadata = AVMetadataItem.metadataItems(from: metadata, withKey: albumKey, keySpace: keySpace)
            var artistItem: AVMetadataItem?
            var albumItem: AVMetadataItem?
            if artistMetadata.count>0 {
                artistItem = artistMetadata[0]
            }
            if albumMetadata.count>0 {
                albumItem = albumMetadata[0]
            }
        }
        
        
    }
    
//  显示字幕
    func mediaCharacteristics() {
        if let asset = asset {
            let mediaCharacteristics = asset.availableMediaCharacteristicsWithMediaSelectionOptions
            for characteristic in mediaCharacteristics {
                print(characteristic)
                let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic)
                if let group = group {
                    for option in group.options {
                        print("option:",option.displayName)
                    }
                }
            }
        }
        
    }
    
    func airplay() {
        let volumeView = MPVolumeView()
        volumeView.backgroundColor = .black
//        volumeView.showsVolumeSlider = false
//        volumeView.sizeToFit()
        volumeView.frame = CGRect(x: 0, y: 500, width: SCREEN_WIDTH, height: 100)
        view.addSubview(volumeView)
    }
    
    func playerVC() {
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true, completion: nil)
        player?.play()
    }
}
