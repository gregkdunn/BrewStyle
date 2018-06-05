//
//  SRMCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/22/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


class SRMCell: UICollectionViewCell {
	let srmListView = SRMListView()
	
	private let gradientLayer = CAGradientLayer()
	private let titleGradientLayer = CAGradientLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.clipsToBounds = true
		self.contentView.backgroundColor = AppColor.White.color
		
		let topColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.3).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.5, 1.0]
		self.contentView.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		srmListView.frame = self.bounds
		srmListView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(srmListView)
		srmListView.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: 0).active = true
		srmListView.bottomAnchor.constraintEqualToAnchor(self.contentView.bottomAnchor, constant: 0).active = true
		srmListView.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: 0).active = true
		srmListView.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 0).active = true
		
		let titleTopColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0).CGColor as CGColorRef
		let titleBottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.5).CGColor as CGColorRef
		titleGradientLayer.frame = self.bounds
		titleGradientLayer.colors = [ titleTopColor, titleBottomColor]
		titleGradientLayer.locations = [ 0.8, 1.0]
	}
	
	override func prepareForReuse() {
		titleGradientLayer.removeFromSuperlayer()
		srmListView.prepareForReuse()
	}
	
	func configWithSRM(srm: SRM, isHeader: Bool) {
		srmListView.configWithSRM(srm)
		
		if isHeader {
			self.contentView.layer.insertSublayer(titleGradientLayer, atIndex: 1)
		}
	}

	
}