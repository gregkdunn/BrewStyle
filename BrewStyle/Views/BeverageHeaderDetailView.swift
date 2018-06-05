//
//  BeverageHeaderDetailView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/21/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//



class BeverageHeaderDetailView: UIView {
	let container = UIView()
	
	let typeIndicator = TriangleView()
	let idLabel = UILabel()
	let titleLabel = UILabel()
	let typeLabel = UILabel()
	
	var viewWidth : CGFloat = 0
	let defaultViewWidth : CGFloat = 360
	let idSize : CGFloat = 60
	
	var typeLabelHeight : NSLayoutConstraint?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.clipsToBounds = false
		self.layer.cornerRadius = 2
		self.backgroundColor = UIColor.clearColor()
		
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = UIColor.clearColor()
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(typeIndicator)
		typeIndicator.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(16).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(16).active = true
		
		idLabel.translatesAutoresizingMaskIntoConstraints = false
		idLabel.clipsToBounds = true
		idLabel.backgroundColor = AppStyle.Id[.IdColor]
		idLabel.textColor = AppStyle.Id[.IdText]
		idLabel.font = AppFonts.id.styled
		idLabel.textAlignment = .Center
		idLabel.layer.cornerRadius = 0
		container.addSubview(idLabel)
		idLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		idLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		idLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: 0).active = true
		idLabel.widthAnchor.constraintEqualToConstant(idSize).active = true
		
		let gradientLayer = CAGradientLayer()
		let titleTopColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.0).CGColor as CGColorRef
		let titleBottomColor = AppStyle.SubCategoryListCell[.ContainerGradient]!.colorWithAlphaComponent(0.9).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ titleTopColor, titleBottomColor]
		gradientLayer.locations = [ 0.8, 1.0]
		idLabel.layer.addSublayer(gradientLayer)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textAlignment = .Left
		titleLabel.textColor = AppStyle.Text[.HeaderCopy]
		titleLabel.font = AppFonts.title.styled
		titleLabel.layoutMargins = UIEdgeInsetsMake(20, 20, 20, 20)
		titleLabel.numberOfLines = 0
		container.addSubview(titleLabel)
		titleLabel.centerYAnchor.constraintEqualToAnchor(idLabel.centerYAnchor, constant: -10).active = true
		titleLabel.heightAnchor.constraintEqualToConstant(idSize).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(idLabel.trailingAnchor, constant: AppMargins.medium.margin).active = true
		titleLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		
		typeLabel.translatesAutoresizingMaskIntoConstraints = false
		typeLabel.numberOfLines = 0
		typeLabel.textColor = AppStyle.Text[.SubHeaderCopy]
		typeLabel.font = AppFonts.subheader.italic
		container.addSubview(typeLabel)
		typeLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: AppMargins.large.negative).active = true
		typeLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor, constant: 0).active = true
		typeLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		typeLabel.widthAnchor.constraintLessThanOrEqualToAnchor(container.widthAnchor, constant: 0 - AppMargins.large.negative - AppMargins.medium.margin - idSize).active = true
		typeLabelHeight = typeLabel.heightAnchor.constraintEqualToConstant(13)
		if let heightConstraint = typeLabelHeight {
			heightConstraint.active = true
		}
	}
	
	func clearData() {
		typeIndicator.backgroundColor = UIColor.clearColor()
		idLabel.text = ""
		titleLabel.text = ""
		typeLabel.text = ""
	}
	
	func configWithBeverageCategoryViewModel(categoryVM : BeverageCategoryViewModel) {
		typeIndicator.color = categoryVM.typeIndicatorColor()
		idLabel.text = categoryVM.id() as String
		idLabel.backgroundColor = categoryVM.typeIndicatorColor()
		titleLabel.text = categoryVM.title() as String
		typeLabel.text = categoryVM.type()
	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		if(!subCategoryVM.hasParent()) {
			typeIndicator.color = subCategoryVM.typeIndicatorColor()
			typeIndicator.hidden = false
			idLabel.backgroundColor = subCategoryVM.typeIndicatorColor()
		} else {
			typeIndicator.hidden = true
			idLabel.backgroundColor = subCategoryVM.typeIndicatorColor()
		}
		idLabel.textColor = subCategoryVM.idTextColor()
		idLabel.text = subCategoryVM.id()
		titleLabel.text = subCategoryVM.title()
		typeLabel.text = subCategoryVM.type()
		let height = typeLabel.heightNeededForWidth(typeLabel.frame.width)
		//print("typeLabel: \(typeLabel.bounds.width)/\(height) for \(typeLabel.text)")
		if let heightConstraint = typeLabelHeight {
			heightConstraint.constant = height
		}
		updateConstraints()
	}
	
	func configWithTitle(title: String) {
		idLabel.backgroundColor = AppColor.LightBeige.color
		typeIndicator.color = AppColor.LightBeige.color
		idLabel.text = ""
		titleLabel.text = title
		typeLabel.text = "Beer, Cider, Mead and Local"
	}
	
	override func intrinsicContentSize() -> CGSize {
		viewWidth = (viewWidth > 0) ? viewWidth : defaultViewWidth
		let viewHeight = idSize
		
		return CGSize(width: viewWidth, height: viewHeight)
	}
}
