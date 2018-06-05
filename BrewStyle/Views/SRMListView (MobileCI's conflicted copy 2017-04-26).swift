//
//  SRMListView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/5/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SRMListView : UIView {
	let swatchView = UIView()
	let swatchEndView = UIView()
	let typeIndicator = TriangleView()
	
	let colorLabel = UILabel()
	let lovibondLabel = UILabel()
	let ebcLabel = UILabel()
	let srmColorView = SRMStatView()
	
	private let gradientLayer = CAGradientLayer()
	
	convenience init() {
		self.init(frame:CGRectZero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		let container = UIView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = UIColor.clearColor()
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true

		/*
		let topColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.5, 1.0]
		container.layer.insertSublayer(gradientLayer, atIndex: 0)
		*/
		
		swatchView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(swatchView)
		swatchView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
		swatchView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
		swatchView.heightAnchor.constraintEqualToAnchor(container.heightAnchor).active = true
		swatchView.widthAnchor.constraintEqualToAnchor(container.heightAnchor).active = true
		
		swatchEndView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(swatchEndView)
		swatchEndView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
		swatchEndView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor).active = true
		swatchEndView.heightAnchor.constraintEqualToAnchor(container.heightAnchor).active = true
		swatchEndView.widthAnchor.constraintEqualToConstant(8).active = true
		
		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(typeIndicator)
		typeIndicator.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(16).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(16).active = true
		
		srmColorView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(srmColorView)
		srmColorView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.medium.margin).active = true
		srmColorView.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: AppMargins.medium.negative).active = true
		srmColorView.centerXAnchor.constraintEqualToAnchor(swatchView.trailingAnchor, constant: 0).active = true
		
		colorLabel.translatesAutoresizingMaskIntoConstraints = false
		colorLabel.textAlignment = .Right
		colorLabel.textColor = AppColor.Black.color
		colorLabel.font = UIFont(name: "Futura-CondensedMedium", size: 16)
		container.addSubview(colorLabel)
		colorLabel.topAnchor.constraintEqualToAnchor(srmColorView.topAnchor, constant: AppMargins.medium.margin).active = true
		colorLabel.leadingAnchor.constraintEqualToAnchor(srmColorView.trailingAnchor, constant: AppMargins.medium.margin).active = true
		
		lovibondLabel.translatesAutoresizingMaskIntoConstraints = false
		lovibondLabel.textAlignment = .Right
		lovibondLabel.textColor = AppColor.DarkGray.color
		lovibondLabel.font = UIFont.systemFontOfSize(11)
		container.addSubview(lovibondLabel)
		lovibondLabel.topAnchor.constraintEqualToAnchor(colorLabel.bottomAnchor, constant: AppMargins.small.margin).active = true
		lovibondLabel.leadingAnchor.constraintEqualToAnchor(srmColorView.trailingAnchor, constant:  AppMargins.medium.margin).active = true

		ebcLabel.translatesAutoresizingMaskIntoConstraints = false
		ebcLabel.textAlignment = .Right
		ebcLabel.textColor = AppColor.DarkGray.color
		ebcLabel.font = UIFont.systemFontOfSize(11)
		container.addSubview(ebcLabel)
		ebcLabel.topAnchor.constraintEqualToAnchor(lovibondLabel.bottomAnchor, constant: AppMargins.small.margin).active = true
		ebcLabel.leadingAnchor.constraintEqualToAnchor(srmColorView.trailingAnchor, constant:  AppMargins.medium.margin).active = true
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func prepareForReuse() {
		colorLabel.text = ""
		lovibondLabel.text = ""
		ebcLabel.text = ""
		srmColorView.srm = nil
	}
	
	func configWithSRM(srm: SRM) {
		if let color = srm.color {
			var colorString = color.name.capitalizedString
			if let alt = color.altName {
				colorString =  colorString + " / " + alt.capitalizedString
			}
			self.colorLabel.text = colorString
		}
		self.lovibondLabel.text = "Lovibond : \(srm.lovibondString())"
		self.ebcLabel.text = "EBC : \(srm.ebcString())"
		self.srmColorView.srm = srm
		swatchView.backgroundColor = srm.uiColor()
		//swatchEndView.backgroundColor = srm.uiColor()
		typeIndicator.color = srm.uiColor()

		
		resetGradientFrame()
	}
	
	
	func orientationChanged(notification: NSNotification) {
		resetGradientFrame()
	}
	
	func resetGradientFrame() {
		gradientLayer.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
	}
}
