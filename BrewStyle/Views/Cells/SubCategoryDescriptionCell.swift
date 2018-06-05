//
//  SubCategoryDescriptionCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/21/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//
//
//  SubCategoryParentListingCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/14/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryDescriptionCell: UICollectionViewCell {
	
	let descLabel = UILabel()
	
	private let gradientLayer = CAGradientLayer()
	
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	let idSize : CGFloat = 60
	
	var descHeightConstraint : NSLayoutConstraint?
	
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
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.numberOfLines = 0
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: AppMargins.large.negative).active = true
	}
	
	override func prepareForReuse() {
		descLabel.text = ""
		
		setDescHeight(calculateDescHeight())
		
		super.prepareForReuse()
	}
	
	func configWithDescription(description: String) {
		descLabel.text = description
		setDescHeight(calculateDescHeight())
		gradientLayer.frame = self.bounds
		layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		// add header
		var cellHeight = AppMargins.medium.margin
		
		//add desc height
		let descHeight = calculateDescHeight()
		cellHeight  = (descHeight > 0) ? cellHeight + descHeight : cellHeight
		
		//add footer
		cellHeight = cellHeight + AppMargins.xl.margin
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
		
	func calculateDescHeight() -> CGFloat {
		
		let height : CGFloat =  descLabel.heightNeededForWidth(cellWidth - AppMargins.large.double)
		
		return height
		
	}
	
	func setDescHeight(height: CGFloat) {
		if let heightContraint = descHeightConstraint {
			heightContraint.constant = height
		}
	}
}
