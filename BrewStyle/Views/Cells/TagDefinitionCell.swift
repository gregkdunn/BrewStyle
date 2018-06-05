//
//  TagDefinitionCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/20/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TagDefinitionCell: UICollectionViewCell {
	let container = GradientView()
	
	let swatchView = UIView()
	let typeIndicator = TriangleView()
	
	let titleLabel = UILabel()
	var tagView = TagView()
	let categoryLabel = UILabel()
	let descLabel = UILabel()
	
	var tagWidthConstraint : NSLayoutConstraint?
	
	let titleGradient = GradientView()
	
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

		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0)))
		self.contentView.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true

		swatchView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(swatchView)
		swatchView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
		swatchView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
		swatchView.heightAnchor.constraintEqualToConstant(60).active = true
		swatchView.widthAnchor.constraintEqualToConstant(60).active = true

		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(typeIndicator)
		typeIndicator.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(16).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(16).active = true
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textAlignment = .Left
		titleLabel.textColor = AppStyle.Text[.HeaderCopy]
		titleLabel.font = AppFonts.title.styled
		titleLabel.layoutMargins = UIEdgeInsetsMake(20, 20, 20, 20)
		titleLabel.numberOfLines = 0
		container.addSubview(titleLabel)
		titleLabel.centerYAnchor.constraintEqualToAnchor(swatchView.centerYAnchor, constant: -10).active = true
		titleLabel.heightAnchor.constraintEqualToConstant(27).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(swatchView.trailingAnchor, constant: AppMargins.medium.margin).active = true
		titleLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		
		
		tagView.translatesAutoresizingMaskIntoConstraints = false
		
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.numberOfLines = 0
		categoryLabel.textColor = AppStyle.Text[.SubHeaderCopy]
		categoryLabel.font = AppFonts.subheader.italic
		container.addSubview(categoryLabel)
		categoryLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant:0).active = true
		categoryLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor, constant:0).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(swatchView.bottomAnchor, constant:AppMargins.large.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.medium.negative).active = true
		
		titleGradient.backgroundColor = UIColor.clearColor()
		titleGradient.translatesAutoresizingMaskIntoConstraints = false
		titleGradient.gradientWithColors((position: 0.8, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)))
		container.addSubview(titleGradient)
		titleGradient.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: 0).active = true
		titleGradient.bottomAnchor.constraintEqualToAnchor(self.contentView.bottomAnchor, constant: 0).active = true
		titleGradient.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: 0).active = true
		titleGradient.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 0).active = true
		
	}
	
	override func prepareForReuse() {
		titleGradient.hidden = true

		categoryLabel.text = ""
		descLabel.text = ""
		
		super.prepareForReuse()
	}
	
	func configWithTagViewModel(tagVM : TagViewModel, isHeader: Bool) {

		swatchView.backgroundColor = tagVM.color()
		typeIndicator.color = tagVM.color()

		titleLabel.text = tagVM.title()
		categoryLabel.text = tagVM.categoryName()
		if tagVM.desc().characters.count > 0 {
			descLabel.text = tagVM.desc()
		}
		
		if isHeader {
			titleGradient.hidden = false
		} else {
			titleGradient.hidden = true
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = calculateTagListWidth()
		
		// add header height
		var cellHeight = AppMargins.medium.margin
		// add tag height
		cellHeight = cellHeight + 24
		
		//add desc height
		let descHeight : CGFloat = 60
		cellHeight  = (descHeight > 0) ? cellHeight + AppMargins.large.margin + descHeight + AppMargins.large.margin  : cellHeight + AppMargins.large.margin
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