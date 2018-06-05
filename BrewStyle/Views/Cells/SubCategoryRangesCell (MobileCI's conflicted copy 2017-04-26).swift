//
//  SubCategoryRangesCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/21/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryRangesCell: UICollectionViewCell {
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	
	let rangeViews = BeverageRangeView()
	let descLabel = UILabel()
	private let gradientLayer = CAGradientLayer()

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	func commonInit () {
		self.contentView.backgroundColor = UIColor.clearColor()
		
		let container = UIView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		
		let topColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.5, 1.0]
		container.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		rangeViews.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(rangeViews)
		rangeViews.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.medium.margin).active = true
		rangeViews.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		rangeViews.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		//rangeViews.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant:AppMargins.large.negative).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(rangeViews.bottomAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:AppMargins.medium.double).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant:-AppMargins.xl.margin).active = true
		
	}
	
	override func prepareForReuse() {
		rangeViews.clearData()
		super.prepareForReuse()
	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		rangeViews.configWithBeverageSubCategoryViewModel(subCategoryVM)
		descLabel.text = subCategoryVM.vitalStatistics()
		gradientLayer.frame = self.bounds
		layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		//range views
		var cellHeight = AppMargins.medium.margin + rangeViews.intrinsicContentSize().height
		
		cellHeight = cellHeight + AppMargins.small.margin + descLabel.heightNeededForWidth(cellWidth)
		
		//add footer
		cellHeight = cellHeight + AppMargins.xl.margin
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
}
