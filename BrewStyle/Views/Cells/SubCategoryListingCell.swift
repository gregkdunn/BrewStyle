//
//  ListingCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 5/29/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryListingCell: UICollectionViewCell {
	let container = GradientView()
	let beverageHeaderView = BeverageHeaderDetailView()
	let descLabel = UITextView()
	let srmView = SRMPintRangeView()
	
	private let gradientLayer = CAGradientLayer()
	private let gradientLayer2 = CAGradientLayer()
	
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	let idSize : CGFloat = 60
	
	var containerLeading : NSLayoutConstraint?
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
		clipsToBounds = true
		
		let bgView = GradientView()
		bgView.backgroundColor = AppStyle.SubCategoryDetailHeader[.BackgroundColor]
		bgView.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.9)), bottomStop: (position: 0.5, color: AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.8)))
		self.backgroundView = bgView
		
		contentView.backgroundColor = UIColor.clearColor()
		
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.layer.cornerRadius = 2
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		containerLeading = container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 12)
		containerLeading!.active = true
		container.gradientWithColors((position: 0.5, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2)), bottomStop: (position: 0.5, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)))
		
		beverageHeaderView.viewWidth = self.contentView.bounds.width
		beverageHeaderView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(beverageHeaderView)
		beverageHeaderView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		beverageHeaderView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		beverageHeaderView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		beverageHeaderView.heightAnchor.constraintEqualToConstant(beverageHeaderView.intrinsicContentSize().height).active = true
		
		srmView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(srmView)
		srmView.topAnchor.constraintEqualToAnchor(beverageHeaderView.bottomAnchor, constant: AppMargins.large.margin).active = true
		srmView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.medium.negative).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.backgroundColor = UIColor.clearColor()
		descLabel.editable = false
		descLabel.scrollEnabled = false
		descLabel.userInteractionEnabled = false
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(beverageHeaderView.bottomAnchor, constant: AppMargins.medium.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.medium.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: AppMargins.medium.negative).active = true
	}
	
	override func prepareForReuse() {
		containerLeading?.constant = 12
		
		beverageHeaderView.clearData()
		descLabel.text = ""
		srmView.resetView()
		
		super.prepareForReuse()
	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel, showInset: Bool) {
		if showInset {
			containerLeading?.constant = 12
			if(subCategoryVM.hasParent()) {
				containerLeading?.constant = 16
			}
		} else {
			containerLeading?.constant = 0
		}
		
		setExclusionPath()
		beverageHeaderView.configWithBeverageSubCategoryViewModel(subCategoryVM)
		descLabel.text = subCategoryVM.desc()
		
		if (subCategoryVM.shouldDisplaySRM()) {
			srmView.alpha = 1.0
		} else {
			srmView.alpha = 0.25
		}
		
		srmView.setMinSrm(subCategoryVM.srmMin(), maxSrm:subCategoryVM.srmMax())
	
		gradientLayer.frame = self.bounds
		setDescHeight(calculateDescHeight())
		
		layoutSubviews()
	}
	
	func setExclusionPath() {
		let srmSize = srmView.intrinsicContentSize()
		
		let line = UIBezierPath()
		line.moveToPoint(CGPointMake(cellWidth, 0))
		line.addLineToPoint(CGPointMake(cellWidth, srmSize.height))
		line.addLineToPoint(CGPointMake(cellWidth - (srmSize.width + AppMargins.large.margin), srmSize.height))
		line.addLineToPoint(CGPointMake(cellWidth - (srmSize.width + AppMargins.large.margin), 0))
		line.addLineToPoint(CGPointMake(cellWidth, 0))
		line.closePath()
		
		descLabel.textContainer.exclusionPaths = [line]
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		// add header height
		var cellHeight = AppMargins.medium.margin + beverageHeaderView.intrinsicContentSize().height
		
		//add desc height
		let descHeight = calculateDescHeight()
		cellHeight  = (descHeight > 0) ? cellHeight + AppMargins.large.margin + descHeight : cellHeight
		
		//add footer
		cellHeight = cellHeight + AppMargins.large.margin + AppMargins.xl.margin
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func calculateDescHeight() -> CGFloat {
		//setExclusionPath()
		let height : CGFloat =  descLabel.heightNeededForWidth(cellWidth - AppMargins.large.double)
		return (height < srmView.intrinsicContentSize().height) ? srmView.intrinsicContentSize().height : height
	}
	
	func setDescHeight(height: CGFloat) {
		if let heightContraint = descHeightConstraint {
			heightContraint.constant = height
		}
	}
}
