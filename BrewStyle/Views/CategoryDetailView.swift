//
//  CategoryDetailViewView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/13/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


class CategoryDetailView: UICollectionReusableView {
	let titleGradient = GradientView()
	let titleLabel = UILabel()
	let descLabel = UILabel()
	
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
		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = UIColor.clearColor()
		
		let container = GradientView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppColor.White.color
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)))
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.backgroundColor = AppColor.White.alpha(0.3)
		titleLabel.textAlignment = .Center
		titleLabel.textColor =  AppStyle.Text[.HeaderCopy]
		titleLabel.font = AppFonts.pageTitle.styled
		container.addSubview(titleLabel)
		titleLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant:0).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant:0).active = true
		titleLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant:0).active = true
		titleLabel.heightAnchor.constraintEqualToConstant(51).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant:AppMargins.medium.double).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant:AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant:AppMargins.medium.negative).active = true
		
		titleGradient.translatesAutoresizingMaskIntoConstraints = false
		titleGradient.gradientWithColors((position: 0.8, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)))
		container.addSubview(titleGradient)
		titleGradient.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		titleGradient.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: 0).active = true
		titleGradient.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		titleGradient.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
	}
	
	class func sizeForText(text: String, width: CGFloat) -> CGSize {
		let viewWidth = width - (AppMargins.large.margin + AppMargins.large.margin)
		let height = UILabel.heightNeededForText(text, font:AppFonts.body.font, width: viewWidth)
		return CGSize(width: width, height: AppMargins.large.margin + height + AppMargins.small.margin + 50 )
	}
	
	func configWithCategoryViewModel(categoryVM:BeverageCategoryViewModel) {
		titleLabel.text = categoryVM.title()
		descLabel.text = categoryVM.desc()
		descLabel.sizeToFit()
		
		self.layoutSubviews()
	}
	
	func configWithTitle(title: String?, description: String?) {
		if let newTitle = title {
			titleLabel.text = newTitle
		}

		if let newDesc = description {
			descLabel.text = newDesc
		}
		descLabel.sizeToFit()
	}

}