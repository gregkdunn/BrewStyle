//
//  SRMCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/22/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


class SRMCell: UICollectionViewCell {
	let srmListView = SRMListView()
	
	let titleGradient = GradientView()
	
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
		self.contentView.backgroundColor = UIColor.clearColor()
		
		let container = GradientView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0)))
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		srmListView.frame = self.bounds
		srmListView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(srmListView)
		srmListView.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: 0).active = true
		srmListView.bottomAnchor.constraintEqualToAnchor(self.contentView.bottomAnchor, constant: 0).active = true
		srmListView.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: 0).active = true
		srmListView.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 0).active = true
		
		titleGradient.backgroundColor = UIColor.clearColor()
		titleGradient.translatesAutoresizingMaskIntoConstraints = false
		titleGradient.gradientWithColors((position: 0.8, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)))
		container.addSubview(titleGradient)
		titleGradient.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: 0).active = true
		titleGradient.bottomAnchor.constraintEqualToAnchor(self.contentView.bottomAnchor, constant: 0).active = true
		titleGradient.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: 0).active = true
		titleGradient.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 0).active = true
		
	}
	
	override func prepareForReuse() {
		titleGradient.hidden = true
	}
	 
	func configWithSRM(srm: SRM, isHeader: Bool) {
		srmListView.configWithSRM(srm)
		
		if isHeader {
			titleGradient.hidden = false
		} else {
			titleGradient.hidden = true
		}
	}

	
}