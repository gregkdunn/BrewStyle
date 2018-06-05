//
//  SubCategoryStatCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/12/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryStatCell: UICollectionViewCell {
	let container = UIView()
	let beverageHeaderView = BeverageHeaderDetailView()
	let srmView = SRMPintRangeView()
	let ibuLabel = UILabel()
	let ogLabel = UILabel()
	let fgLabel = UILabel()
	let abvLabel = UILabel()
	
	var ibuTitleString = "IBU"
	var ogTitleString = "OG"
	var fgTitleString = "FG"
	var abvTitleString = "ABV"
	var titleAttributes = [NSForegroundColorAttributeName: AppColor.Black.color, NSFontAttributeName: AppFonts.body.bold]
	
	private let gradientLayer = CAGradientLayer()
	private let gradientLayer2 = CAGradientLayer()
	
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	let idSize : CGFloat = 60
	
	var containerLeading : NSLayoutConstraint?
	
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
		let bgView = UIView()
		contentView.backgroundColor = UIColor.clearColor()
		
		self.backgroundView = bgView
		bgView.backgroundColor = AppStyle.SubCategoryDetailHeader[.BackgroundColor]
		
		let topColor = AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.9).CGColor as CGColorRef
		let bottomColor = AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.8).CGColor as CGColorRef
		gradientLayer.frame = CGRectMake(2, 0, (self.bounds.width - 2), self.bounds.height)
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.0, 0.5]
		bgView.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.layer.cornerRadius = 2
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		containerLeading = container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 12)
		containerLeading!.active = true
		
		let top2Color = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2).CGColor as CGColorRef
		let bottom2Color = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1).CGColor as CGColorRef
		gradientLayer2.frame = self.bounds
		gradientLayer2.colors = [ top2Color, bottom2Color]
		gradientLayer2.locations = [ 0.5, 1.0]
		container.layer.insertSublayer(gradientLayer2, atIndex: 0)
		
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
		srmView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: beverageHeaderView.idSize + AppMargins.medium.margin).active = true
		
		ibuLabel.translatesAutoresizingMaskIntoConstraints = false
		ibuLabel.font = AppFonts.body.font
		container.addSubview(ibuLabel)
		ibuLabel.topAnchor.constraintEqualToAnchor(srmView.topAnchor, constant: 0).active = true
		ibuLabel.leadingAnchor.constraintEqualToAnchor(srmView.trailingAnchor, constant: AppMargins.large.margin).active = true

		ogLabel.translatesAutoresizingMaskIntoConstraints = false
		ogLabel.font = AppFonts.body.font
		container.addSubview(ogLabel)
		ogLabel.topAnchor.constraintEqualToAnchor(ibuLabel.bottomAnchor, constant: AppMargins.small.margin).active = true
		ogLabel.leadingAnchor.constraintEqualToAnchor(ibuLabel.leadingAnchor, constant: 0).active = true
		
		fgLabel.translatesAutoresizingMaskIntoConstraints = false
		fgLabel.font = AppFonts.body.font
		container.addSubview(fgLabel)
		fgLabel.topAnchor.constraintEqualToAnchor(ogLabel.bottomAnchor, constant: AppMargins.small.margin).active = true
		fgLabel.leadingAnchor.constraintEqualToAnchor(ibuLabel.leadingAnchor, constant: 0).active = true
		
		abvLabel.translatesAutoresizingMaskIntoConstraints = false
		abvLabel.font = AppFonts.body.font
		container.addSubview(abvLabel)
		abvLabel.topAnchor.constraintEqualToAnchor(fgLabel.bottomAnchor, constant: AppMargins.small.margin).active = true
		abvLabel.leadingAnchor.constraintEqualToAnchor(ibuLabel.leadingAnchor, constant: 0).active = true
	}
	
	override func prepareForReuse() {
		containerLeading?.constant = 12
		
		beverageHeaderView.clearData()
		srmView.resetView()
		
		ibuLabel.text = "IBU : "
		ogLabel.text = "OG : "
		fgLabel.text = "FG : "
		abvLabel.text = "ABV : "
		
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
		
		beverageHeaderView.configWithBeverageSubCategoryViewModel(subCategoryVM)
		
		if (subCategoryVM.shouldDisplaySRM()) {
			srmView.alpha = 1.0
		} else {
			srmView.alpha = 0.25
		}
		
		srmView.setMinSrm(subCategoryVM.srmMin(), maxSrm:subCategoryVM.srmMax())
		
		ibuLabel.attributedText = createAttributedStringForTitle(ibuTitleString, value: subCategoryVM.ibuRange())

		ogLabel.attributedText = createAttributedStringForTitle(ogTitleString, value: subCategoryVM.ogRange())
		fgLabel.attributedText = createAttributedStringForTitle(fgTitleString, value: subCategoryVM.fgRange())
		abvLabel.attributedText = createAttributedStringForTitle(abvTitleString, value: subCategoryVM.abvRange())
		
		gradientLayer.frame = self.bounds
		
		layoutSubviews()
	}

	func createAttributedStringForTitle(title : String, value : String) -> NSMutableAttributedString {
		let string = "\(title) : \(value)"
		let attString = NSMutableAttributedString(string: string)
		attString.addAttributes(titleAttributes, range: NSRange(location: 0, length: title.characters.count))
		
		return attString
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		// add header height
		var cellHeight = AppMargins.medium.margin + beverageHeaderView.intrinsicContentSize().height
		
		//add desc height
		cellHeight  = cellHeight + AppMargins.large.margin + srmView.intrinsicContentSize().height
		
		//add footer
		cellHeight = AppMargins.large.margin + cellHeight + AppMargins.xl.margin
		
		return CGSize(width: cellWidth, height: cellHeight)
	}

	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
}

