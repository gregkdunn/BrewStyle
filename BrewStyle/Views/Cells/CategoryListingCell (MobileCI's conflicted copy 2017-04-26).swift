//
//  CategoryListingCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/1/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


class CategoryListingCell: UICollectionViewCell {
	let gradientLayer = CAGradientLayer()
	let beverageHeaderView = BeverageHeaderDetailView()
	
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
		self.backgroundColor = AppStyle.CategoryListCell[.ContainerColor]
		
		let topColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.3).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.5, 1.0]
		self.contentView.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		beverageHeaderView.viewWidth = self.contentView.bounds.width
		beverageHeaderView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(beverageHeaderView)
		beverageHeaderView.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: 0).active = true
		beverageHeaderView.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: 0).active = true
		beverageHeaderView.bottomAnchor.constraintEqualToAnchor(self.contentView.bottomAnchor, constant: 0).active = true
		beverageHeaderView.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 0).active = true
	}
	
	override func prepareForReuse() {
		beverageHeaderView.clearData()
		super.prepareForReuse()
	}
	
	func configWithBeverageCategoryViewModel(categoryVM : BeverageCategoryViewModel) {
		beverageHeaderView.configWithBeverageCategoryViewModel(categoryVM)
		
		adjustGradient()
	}

	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		beverageHeaderView.configWithBeverageSubCategoryViewModel(subCategoryVM)
		
		adjustGradient()
	}
	
	func adjustGradient() {
		gradientLayer.frame = self.bounds
		layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		// add id height
		let cellHeight = beverageHeaderView.intrinsicContentSize().height
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
}
