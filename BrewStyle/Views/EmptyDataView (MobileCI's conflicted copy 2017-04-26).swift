//
//  EmptyDataView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/29/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class EmptyDataView: UIView {
	let iconView = UIImageView()
	let titleLabel = UILabel()
	let descLabel = UILabel()
	let activityIndicator = UIActivityIndicatorView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.backgroundColor = UIColor.clearColor()
		
		let container = UIView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = UIColor.clearColor()
		
		self.addSubview(container)
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		container.heightAnchor.constraintEqualToConstant(200).active = true
		
		
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Right
		descLabel.lineBreakMode = .ByWordWrapping
		descLabel.textColor = AppColor.Gray.color
		descLabel.font = AppFonts.body.font
		descLabel.numberOfLines = 0
		container.addSubview(descLabel)
		descLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant:AppMargins.xl.negative).active = true
		descLabel.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor, constant: 0).active = true
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textAlignment = .Center
		titleLabel.lineBreakMode = .ByWordWrapping
		titleLabel.textColor = AppColor.Gray.color
		titleLabel.font = AppFonts.title.font
		container.addSubview(titleLabel)
		titleLabel.bottomAnchor.constraintEqualToAnchor(descLabel.topAnchor, constant:0).active = true
		titleLabel.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor, constant: 0).active = true
		titleLabel.heightAnchor.constraintLessThanOrEqualToConstant(27).active = true
		
		iconView.translatesAutoresizingMaskIntoConstraints = false
		iconView.alpha = 0.25
		container.addSubview(iconView)
		iconView.bottomAnchor.constraintEqualToAnchor(titleLabel.topAnchor, constant: AppMargins.small.negative).active = true
		iconView.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor, constant: 0).active = true
		iconView.widthAnchor.constraintEqualToConstant(100).active = true
		iconView.heightAnchor.constraintEqualToConstant(150).active = true
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.activityIndicatorViewStyle = .WhiteLarge
		activityIndicator.hidesWhenStopped = true
		container.addSubview(activityIndicator)
		activityIndicator.centerXAnchor.constraintEqualToAnchor(iconView.centerXAnchor, constant: 0).active = true
		activityIndicator.centerYAnchor.constraintEqualToAnchor(iconView.centerYAnchor, constant: 0).active = true
		
		
		
		enable()
	}

	

	func configWithCategoryViewModel(categoryVM:BeverageCategoryViewModel) {
		titleLabel.text = categoryVM.title()
		descLabel.text = categoryVM.desc()
		resetViews()
	}
	
	func configWithIcon(icon: UIImage?, title: String?, description: String?) {
		if let newIcon = icon {
			iconView.image = newIcon//.tintWithColor(AppColor.LightGray.color)
		}
		if let newTitle = title {
			titleLabel.text = newTitle
		}
		
		if let newDesc = description {
			descLabel.text = newDesc
		}
		resetViews()
	}
	
	func resetViews() {
		descLabel.sizeToFit()
		self.layoutSubviews()
	}
	
	func enable() {
		iconView.hidden = false
		titleLabel.hidden = false
		descLabel.hidden = false
		activityIndicator.startAnimating()
	}
	
	func disable() {
		iconView.hidden = true
		titleLabel.hidden = true
		descLabel.hidden = true
		activityIndicator.stopAnimating()
	}
	
	func noData() {
		titleLabel.text = "%$#@"
		descLabel.text = "something broke"
		activityIndicator.stopAnimating()
	}
}