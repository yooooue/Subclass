//
//  HHCameraController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/9/2.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol HHCAmeraControllerDelegate: NSObjectProtocol {
    func finishTakePhoto(image: UIImage)
}

protocol HHFaceDetectionDelegate: NSObjectProtocol {
    func didDetectionFaces(faces: [AVMetadataObject])
}

protocol HHCodeDetecetionDelegate: NSObjectProtocol {
    func didDetectCodes(codes: [AVMetadataObject])
}

class HHCameraController: NSObject {

    weak var delegate : HHCAmeraControllerDelegate?
    
    weak var faceDetectionDelegate: HHFaceDetectionDelegate?
    
    weak var codeDetectionDelegate: HHCodeDetecetionDelegate?
    
    var observerContext = "HHCameraAdjustingExposureContext"
    
    var scale: CameraScale = .CameraScale4x3
    
    var cameraType: CameraType = .CameraTypePhoto
    
    var videoPath : URL?
    
    var photoPath : URL?

    var photoImage : UIImage?
    
    var photoData : Data?
    
    //捕捉会话  执行输入设备和输出设备之间的数据传递
    var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        return captureSession
    }()
    
    //捕获设备输入
    var activeVideoInput: AVCaptureDeviceInput?
    
   
    //捕获照片输出
    var imageOutput: AVCapturePhotoOutput = {
        let imageOutput = AVCapturePhotoOutput()
        imageOutput.isHighResolutionCaptureEnabled = true
        imageOutput.isLivePhotoCaptureEnabled = imageOutput.isLivePhotoCaptureSupported

        imageOutput.isLivePhotoCaptureSuspended = false
        return imageOutput
    }()
    
    var movieOutput: AVCaptureMovieFileOutput = {
        let movieOutput = AVCaptureMovieFileOutput()
        return movieOutput
    }()
    
    var metadateOutput: AVCaptureMetadataOutput = {
        let metadataOutput = AVCaptureMetadataOutput()
        return metadataOutput
    }()
    
    func setupSession() -> Bool {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return false }
//        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return false }//默认打开前置
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: videoDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
                activeVideoInput = videoInput
            }
        }catch {
            return false
        }
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {return false}
        do {
            let audioInput = try AVCaptureDeviceInput.init(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
        }catch {
            
        }
                
        if captureSession.canAddOutput(imageOutput) {
            captureSession.addOutput(imageOutput)
        }
        
//        if captureSession.canAddOutput(movieOutput) {
//            captureSession.addOutput(movieOutput)
//        }
        
        
        //条码扫描
//        if videoDevice.isAutoFocusRangeRestrictionSupported {
//            do {
//                try videoDevice.lockForConfiguration()
//                videoDevice.autoFocusRangeRestriction = .near
//                videoDevice.unlockForConfiguration()
//            }catch {
//
//            }
//        }
        if captureSession.canAddOutput(metadateOutput) {
            captureSession.addOutput(metadateOutput)
            let types = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.upce]
            metadateOutput.metadataObjectTypes = types
            metadateOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        }
        
        
        //人脸识别
//        if captureSession.canAddOutput(metadateOutput) {
//            captureSession.addOutput(metadateOutput)
//            metadateOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
//            metadateOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        }
        return true
    }
    
    //启动捕捉绘画
    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global().async { [self] in
                captureSession.startRunning()
            }
        }
    }
    
    //停止捕捉会话
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global().async { [self] in
                captureSession.stopRunning()
            }
        }
    }
    
    //设备
    func activeCamera() -> AVCaptureDevice? {
        return activeVideoInput?.device ?? nil
    }
    
    //获取没激活的视频设备
    func inactiveCamera() -> AVCaptureDevice? {
        var device: AVCaptureDevice?
        if self.cameraCount()>1 {
            if self.activeCamera()?.position == .back {
                device = camera(position: .front) ?? nil
            }else {
                device = camera(position: .back) ?? nil
            }
        }
        return device
    }
    
    //返回可用的视频设备
    func camera(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceSession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
        let devices = deviceSession.devices
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
        
    }
    
    //可用视频捕捉设备数量
    func cameraCount() -> NSInteger {
        let deviceSession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)//unspecified 任何位置的设备
        return deviceSession.devices.count
    }
    
    //是否有超过一个的摄像头可用
    func canSwitchCameras() -> Bool {
        return self.cameraCount() > 1
    }
    
    //切换镜头
    func switchCameras() -> Bool {
        if !self.canSwitchCameras() {
            return false
        }
        guard let videoDevice = self.inactiveCamera() else {return false}//获取没激活的设备
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: videoDevice)
            captureSession.beginConfiguration()
            captureSession.removeInput(activeVideoInput!)//移除当前激活的AVCaptureDeviceInput
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
                activeVideoInput = videoInput
            }else {
                captureSession.addInput(activeVideoInput!)
            }
        }catch {
            return false
        }
        captureSession.commitConfiguration()//
        
        return true
    }

    //点击对焦
    func focusAtPoint(point: CGPoint) {
        guard let device = activeCamera() else {return}
        if device.isFocusPointOfInterestSupported , device.isFocusModeSupported(.autoFocus) {
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = point
                device.focusMode = .autoFocus
                device.unlockForConfiguration()
            }catch {
                
            }
        }
    }
    
    //点击曝光
    func exposeAtPoint(point: CGPoint) {
        guard let device = activeCamera() else { return }
        //询问设备是否支持对一个兴趣点进行曝光
        if device.isExposurePointOfInterestSupported, device.isExposureModeSupported(.autoExpose) {
            do {
                try device.lockForConfiguration()
                device.exposurePointOfInterest = point
                device.exposureMode = .autoExpose
                if device.isExposureModeSupported(.locked) {//是否支持锁定曝光模式
                    device.addObserver(self, forKeyPath: "adjustingExposure", options: NSKeyValueObservingOptions.new, context: &observerContext)
                }
                device.unlockForConfiguration()
            }catch {
                
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &observerContext {
            guard let device = object as? AVCaptureDevice else {return}
            if !device.isAdjustingExposure, device.isExposureModeSupported(.locked) {
                device.removeObserver(self, forKeyPath: "adjustingExposure", context: &observerContext)
                DispatchQueue.main.async {
                    do {
                        try device.lockForConfiguration()
                        device.exposureMode = .locked
                        device.unlockForConfiguration()
                    }catch {
                        
                    }
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    //重置曝光和聚焦
    func resetFocusAndExposureModes() {
        guard let device = activeCamera() else { return }
        let exposureMode = .autoExpose as AVCaptureDevice.ExposureMode
        let focusMode = AVCaptureDevice.FocusMode.autoFocus
        let canResetFocus = device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode)
        let canResetExposure = device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode)
        
        let centerPoint = CGPoint(x: 0.5, y: 0.5)
        
        do {
            try device.lockForConfiguration()
            if canResetFocus {
                device.focusMode = focusMode
                device.focusPointOfInterest = centerPoint
            }
            if canResetExposure {
                device.exposureMode = exposureMode
                device.exposurePointOfInterest = centerPoint
            }
            device.unlockForConfiguration()
        }catch {
            
        }
    }
    
    
    func cameraSupportsZoom() -> Bool {
        guard let device = activeCamera() else {return false}
        return device.activeFormat.videoMaxZoomFactor > 1.0 //大于1.0 支持缩放功能
    }
    
    func maxZoomValue() -> CGFloat {
        guard let device = activeCamera() else {return 1.0}
        return min(device.activeFormat.videoMaxZoomFactor, 5.0)
    }
    
    func setZoomVale(zoomValue: CGFloat) {
        guard let device = activeCamera() else {return}
        if !device.isRampingVideoZoom {
            do {
                try device.lockForConfiguration()
                let zoomFactor = pow(maxZoomValue(), zoomValue)
                device.videoZoomFactor = zoomFactor
                device.unlockForConfiguration()
            }catch {
                
            }
        }
    }
    
    func rampZoomToValue(zoomValue: CGFloat) {
        guard let device = activeCamera() else {return}
        let zoomFactor = pow(maxZoomValue(), zoomValue)//次方函数
        do {
            try device.lockForConfiguration()
            device.ramp(toVideoZoomFactor: zoomFactor, withRate: 2.0)//这个方法的效果是每秒增加缩放因子一倍，这个值通常在1-3之间可以提供一个比较舒服的缩放效果
            device.unlockForConfiguration()
        }catch {
            
        }
        let currentZoomValue = log(device.videoZoomFactor)/log(maxZoomValue())
        print(currentZoomValue)
    }
    
    func cancelZoom() {
        guard let device = activeCamera() else {return}
        do {
            try device.lockForConfiguration()
            device.cancelVideoZoomRamp()
            device.unlockForConfiguration()
        }catch {
            
        }
    }
    
    //闪光灯
    func setFlashMode(flash: AVCaptureDevice.FlashMode) {
        guard let device = activeCamera() else { return }
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        if settings.flashMode != flash {
            do {
                try device.lockForConfiguration()
                settings.flashMode = flash
                device.unlockForConfiguration()
//                imageOutput.capturePhoto(with: settings, delegate: self)
            }catch {
                
            }
        }
    }
    
    //手电筒
    func setTorchMode(torch: AVCaptureDevice.TorchMode) {
        guard let device = activeCamera() else { return }
        if device.isTorchModeSupported(torch) {
            do {
                try device.lockForConfiguration()
                device.torchMode = torch
                device.unlockForConfiguration()
            }catch {
                
            }
        }
    }
    
    //捕捉静态图片
    func capturePhoto() {
        //必须使用唯一的AVCapturePhotoSettings对象
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        settings.uniqueID
    
        imageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func getUUID() -> String {
        let uuid = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuid) as String
        let string = uuidString.replacingOccurrences(of: "-", with: "")
        return string
    }
    
    
    //关于拍摄livephoto
    /*
     isLivePhotoCaptureSupported 判断当前是否支持动态照片拍摄
     会话启动前必须设置isLivePhotoCaptureEnabled=true
     在拍摄前AVCapturePhotoSetting的重点配置属性livePhotoMovieFileURL 不能为nil  这里涉及到一个问题创建URL下面两个方法的区别
     URL(fileURLWithPath: ) 创建出来的URL会自动加上协议头file://
     URL(string: ) 创建的URL,与原有的字符串一模一样
     那么当我们需要根据一个字符串创建URL的时候,如果这个字符串包含协议头,那么使用URLWithString,一般用于网络资源的URL创建;
     如果访问的是本地资源,而且不包含协议头,使用fileURLWithPath创建URL;当然可以用URLWithString拼接一个协议头来实现,不过这….耿直如你;
     另外在使用fileURLWithPath创建URL时,不用担心URL中混有中文的问题,系统会自动实现转换;
     因此如果在访问本地资源的时候,不要犹豫,fileURLWithPath是你的首选.不过要注意去掉字符串中的协议头;
     */
    func captureLivePhoto() {
        //必须使用唯一的AVCapturePhotoSettings对象
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isHighResolutionPhotoEnabled = true
        let livePhotoMovieFilePath = NSTemporaryDirectory().appending(getUUID()+".MOV")
        settings.livePhotoMovieFileURL = URL(fileURLWithPath: livePhotoMovieFilePath)
        
        imageOutput.isLivePhotoCaptureEnabled = true
        imageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation : AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
            break
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
            break
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
            break
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
            break
        }
        return orientation
    }
    
    func startRecording() {
        if !isRecording() {
            guard let connection = movieOutput.connection(with: .video) else {return}
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = currentVideoOrientation()
            }
            if connection.isVideoStabilizationSupported {
                connection.preferredVideoStabilizationMode = .auto
            }
            
            guard let device = activeCamera() else { return }
            if device.isSmoothAutoFocusSupported {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                }catch {
                    return
                }
            }
//            let filePath = ""
            let url = uniquelURL()
            movieOutput.startRecording(to: url, recordingDelegate: self)
        }
        
        
    }
    
    func stopRecording() {
        if self.isRecording() {
            movieOutput.stopRecording()
        }
    }
    
    func isRecording() -> Bool {
        return movieOutput.isRecording
    }
    
    func uniquelURL() -> URL {
        let path = FileManager.default.temporaryDirectory
        let filePath = path.appendingPathComponent("movie.mov")
        return filePath
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
    
    func saveImage(_ image: UIImage) {
        delegate?.finishTakePhoto(image: image)
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            if success {
                print("保存成功")
            }else {
                print("保存失败")
            }
        }

    }
    
    func saveLivePhoto(_ image: Data, _ video : URL) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges {
            let req = PHAssetCreationRequest.forAsset()
            let resourceOptions = PHAssetResourceCreationOptions()
            resourceOptions.shouldMoveFile = true
            req.addResource(with: .photo, data: image, options: resourceOptions)
//            req.addResource(with: .photo, fileURL: image, options: nil)
            req.addResource(with: .pairedVideo, fileURL: video, options: resourceOptions)
        } completionHandler: { [self] success, error in
            videoPath = nil
            photoData = nil
            if success {
                print("save success")
            }else {
                print("save error:%@", error as Any)
            }
        }
    }
}

extension HHCameraController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            
        }else {
            print("无法返回图片  %@", error as Any)
            return
        }
    }
    
    //拍摄静态照片
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if (error == nil) {
            guard let data = photo.fileDataRepresentation() else { return }
//            let image = UIImage.init(data: data)



            if var image = UIImage.init(data: data) {
                image = fixOrientation(image: image)
                var subImage = imageCropFrameWithImage(scale: scale, image: image)

                if activeVideoInput?.device.position == .front {//前置镜头 照片镜像
                    subImage = UIImage(cgImage: subImage.cgImage!, scale: image.scale, orientation: .upMirrored)
                }
                photoImage = subImage
            }
        }
    }
    
    func fixOrientation(image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        var transform: CGAffineTransform = CGAffineTransformIdentity
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height)
            transform = CGAffineTransformRotate(transform, .pi)
            break
        case .left, .leftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0)
            transform = CGAffineTransformRotate(transform, .pi/2)
            break
        case .right, .rightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height)
            transform = CGAffineTransformRotate(transform, -.pi/2)
            break
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        default:
            break
        }
        
        guard let context = CGContext.init(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else { return image }
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
            break
        default:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            break
        }
        guard let cgImg = context.makeImage() else { return image }
        let img = UIImage(cgImage: cgImg)
        return img
    }
    
    func imageCropFrameWithImage(scale: CameraScale, image: UIImage) -> UIImage {
        let imageSize = image.size
        var renderSize = imageSize
        var frame = CGRect(origin: .zero, size: renderSize)
        switch scale {
        case .CameraScale4x3:
            renderSize = imageSize
            frame = CGRect(origin: .zero, size: renderSize)
            break
        case .CameraScale1x1:
            renderSize = CGSize(width: imageSize.width, height: imageSize.width)
            frame = CGRect(origin: CGPoint(x: 0, y: (imageSize.height-imageSize.width) / 2.0), size: renderSize)
            break
        case .CameraScale16x9:
            let width = imageSize.height * 9 / 16.0
            renderSize = CGSize(width: width, height: imageSize.height)
            frame = CGRect(origin: CGPoint(x: (imageSize.width-width) / 2.0, y: 0), size: renderSize)
            break
        }
        UIGraphicsBeginImageContextWithOptions(renderSize, true, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return image }
        let subImageRef = image.cgImage?.cropping(to: frame)
        context.draw(subImageRef!, in: frame)
        let subImg = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()        
        return subImg
    }
    
    //拍摄live照片
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if (error == nil) {
            videoPath = outputFileURL
        }
    }
    //拍摄 必须实现上述方法中的一个 否则会崩溃
    
    //每次调用拍摄 照片输出始终调用下面四个方法各一次
    //拍摄输出已解析设置，将很快开始拍摄过程
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    //即将拍摄照片
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    //已拍摄照片
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    //拍摄照片完成
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if output.isLivePhotoCaptureEnabled {
            if let photoData = photoData, let videoPath = videoPath {
                saveLivePhoto(photoData, videoPath)
            }
        }else {
            if let photoImage = photoImage {
                saveImage(photoImage)
            }
        }
    }
    
    
    
}

extension HHCameraController: AVCaptureFileOutputRecordingDelegate {

    //捕捉到视频
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            
        }else {
            writeVideoToAssetsLibrary(videoURL: outputFileURL)
        }
    }
    
    func writeVideoToAssetsLibrary(videoURL: URL) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        } completionHandler: { success, error in
            if success {
                print("保存成功")
            }else {
                print("保存失败")
            }
        }
    }
    
    
}

extension HHCameraController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //人脸
//        for face in metadataObjects {
//            if let face = face as? AVMetadataFaceObject {
//                print("face ID: %i---face bounds: %@", face.faceID, face.bounds)
//            }
//        }
//        faceDetectionDelegate?.didDetectionFaces(faces: metadataObjects)
        
        //条码
//        codeDetectionDelegate?.didDetectCodes(codes: metadataObjects)
    }
    
    
}
