//
//  SubCategoryStatCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/12/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SubcategoryStatCell: UICollectionViewCell {
	let container = GradientView()
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
	let defaultCellWidth : CGFloat = 375
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
		
		
		let srmLeadingConstant = (UIScreen.mainScreen().bounds.width < 375) ?  beverageHeaderView.idSize / 2 : beverageHeaderView.idSize + AppMargins.medium.margin
		srmView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(srmView)
		srmView.topAnchor.constraintEqualToAnchor(beverageHeaderView.bottomAnchor, constant: AppMargins.large.margin).active = true
		srmView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: srmLeadingConstant).active = true
		
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
		if true /*showInset*/ {
			containerLeading?.constant = 12
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
	}

	func createAttributedStringForTitle(title : String, value : String) -> NSMutableAttributedString {
		let string = "\(title) : \(value)"
		let attString = NSMutableAttributedString(string: string)
		attString.addAttributes(titleAttributes, range: NSRange(location: 0, length: title.characters.count))
		
		return attString
	}
	
}

