//
//  CategoryDetailViewView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/13/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


class CategoryDetailView: UICollectionReusableView {
	let gradientLayer = CAGradientLayer()
	let titleLabel = UILabel()
	let descLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.backgroundColor = AppColor.White.color
		let topColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(1.0).CGColor as CGColorRef
		let bottomColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(0.5).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.0, 1.0]
		self.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.backgroundColor = AppColor.White.alpha(0.3)
		titleLabel.textAlignment = .Center
		titleLabel.textColor = AppStyle.Text[.HeaderCopy]
		titleLabel.font = UIFont(name: "Futura-CondensedMedium", size: 27)
		self.addSubview(titleLabel)
		titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant:0).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:0).active = true
		titleLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:0).active = true
		titleLabel.heightAnchor.constraintEqualToConstant(40).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		self.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:AppMargins.medium.double).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant:AppMargins.medium.negative).active = true

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	class func sizeForText(text: String, width: CGFloat) -> CGSize {
		let viewWidth = width - (AppMargins.large.margin + AppMargins.large.margin)
		let height = UILabel.heightNeededForText(text, font:UIFont.systemFontOfSize(15), width: viewWidth)
		return CGSize(width: width, height: AppMargins.large.margin + height + AppMargins.small.margin + 29 )
	}
	
	func configWithCategoryViewModel(categoryVM:BeverageCategoryViewModel) {
		titleLabel.text = categoryVM.title()
		descLabel.text = categoryVM.desc()
		descLabel.sizeToFit()
		
		self.layoutSubviews()
	}
	
	func configWithTitle(title: String?, description: String?) {
		if let newTitle = title {
			titleLabel.text = newTitle
		}

		if let newDesc = description {
			descLabel.text = newDesc
		}
		descLabel.sizeToFit()
	}
	
	func orientationChanged(notification: NSNotification) {
		resetGradientFrame()
	}
	
	func resetGradientFrame() {
		gradientLayer.frame = self.bounds
	}
}