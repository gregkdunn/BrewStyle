//
//  TitleView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/21/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//



class TitleView: UICollectionReusableView {
	let gradientLayer = CAGradientLayer()
	let titleLabel = UILabel()
	let categoryLabel = UILabel()
	
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
		self.backgroundColor = AppColor.White.color
		
		let container = GradientView()
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.1)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.2)))
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = UIColor.clearColor()
		

		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textColor = AppStyle.SubCategoryDetailHeader[.TitleColor]
		titleLabel.font = AppFonts.header.styled
		container.addSubview(titleLabel)
		titleLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant:AppMargins.small.margin).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant:AppMargins.medium.double).active = true
		titleLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant:AppMargins.medium.negative).active = true
		titleLabel.heightAnchor.constraintEqualToConstant(44).active = true
		
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.numberOfLines = 0
		categoryLabel.textColor = AppStyle.Text[.SubHeaderCopy]
		categoryLabel.font = AppFonts.subheader.italic
		container.addSubview(categoryLabel)
		categoryLabel.bottomAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: AppMargins.large.negative).active = true
		categoryLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		
		let under = UIView()
		under.translatesAutoresizingMaskIntoConstraints = false
		under.backgroundColor = AppColor.OldBlue.color
		container.addSubview(under)
		under.bottomAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.xl.margin + AppMargins.large.margin).active = true
		under.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.medium.double).active = true
		under.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		under.heightAnchor.constraintEqualToConstant(1).active = true
		
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
		
	func configWithTitle(title: String?, category: String?) {
		if let newTitle = title {
			titleLabel.text = newTitle
			
		}
		if let newCategory = category {
			categoryLabel.text = newCategory
		}
	}
}