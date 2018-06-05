//
//  SubCategoryTagsCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/26/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryTagsCell: UICollectionViewCell {
	
	let tagListView = TagListView(tagVMs: [])
	
	private let gradientLayer = CAGradientLayer()
	
	var cellWidth : CGFloat = 0 {
		didSet {
			tagListView.viewWidth = cellWidth - AppMargins.large.double
		}
	}
	let defaultCellWidth : CGFloat = 360
	let idSize : CGFloat = 60
	
	var containerTop : NSLayoutConstraint?
	var containerBottom : NSLayoutConstraint?
	
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
		
		let container = UIView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		let topColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.5, 1.0]
		container.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		tagListView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(tagListView)
		tagListView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.medium.margin).active = true
		tagListView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		tagListView.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: AppMargins.large.negative).active = true
		tagListView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.medium.negative).active = true
	}
	
	override func prepareForReuse() {
		tagListView.resetTagViews()
		super.prepareForReuse()
	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		tagListView.tagViewModels =  subCategoryVM.tagViewModels()
		gradientLayer.frame = self.bounds
		layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = calculateTagListWidth()
		
		// add header height
		var cellHeight = AppMargins.large.margin
		
		//add desc height
		let tagListHeight = calculateTagListHeight()
		cellHeight  = cellHeight + tagListHeight
			
		cellHeight = cellHeight + AppMargins.large.margin + AppMargins.large.margin
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func calculateTagListHeight() -> CGFloat {
		let height : CGFloat =  tagListView.intrinsicContentSize().height
		return height
	}
	
	func calculateTagListWidth() -> CGFloat {
		return (cellWidth > 0) ? cellWidth : defaultCellWidth
	}
	
}