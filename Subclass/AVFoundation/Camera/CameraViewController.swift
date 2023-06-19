//
//  CameraViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/9/2.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraType: Int {
    case CameraTypePhoto = 0
    case CameraTypeVideo = 1
}

class CameraViewController: UIViewController {

    lazy var cameraController = HHCameraController()
    
    lazy var previewView = HHPreviewView(frame: .zero)
    
    lazy var overlayView = HHCameraOverlayView(frame: view.bounds)
    
    var scale: CGFloat = 4 / 3.0
    
    var isLivePhoto = true //拍摄livephoto
    
    var cameraType: CameraType = .CameraTypePhoto {
        didSet {
            
        }
    }
     
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.addSubview(previewView)
        let height = view.frame.width * scale
        previewView.mas_makeConstraints { make in
            make?.width.mas_equalTo()(view.mas_width)
            make?.leading.trailing().mas_equalTo()(0)
            make?.height.mas_equalTo()(height)
            make?.top.mas_equalTo()(NAVBAR_HEIGHT)
        }
        view.addSubview(overlayView)
//        overlayView.frame = view.bounds
        overlayView.delegate = self
        cameraController.delegate = self
//        cameraController.faceDetectionDelegate = previewView
        cameraController.codeDetectionDelegate = previewView

        let se = cameraController.setupSession()
        if se {
            previewView.session = cameraController.captureSession
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraController.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraController.stopSession()
        navigationController?.navigationBar.isHidden = false
    }
    
    func video() {
        let session = AVCaptureSession()
        let videoDevice = AVCaptureDevice.default(for: .video)
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: videoDevice!)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
        }catch{
            
        }
        
        let imageOutput = AVCapturePhotoOutput()
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
        }
        
        
    }
    
}

extension CameraViewController: HHCameraOverlayViewDelegate {
    func zoomValue(zoomValue: CGFloat) {
//        if zoomValue < 1.0 {
//            cameraController.rampZoomToValue(zoomValue: 1.0)
//        }else {
            cameraController.rampZoomToValue(zoomValue: zoomValue)
//            cameraController.setZoomVale(zoomValue: zoomValue)
//        }
        
    }
    
    func focusAtPoint(point: CGPoint) {
        cameraController.focusAtPoint(point: point)
    }
    
    func change() {
        let impactFeedBack = UIImpactFeedbackGenerator(style: .medium)
        impactFeedBack.prepare()
        impactFeedBack.impactOccurred()
        let result = cameraController.switchCameras()
        if result {
            
        }
    }
    
    func cameraBtnClick() {
        let impactFeedBack = UIImpactFeedbackGenerator(style: .medium)
        impactFeedBack.prepare()
        impactFeedBack.impactOccurred()
        switch cameraType {
        case .CameraTypePhoto:
            if isLivePhoto {
                cameraController.captureLivePhoto()
            }else {
                cameraController.capturePhoto()
            }
            break
        case .CameraTypeVideo:
            isRecording = cameraController.isRecording()
            if isRecording {
                cameraController.stopRecording()
            }else {
                cameraController.startRecording()
            }
            break
        }
        
    }
    
    func scaleVale(scaleVale: CGFloat, scaleType: CameraScale) {
        scale = scaleVale
        let height = view.frame.width * scale
        previewView.mas_updateConstraints { make in
            make?.width.mas_equalTo()(view.mas_width)
            make?.leading.trailing().mas_equalTo()(0)
            make?.height.mas_equalTo()(height)
            make?.top.mas_equalTo()(NAVBAR_HEIGHT)
        }
        cameraController.scale = scaleType
    }
    
    func cameraType(type: CameraType) {
        cameraType = type
        switch type {
        case .CameraTypePhoto:
            scaleVale(scaleVale: 4 / 3.0, scaleType: .CameraScale4x3)
            break
        case .CameraTypeVideo:
            scaleVale(scaleVale: 16 / 9.0, scaleType: .CameraScale16x9)
            break
        }
    }
    
    func livephoto(isLive: Bool) {
        isLivePhoto = isLive
    }
}

extension CameraViewController: HHCAmeraControllerDelegate {
    func finishTakePhoto(image: UIImage) {
        overlayView.currentImg = image
    }
}
