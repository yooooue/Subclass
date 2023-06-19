//
//  HHPreviewView.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/9/2.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import AVFoundation

class HHPreviewView: UIView {
    
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var faceLayersDic: NSMutableDictionary = {
       let mDic = NSMutableDictionary()
        return mDic
    }()
    
    var overlayLayer: CALayer = {
        let layer = CALayer()
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000
        layer.sublayerTransform = transform
        return layer
    }()
    
    var session: AVCaptureSession? {
        didSet{
            if let layer = layer as? AVCaptureVideoPreviewLayer, let session = session {
                layer.session = session
            
            }
        }
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        previewLayer = layer as? AVCaptureVideoPreviewLayer
        previewLayer?.videoGravity = .resizeAspectFill
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func captureDevicePointForPoint(_ point: CGPoint) -> CGPoint {
        if let layer = layer as? AVCaptureVideoPreviewLayer {
            return layer.captureDevicePointConverted(fromLayerPoint: point)
            //获取屏幕坐标系的CGPoint数据，返回转换得到的设备坐标系CGPoint数据。
        }
        return .zero
    }
    
    func setupView() {
        overlayLayer.frame = bounds
        previewLayer?.addSublayer(overlayLayer)
    }
    
    
}

extension HHPreviewView: HHFaceDetectionDelegate {
    func didDetectionFaces(faces: [AVMetadataObject]) {
        let transfromFaces = transformedFacesFromFaces(faces: faces)
        var lostFaces = faceLayersDic.allKeys
        for face in transfromFaces {
            if let face = face as? AVMetadataFaceObject {
                let faceID = "\(face.faceID)"
                let index = lostFaces.firstIndex(where: { $0 as! String  == faceID})
                if let index = index {
                    lostFaces.remove(at: index)
                }
                var layer = faceLayersDic.object(forKey: faceID) as? CALayer
                if (layer == nil) {
                    layer = makeFaceLayer()
                    self.overlayLayer.addSublayer(layer!)
                    faceLayersDic[faceID] = layer
                }
                layer?.frame = face.bounds
                layer?.transform = CATransform3DIdentity
                
                if face.hasRollAngle {
                    let transform3D = transformForRollAngle(rollAngleInDegress: face.rollAngle)
                    layer?.transform = CATransform3DConcat(layer!.transform, transform3D)
                }
                
                if face.hasYawAngle {
                    let transform3D = transformForYawAngle(yawAngleInDegress: face.yawAngle)
                    layer?.transform = CATransform3DConcat(layer!.transform, transform3D)
                }
            }
        }
        for faceID in lostFaces {
            let layer = faceLayersDic.object(forKey: faceID) as! CALayer
            layer.removeFromSuperlayer()
            faceLayersDic.removeObject(forKey: faceID)
        }
        
    }
    
    func transformForRollAngle(rollAngleInDegress: CGFloat) -> CATransform3D {
        let rollAngleInRadians = rollAngleInDegress * .pi / 180
        return CATransform3DMakeRotation(rollAngleInRadians, 0, 0, 1.0)
    }
    
    func transformForYawAngle(yawAngleInDegress: CGFloat) -> CATransform3D {
        let rollAngleInRadians = yawAngleInDegress * .pi / 180
        let transform = CATransform3DMakeRotation(rollAngleInRadians, 0, -1.0, 0)
        return CATransform3DConcat(transform, orientationTransform())
    }
    
    func orientationTransform() -> CATransform3D {
        var angle = 0.0
        switch UIDevice.current.orientation {
        case .landscapeRight:
            angle = -.pi / 2.0
            break
        case .landscapeLeft:
            angle = .pi / 2.0
            break
        case .portraitUpsideDown:
            angle = .pi
            break
        default:
            angle = 0.0
            break
        }
        return CATransform3DMakeRotation(angle, 0, 0, 1)
    }
    
    func transformedFacesFromFaces(faces: [AVMetadataObject]) -> [AVMetadataObject] {
        var transformedFaces = [AVMetadataObject]()
        for face in faces {
            guard let transformedFace = previewLayer?.transformedMetadataObject(for: face) else { break }
            transformedFaces.append(transformedFace)
        }
        return transformedFaces
    }
    
    func makeFaceLayer() -> CALayer {
        let layer = CALayer()
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(hexStr: "#F5D209").cgColor
        return layer
    }
}

extension HHPreviewView: HHCodeDetecetionDelegate {
    func didDetectCodes(codes: [AVMetadataObject]) {
        let transforemCodes = transformedCodesFromCodes(codes: codes)
        var lostCodes = faceLayersDic.allKeys
        for code in transforemCodes {
            if let code = code as? AVMetadataMachineReadableCodeObject {
                let stringValue = code.stringValue
                if stringValue != nil {
                    let index = lostCodes.firstIndex(where: { $0 as? String  == stringValue})
                    if let index = index {
                        lostCodes.remove(at: index)
                    }
                }else {
                    continue
                }
                
                var layers = faceLayersDic[stringValue!] as? [CAShapeLayer]
                if layers == nil {
                    layers = [makeBoundsLayer(), makeCornersLayer()]
                    faceLayersDic[stringValue!] = layers
                    previewLayer?.addSublayer((layers?[0])!)
                    previewLayer?.addSublayer((layers?[1])!)
                }
                
                let boundsLayer = layers![0]
                boundsLayer.path = bezierPathForBounds(bounds: code.bounds).cgPath
                
                let cornerLayer = layers![1]
                cornerLayer.path = bezierPathForCorners(corners: code.corners).cgPath
                
                print("二维码的值：%@",stringValue ?? "")
            }
        }
        
        for stringValue in lostCodes {
            let layers = faceLayersDic.object(forKey: stringValue) as! [CAShapeLayer]
            for layer in layers {
                layer.removeFromSuperlayer()
            }
            faceLayersDic.removeObject(forKey: stringValue)
        }
    }
    
    func makeBoundsLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor =  UIColor(red: 0.95, green: 0.75, blue: 0.06, alpha: 1).cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 4
        return shapeLayer
    }
    
    func makeCornersLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor =  UIColor(red: 0.172, green: 0.671, blue: 0.428, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor(red: 0.19, green: 0.753, blue: 0.489, alpha: 0.5).cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }
    
    func bezierPathForBounds(bounds: CGRect) -> UIBezierPath {
        return UIBezierPath(rect: bounds)
    }
    
    func bezierPathForCorners(corners: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        for (i, corner) in corners.enumerated() {
            if i == 0 {
                path.move(to: corner)
            }else {
                path.addLine(to: corner)
            }
        }
        return path
    }
    
    func transformedCodesFromCodes(codes: [AVMetadataObject]) -> [AVMetadataObject] {
        var transformCodes = [AVMetadataObject]()
        for code in codes {
            guard let transformCode = previewLayer?.transformedMetadataObject(for: code) else { break }
            transformCodes.append(transformCode)
        }
        return transformCodes
    }
}
