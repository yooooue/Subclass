//
//  EditVideoViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/8/15.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@available(iOS 13.0, *)
class EditVideoViewController: UIViewController {

    @objc var videoArr : [NSURL] = []
    var composition: AVComposition?
    
    var player : AVPlayer?
    
    var playerLayer : AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        composition = createVideoComposite()
        setupPlayer()
        
        let btnW = (SCREEN_WIDTH-20*4)/3
        let compositeBtn = UIButton(frame: CGRect(x: 20, y: SCREEN_HEIGHT-100, width: btnW, height: 30))
        compositeBtn.setTitle("合成视频", for: .normal)
        compositeBtn.addTarget(self, action: #selector(didClickVideoCompositeBtn), for: .touchUpInside)
        compositeBtn.backgroundColor = .black
        view.addSubview(compositeBtn)
        
        let playVideoBtn = UIButton(frame: CGRect(x: 20*2+btnW, y: SCREEN_HEIGHT-100, width: btnW, height: 30))
        playVideoBtn.setTitle("播放视频", for: .normal)
        playVideoBtn.addTarget(self, action: #selector(clickPlayVideoBtn), for: .touchUpInside)
        playVideoBtn.backgroundColor = .black
        view.addSubview(playVideoBtn)
        
        let saveVideoBtn = UIButton(frame: CGRect(x: 20*3+btnW*2, y: SCREEN_HEIGHT-100, width: btnW, height: 30))
        saveVideoBtn.setTitle("保存视频", for: .normal)
        saveVideoBtn.addTarget(self, action: #selector(didClickSaveVideoBtn), for: .touchUpInside)
        saveVideoBtn.backgroundColor = .black
        view.addSubview(saveVideoBtn)
        
        let switch1 = UISwitch()
        switch1.addTarget(self, action: #selector(videoFadeOut(_:)), for: .valueChanged)
        view.addSubview(switch1)
        switch1.mas_makeConstraints { make in
            make?.centerX.mas_equalTo()(compositeBtn.mas_centerX)
            make?.bottom.mas_equalTo()(compositeBtn.mas_top)?.offset()(-20)
            make?.width.height().mas_equalTo()(30)
        }
        
        let label1 = UILabel()
        label1.text = "视频淡出"
        view.addSubview(label1)
        label1.mas_makeConstraints { make in
            make?.centerX.mas_equalTo()(compositeBtn.mas_centerX)
            make?.bottom.mas_equalTo()(switch1.mas_top)?.offset()(-20)
            make?.height.mas_equalTo()(30)
        }
        
        let switch2 = UISwitch()
        switch2.addTarget(self, action: #selector(audioFadeOut(_:)), for: .valueChanged)
        view.addSubview(switch2)
        switch2.mas_makeConstraints { make in
            make?.centerX.mas_equalTo()(playVideoBtn.mas_centerX)
            make?.bottom.mas_equalTo()(playVideoBtn.mas_top)?.offset()(-20)
            make?.width.height().mas_equalTo()(30)
        }
        
        let label2 = UILabel()
        label2.text = "音频淡出"
        view.addSubview(label2)
        label2.mas_makeConstraints { make in
            make?.centerX.mas_equalTo()(playVideoBtn.mas_centerX)
            make?.bottom.mas_equalTo()(switch2.mas_top)?.offset()(-20)
            make?.height.mas_equalTo()(30)
        }
    }
    
    @objc func audioFadeOut(_ sender: UISwitch) {
        if let composition = composition {
            let audioMax = AVMutableAudioMix()
            let parameters = audioMax.inputParameters.first as? AVMutableAudioMixInputParameters
            let timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
            if sender.isOn {
                parameters?.setVolumeRamp(fromStartVolume: 1, toEndVolume: 0, timeRange: timeRange)
            }else {
                parameters?.setVolumeRamp(fromStartVolume: 1, toEndVolume: 1, timeRange: timeRange)
            }
            replay()
        }
    }
    
    @objc func videoFadeOut(_ sender: UISwitch) {
        if let composition = composition {
            let videoComposition =  AVMutableVideoComposition.init(propertiesOf: composition)
            let compositionInstructon = videoComposition.instructions.first as? AVMutableVideoCompositionInstruction
            let compositionLayerInstruction = compositionInstructon?.layerInstructions.first as? AVMutableVideoCompositionLayerInstruction
            let timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
            if sender.isOn {
                compositionLayerInstruction?.setOpacityRamp(fromStartOpacity: 1, toEndOpacity: 0, timeRange: timeRange)
            }else {
                compositionLayerInstruction?.setOpacityRamp(fromStartOpacity: 1, toEndOpacity: 1, timeRange: timeRange)

            }
            replay()
        }
    }
    
    @objc func clickPlayVideoBtn() {
        setupPlayer()
    }
    
    func setupPlayer() {
        if let composition = composition {
            let playerItem = AVPlayerItem(asset: composition)
            player = AVPlayer.init(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.backgroundColor = .init(gray: 1, alpha: 0)
            playerLayer?.frame = CGRect(x: 0, y: NAVBAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
//            playerLayer.videoGravity = .resizeAspectFill
            playerLayer?.player?.play()
            view.layer.addSublayer(playerLayer!)
            
        }
        
        let _ = NSValue(time: .zero)
    }

    func replay() {
        if let composition = composition {
            let playerItem = AVPlayerItem(asset: composition)
            player?.replaceCurrentItem(with: playerItem)
            playerLayer?.player?.seek(to: .zero)
            playerLayer?.player?.play()
        }
    }
    
    @objc func didClickVideoCompositeBtn() {
        composition = createVideoComposite()
    }
    
    @objc func didClickSaveVideoBtn() {
        if let composition = composition {
            outputVideo(composition as! AVMutableComposition)
        }
    }
    
    func createVideoComposite() -> AVMutableComposition {
        
        let composition = AVMutableComposition(urlAssetInitializationOptions: nil)

        var startTime = CMTime.zero
        
        //创建一个视频轨道
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //创建一个音频轨道
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        for url in videoArr {
            
        
            let asset = AVAsset(url: url as URL)
            
            //视频时长
            let videoDuration = asset.duration
            
//            let videoDuration = CMTimeMake(value: 5, timescale: 1)
            let time = CMTimeGetSeconds(videoDuration)
            print("视频时长",time)
            
            //截取视频的时间区域
            let videoTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoDuration)
             

            let assetVideoTrack = asset.tracks(withMediaType: .video).first!
            
            do {
                try videoTrack?.insertTimeRange(videoTimeRange, of: assetVideoTrack, at: startTime)
            }catch {
                print("拼接失败")
            }
            let assetAudioTrack = asset.tracks(withMediaType: .audio).first!

            try! audioTrack?.insertTimeRange(videoTimeRange, of: assetAudioTrack, at: startTime)
//
            startTime = CMTimeAdd(startTime, videoDuration)

            
        }
//        print("合成完毕")
        let videoDuration = composition.duration
        
        
//        let videoTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoDuration)

//        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")
        
//        let audioAsset = AVURLAsset.init(url: url!)
        
//        let assetAudioTrack = audioAsset.tracks(withMediaType: .audio).first!
//
//        try? audioTrack?.insertTimeRange(videoTimeRange, of: assetAudioTrack, at: CMTime.zero)
        
        let time = CMTimeGetSeconds(videoDuration)
        print("合并后视频时长",time)

        return composition
    }
    
    func outputVideo(_ composition: AVMutableComposition) {
        
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! + getCurrentTime() + ".mp4"
        
        let exporterSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporterSession?.outputFileType = AVFileType.mov
        exporterSession?.outputURL = NSURL(fileURLWithPath:filePath) as URL
        exporterSession?.shouldOptimizeForNetworkUse = true
        exporterSession?.exportAsynchronously(completionHandler: { () -> Void in
            switch exporterSession!.status {
            case .unknown:
                print("unknon")
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed")
            case .waiting:
                print("waiting")
            case .exporting:
                print("exporting")
            case .completed:
                self.saveVideo(filePath)
                print("completed")
            @unknown default:
                print("0000000")
            }
        })
        
    }
    
    func saveVideo(_ filePath: String) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
        } completionHandler: { success, error in
            if success {
                print("保存成功")
            }else {
                print("保存失败")
            }
        }

    }
    
    func getCurrentTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd-HH-mm-ss-SSS"
        df.locale = Locale.init(identifier: "en_US_POSIX")
        let date = df.string(from: Date())
        return date
    }
}
