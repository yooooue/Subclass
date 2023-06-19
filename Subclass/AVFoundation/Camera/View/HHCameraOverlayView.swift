//
//  HHCameraOverlayView.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/9/23.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit

protocol HHCameraOverlayViewDelegate {
    func change()
    func cameraBtnClick()
    func focusAtPoint(point: CGPoint)
    func zoomValue(zoomValue: CGFloat)
    func scaleVale(scaleVale: CGFloat, scaleType: CameraScale)
    func cameraType(type: CameraType)
    func livephoto(isLive: Bool)
}

enum CameraScale: Int {
    case CameraScale4x3 = 0
    case CameraScale1x1 = 1
    case CameraScale16x9 = 2
}

class HHCameraOverlayView: UIView {

    var delegate : HHCameraOverlayViewDelegate?
    
    var currentImg : UIImage? {
        didSet {
            photoImage.image = currentImg
        }
    }
    var scale = 4 / 3.0
    
    var cameraScale: CameraScale = CameraScale.CameraScale4x3
    
    var isLivePhoto = true
    
    lazy var livePhotoBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("实况", for: .normal)
        btn.addTarget(self, action: #selector(clickLivePhotoBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("旋转", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(clickChangeBtn), for: .touchUpInside)
        return button
    }()

    lazy var cameraButton: UIButton = {
        let cameraBtn = UIButton(type: .custom)
        cameraBtn.backgroundColor = .white
        cameraBtn.layer.cornerRadius = 25
        cameraBtn.addTarget(self, action: #selector(clickCameraBtn), for: .touchUpInside)
        return cameraBtn
    }()
    
    lazy var typeView: SelectTypeView = {
        let typeView = SelectTypeView()
        typeView.delegate = self
        return typeView
    }()
    
    lazy var photoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var focusView: UIView = {
        let focusView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 120, height: 120)))
        focusView.layer.borderColor = UIColor(hexStr:"#F5D229").cgColor
        focusView.layer.borderWidth = 1
        focusView.layer.cornerRadius = 4
        focusView.layer.masksToBounds = true
        focusView.backgroundColor = .clear
        focusView.isHidden = true
        return focusView
    }()
    
    lazy var zoomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "1.0x"
        return label
    }()
    
    lazy var zoomSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1.0
        slider.minimumValue = 0.0
        slider.addTarget(self, action: #selector(changeSliderValue(slider:)), for: .valueChanged)
        return slider
    }()
    
    lazy var scaleBtn: UIButton = {
        let scaleBtn = UIButton()
        scaleBtn.setTitle("4:3", for: .normal)
        scaleBtn.addTarget(self, action: #selector(clickScaleBtn(btn:)), for: .touchUpInside)
        return scaleBtn
    }()
    
    lazy var videoRecordingView: VideoRecodingView = {
        let view = VideoRecodingView()
        view.cycleColor = UIColor(hexStr: "#ff4a83")
        view.radius = 50 / 2
        view.progress = 1.0
        view.lineWidth = 3
        view.setNeedsDisplay()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        
        
        addSubview(cameraButton)
        cameraButton.mas_makeConstraints { make in
            make?.width.height().mas_equalTo()(50)
            make?.centerX.mas_equalTo()(self.mas_centerX)
            make?.bottom.mas_equalTo()(-80)
        }
        
        addSubview(changeBtn)
        changeBtn.mas_makeConstraints { make in
            make?.right.mas_equalTo()(-20)
            make?.width.mas_equalTo()(100)
            make?.height.mas_equalTo()(50)
            make?.centerY.mas_equalTo()(cameraButton.mas_centerY)
        }
        
        addSubview(photoImage)
        photoImage.mas_makeConstraints { make in
            make?.width.height().mas_equalTo()(50)
            make?.centerY.mas_equalTo()(cameraButton.mas_centerY)
            make?.left.mas_equalTo()(20)
        }
        
        addSubview(typeView)
        typeView.mas_makeConstraints { make in
            make?.leading.trailing().mas_equalTo()(0)
            make?.height.mas_equalTo()(30)
            make?.bottom.mas_equalTo()(cameraButton.mas_top)?.offset()(-10)
        }
        
        addSubview(zoomLabel)
        zoomLabel.mas_makeConstraints { make in
            make?.height.mas_equalTo()(20)
            make?.bottom.mas_equalTo()(typeView.mas_top)?.offset()(-10)
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        addSubview(focusView)
        
        addSubview(scaleBtn)
        scaleBtn.mas_makeConstraints { make in
            make?.top.mas_equalTo()(NAVBAR_HEIGHT-44)
            make?.width.height().mas_equalTo()(50)
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        addSubview(livePhotoBtn)
        livePhotoBtn.mas_makeConstraints { make in
            make?.top.mas_equalTo()(NAVBAR_HEIGHT-44)
            make?.width.height().mas_equalTo()(50)
            make?.trailing.mas_equalTo()(-10)
        }
        
        //手势 聚焦
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
//        addGestureRecognizer(tap)
        
        //手势 缩放
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(pinch:)))
//        addGestureRecognizer(pinch)
        
        
        addSubview(zoomSlider)
        zoomSlider.mas_makeConstraints { make in
            make?.centerX.mas_equalTo()(self.mas_centerX)
            make?.left.mas_equalTo()(20)
            make?.right.mas_equalTo()(-20)
            make?.top.mas_equalTo()(100)

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickScaleBtn(btn: UIButton) {
        switch cameraScale {
        case .CameraScale4x3:
            cameraScale = .CameraScale1x1
            btn.setTitle("1:1", for: .normal)
            scale = 1.0
        case .CameraScale1x1:
            cameraScale = .CameraScale16x9
            btn.setTitle("16:9", for: .normal)
            scale = 16 / 9.0
        case .CameraScale16x9:
            cameraScale = .CameraScale4x3
            btn.setTitle("4:3", for: .normal)
            scale = 4 / 3.0
        }
        delegate?.scaleVale(scaleVale: scale, scaleType: cameraScale)
    }
    
    @objc func clickLivePhotoBtn(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        btn.setTitle(btn.isSelected ? "静态" : "实况", for: .normal)
        isLivePhoto = !btn.isSelected
        delegate?.livephoto(isLive: isLivePhoto)
    }
    
    @objc func clickChangeBtn() {
        delegate?.change()
    }
    
    @objc func clickCameraBtn() {
        delegate?.cameraBtnClick()
    }
    
    @objc func tap(tap: UITapGestureRecognizer) {
        
        let point = tap.location(in: self)
        focusAnimation(center: point)
        delegate?.focusAtPoint(point: point)
        
    }
    
    @objc func pinch(pinch: UIPinchGestureRecognizer) {
        let scale = pinch.scale
        if scale > 2.0 || scale < 0.0 {
            return
        }
        print("捏合缩放倍数---",scale)

        zoomLabel.text = String(format: "%.01fx", scale)
        delegate?.zoomValue(zoomValue: scale-1)

        
    }
    
    @objc func changeSliderValue(slider: UISlider) {
        let scale = slider.value

        zoomLabel.text = String(format: "%.01fx", scale)
        delegate?.zoomValue(zoomValue: CGFloat(scale))
    }
    
    func focusAnimation(center: CGPoint) {
        focusView.center = center
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) { [self] in
            focusView.isHidden = false
            focusView.layer.setValue(0.67, forKeyPath: "transform.scale")
        } completion: { [self] _ in
            focusView.layer.setValue(1.5, forKeyPath: "transform.scale")
            focusView.isHidden = true
        }
    }
}

extension HHCameraOverlayView: SelectTypeViewDelegate {
    func selectCameraType(type: CameraType) {
        delegate?.cameraType(type: type)
    }    
}

protocol SelectTypeViewDelegate {
    func selectCameraType(type:CameraType)
}

class SelectTypeView: UIView {
    
    let typeArr = ["照片", "视频"]
    
    var selectIndex = 0
    
    var delegate : SelectTypeViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let flowlayout = CustomFlowLayout()
        flowlayout.offset = 0
        flowlayout.minimumLineSpacing = 20
        flowlayout.scrollDirection = .horizontal
        flowlayout.itemSize = CGSize(width: 50, height: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TypeCell.self, forCellWithReuseIdentifier: "typeCellId")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.mas_makeConstraints { make in
            make?.top.bottom().left().right().mas_equalTo()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelectIndex(index: Int) {
        collectionView(collectionView, didSelectItemAt: IndexPath(item: index, section: 0))
        selectIndex = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSelectIndex(index: 0)

    }
}

extension SelectTypeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCellId", for: indexPath) as? TypeCell
        cell?.label.text = typeArr[indexPath.item]
//        cell?.backgroundColor = .black
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let offset = 25.0 + CGFloat(70 * indexPath.item) - SCREEN_WIDTH/2
        collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        selectIndex = indexPath.item
        delegate?.selectCameraType(type: CameraType(rawValue: indexPath.item) ?? .CameraTypePhoto)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var index = 0
        let offset = scrollView.contentOffset.x
        if offset + SCREEN_WIDTH/2 < (20+50) {
            index = 0
        }else {
            index = 1 + Int(offset+SCREEN_WIDTH/2)/(20+50)
        }
        collectionView(collectionView, didSelectItemAt: IndexPath(item: index, section: 0))
    }
    
    
}

class TypeCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.mas_makeConstraints { make in
            make?.top.bottom().left().right().mas_equalTo()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    var offset = 0.0
    
    override func prepare() {
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        let visibleRect = CGRect(origin: proposedContentOffset, size: (collectionView?.frame.size)!)
        
        guard let arr = super.layoutAttributesForElements(in: visibleRect) as [UICollectionViewLayoutAttributes]? else {return .zero}
        
        let centerX = CGRectGetMidX(visibleRect)-offset
        
        var minDelta = 0.0
        
        for attrs in arr {
            if abs(minDelta)>abs(attrs.center.x-centerX) {
                minDelta = attrs.center.x-centerX
            }
        }
        return CGPoint(x: proposedContentOffset.x+minDelta, y: proposedContentOffset.y)
    }
}
