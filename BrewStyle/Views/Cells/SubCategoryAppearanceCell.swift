//
//  SubCategoryAppearanceCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/26/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryAppearanceCell: UICollectionViewCell {
	let container = UIView()
	let descLabel = UITextView()
	let srmView = SRMPintRangeView()
	
	private let gradientLayer = CAGradientLayer()
	
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
		
		srmView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(srmView)
		srmView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.medium.margin).active = true
		srmView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.backgroundColor = UIColor.clearColor()
		descLabel.editable = false
		descLabel.scrollEnabled = false
		descLabel.userInteractionEnabled = false
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: AppMargins.medium.negative).active = true
	}
	
	override func prepareForReuse() {
		descLabel.text = ""
		srmView.resetView()
		super.prepareForReuse()
	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		setExclusionPath()
		descLabel.text = subCategoryVM.appearance()
		
		if (subCategoryVM.shouldDisplaySRM()) {
			srmView.alpha = 1.0
		} else {
			srmView.alpha = 0.25
		}
		
		srmView.setMinSrm(subCategoryVM.srmMin(), maxSrm:subCategoryVM.srmMax())
		
		gradientLayer.frame = self.bounds
		calculateDescHeight()
		
		layoutSubviews()
	}
	
	func setExclusionPath() {
		let srmSize = srmView.intrinsicContentSize()
		
		let line = UIBezierPath()
		line.moveToPoint(CGPointMake(0, 0))
		line.addLineToPoint(CGPointMake(0, srmSize.height))
		line.addLineToPoint(CGPointMake((srmSize.width + AppMargins.large.margin), srmSize.height))
		line.addLineToPoint(CGPointMake((srmSize.width + AppMargins.large.margin), 0))
		line.addLineToPoint(CGPointMake(0, 0))
		line.closePath()
		
		descLabel.textContainer.exclusionPaths = [line]
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		// add header height
		var cellHeight = AppMargins.medium.margin
		
		//add desc height
		let srmHeight = srmView.intrinsicContentSize().height
		let descHeight = calculateDescHeight()
		cellHeight  = (descHeight > srmHeight) ? cellHeight + descHeight : cellHeight + srmHeight
		
		//add footer
		cellHeight = cellHeight + AppMargins.xl.margin
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func calculateDescHeight() -> CGFloat {
		let height : CGFloat =  descLabel.heightNeededForWidth(cellWidth - AppMargins.large.double) + AppMargins.large.margin
		return (height < srmView.intrinsicContentSize().height) ? srmView.intrinsicContentSize().height : height
	}

}
