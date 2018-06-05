//
//  TagListingCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/25/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TagListingCell: UICollectionViewCell {
	let titleView = TitleView()
	let tagListView = TagListView(tagVMs: [])
	
	private let gradientLayer = CAGradientLayer()
	
	var cellWidth : CGFloat = 0 {
		didSet {
			tagListView.viewWidth = cellWidth - AppMargins.large.double
		}
	}
	let defaultCellWidth : CGFloat = 360
	
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
		
		let container = GradientView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)))
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		titleView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(titleView)
		titleView.backgroundColor = AppColor.White.color
		titleView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		titleView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		titleView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		titleView.heightAnchor.constraintEqualToConstant(48).active = true
		
		tagListView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(tagListView)
		tagListView.topAnchor.constraintEqualToAnchor(titleView.bottomAnchor, constant: AppMargins.large.margin).active = true
		tagListView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		tagListView.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: AppMargins.large.negative).active = true
		tagListView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.medium.negative).active = true
	}
	
	override func prepareForReuse() {
		tagListView.resetTagViews()
		super.prepareForReuse()
	}
	
	func configWithTagViewModel(tagVM : TagViewModel) {
		gradientLayer.frame = self.bounds
		tagListView.tagViewModels = [tagVM]
		self.layoutSubviews()
	}

	func configWithTagViewModels(tagVMs : [TagViewModel]) {
		gradientLayer.frame = self.bounds
		titleView.configWithTitle(tagVMs.first?.categoryName().capitalizedString, category: "")
		tagListView.tagViewModels = tagVMs
		self.layoutSubviews()
	}
	
	func configWithTagViewModels(tagVMs : [TagViewModel], subCategoryVM : BeverageSubCategoryViewModel) {
		tagListView.subCategoryVM = subCategoryVM
		configWithTagViewModels(tagVMs)
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = calculateTagListWidth()
		
		// add header height
		var cellHeight = AppMargins.large.margin
		
		cellHeight = cellHeight + 48
		
		//add desc height
		let tagHeight = calculateTagListHeight()
		cellHeight  = (tagHeight > 0) ? cellHeight + AppMargins.large.margin + tagHeight + AppMargins.large.margin  : cellHeight + AppMargins.large.margin 
		//print(">>tagHeight>> \(tagHeight)")
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