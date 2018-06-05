//
//  TermListingCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/30/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TermListingCell: UICollectionViewCell {
	let swatchView = UIView()
	let typeIndicator = TriangleView()
	let termLabel = UILabel()
	let categoryLabel = UILabel()
	let descLabel = UILabel()
	
	var descLabelHeightConstraint : NSLayoutConstraint?
	
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
		self.contentView.backgroundColor = AppColor.White.color
		
		let container = GradientView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.15)))
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		swatchView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(swatchView)
		swatchView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
		swatchView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
		swatchView.heightAnchor.constraintEqualToAnchor(container.heightAnchor).active = true
		swatchView.widthAnchor.constraintEqualToConstant(AppMargins.large.margin).active = true
		
		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(typeIndicator)
		typeIndicator.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(16).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(16).active = true
		
		termLabel.translatesAutoresizingMaskIntoConstraints = false
		termLabel.textAlignment = .Left
		termLabel.lineBreakMode = .ByWordWrapping
		termLabel.textColor = AppStyle.SubCategoryDetailHeader[.TitleColor]
		termLabel.font = AppFonts.header.styled
		termLabel.numberOfLines = 1
		container.addSubview(termLabel)
		termLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant:AppMargins.large.margin).active = true
		termLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:AppMargins.large.margin).active = true
		termLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true

		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.textAlignment = .Left
		categoryLabel.lineBreakMode = .ByWordWrapping
		categoryLabel.textColor = AppStyle.Text[.SubHeaderCopy]
		categoryLabel.font = AppFonts.subheader.italic
		categoryLabel.numberOfLines = 1
		container.addSubview(categoryLabel)
		categoryLabel.topAnchor.constraintEqualToAnchor(termLabel.bottomAnchor, constant:AppMargins.small.margin).active = true
		categoryLabel.leadingAnchor.constraintEqualToAnchor(termLabel.leadingAnchor, constant:0).active = true
		categoryLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true

		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(categoryLabel.bottomAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(termLabel.leadingAnchor, constant:0).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		descLabelHeightConstraint = descLabel.heightAnchor.constraintEqualToConstant(100)
		if let heightConstraint = descLabelHeightConstraint {
			heightConstraint.active = true
		}
		
		container.layer.addSublayer(gradientLayer)
	}
	
	override func prepareForReuse() {
		descLabel.text = ""
		super.prepareForReuse()
	}
	
	func configWithTermViewModel(termVM : TermViewModel) {
		gradientLayer.frame = self.bounds
		termLabel.text = termVM.title()
		categoryLabel.text = termVM.categoryName()
		descLabel.text = termVM.desc()
		if let heightConstraint = descLabelHeightConstraint {
			heightConstraint.constant = calculateDescHeightForWidth(calculateTermWidth())
		}
		swatchView.backgroundColor = UIColor.clearColor()//termVM.color()
		typeIndicator.color = termVM.color()
		
		self.updateConstraints()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = calculateTermWidth()
		let height = calculateDescHeightForWidth(cellWidth)
		return CGSize(width: cellWidth, height: AppMargins.xl.margin + height + AppMargins.medium.margin + 48 + AppMargins.large.margin )
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func calculateDescHeightForWidth(width: CGFloat) -> CGFloat {
		return descLabel.heightNeededForWidth(width - AppMargins.medium.margin - AppMargins.large.margin)
	}
	
	func calculateTermWidth() -> CGFloat {
		return (cellWidth > 0) ? cellWidth : defaultCellWidth
	}
	
}
