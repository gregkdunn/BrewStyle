//
//  TagDefinitionCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/20/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TagDefinitionCell: UICollectionViewCell {
	let container = UIView()
	
	let swatchView = UIView()
	let swatchEndView = UIView()
	let typeIndicator = TriangleView()
	
	var tagView = TagView()
	let categoryLabel = UILabel()
	let descLabel = UILabel()
	
	var tagWidthConstraint : NSLayoutConstraint?
	
	private let gradientLayer = CAGradientLayer()
	private let titleGradientLayer = CAGradientLayer()
	
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	
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
		let topColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [0.0, 1.0]
		self.contentView.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = UIColor.clearColor()
		
		self.contentView.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		let titleTopColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0).CGColor as CGColorRef
		let titleBottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.5).CGColor as CGColorRef
		titleGradientLayer.frame = self.bounds
		titleGradientLayer.colors = [ titleTopColor, titleBottomColor]
		titleGradientLayer.locations = [ 0.8, 1.0]
		
		swatchView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(swatchView)
		swatchView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
		swatchView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
		swatchView.heightAnchor.constraintEqualToAnchor(container.heightAnchor).active = true
		swatchView.widthAnchor.constraintEqualToConstant(AppMargins.large.margin).active = true
		
		swatchEndView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(swatchEndView)
		swatchEndView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
		swatchEndView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor).active = true
		swatchEndView.heightAnchor.constraintEqualToAnchor(container.heightAnchor).active = true
		swatchEndView.widthAnchor.constraintEqualToConstant(AppMargins.large.margin).active = true
		
		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(typeIndicator)
		typeIndicator.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(16).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(16).active = true
		
		tagView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(tagView)
		tagView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.large.margin).active = true
		tagView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.xl.margin).active = true
		tagWidthConstraint = tagView.widthAnchor.constraintEqualToConstant(100)
		if let widthConstraint = tagWidthConstraint {
			widthConstraint.active = true
		}

		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.numberOfLines = 0
		categoryLabel.textColor = AppStyle.Text[.SubHeaderCopy]
		categoryLabel.font = UIFont.italicSystemFontOfSize(11)
		container.addSubview(categoryLabel)
		categoryLabel.topAnchor.constraintEqualToAnchor(tagView.bottomAnchor, constant:AppMargins.small.margin).active = true
		categoryLabel.leadingAnchor.constraintEqualToAnchor(tagView.leadingAnchor, constant: AppMargins.small.margin).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(categoryLabel.bottomAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(tagView.leadingAnchor, constant: AppMargins.small.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.medium.negative).active = true
		

	}
	
	override func prepareForReuse() {
		titleGradientLayer.removeFromSuperlayer()
		
		categoryLabel.text = ""
		descLabel.text = ""
		
		super.prepareForReuse()
	}
	
	func configWithTagViewModel(tagVM : TagViewModel, isHeader: Bool) {
		gradientLayer.frame = self.bounds
		swatchView.backgroundColor = tagVM.color()
		//swatchEndView.backgroundColor = tagVM.color().colorWithAlphaComponent(0.5)
		typeIndicator.color = tagVM.color()
		tagView.configWithTagViewModel(tagVM)
		if let widthConstraint = tagWidthConstraint {
			widthConstraint.constant = tagView.intrinsicContentSize().width
		}
		categoryLabel.text = tagVM.categoryName()
		if tagVM.desc().characters.count > 0 {
			descLabel.text = tagVM.desc()
		}
		
		if isHeader {
			container.layer.addSublayer(titleGradientLayer)
		}
		
		self.layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = calculateTagListWidth()
		
		// add header height
		var cellHeight = AppMargins.medium.margin
		// add tag height
		cellHeight = cellHeight + 24
		
		//add desc height
		let descHeight : CGFloat = 44
		cellHeight  = (descHeight > 0) ? cellHeight + AppMargins.medium.margin + descHeight + AppMargins.large.margin  : cellHeight + AppMargins.large.margin
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func calculateTagListWidth() -> CGFloat {
		return (cellWidth > 0) ? cellWidth : defaultCellWidth
	}
	
}