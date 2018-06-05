//
//  FilterViewController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 5/5/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

import UIKit

class FilterView: UIView {
	let gradientLayer = CAGradientLayer()
	let titleLabel = UILabel()
	
	let filterButton = UIButton()
	let filterTypeView = FilterTypeView()
	let sortButton = UIButton()
	let sortView = SortView()
	
	override init (frame : CGRect) {
		super.init(frame : frame)
		commonInit()
	}
	
	convenience init () {
		self.init(frame:CGRectZero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func commonInit () {
		clipsToBounds = true
		
		self.backgroundColor = AppStyle.CollectionView[.BackgroundColor]

		let topColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(1.0).CGColor as CGColorRef
		let bottomColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(0.0).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.0, 1.0]
		self.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		sortView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(sortView)
		sortView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		sortView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		sortView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		
		sortButton.setImage(UIImage(named:"filter")?.tintWithColor(AppColor.DarkGray.color), forState: .Normal)
		sortButton.addTarget(self, action: "closeFilters", forControlEvents: .TouchUpInside)
		sortButton.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(sortButton)
		sortButton.topAnchor.constraintEqualToAnchor(sortView.topAnchor, constant: AppMargins.large.margin).active = true
		sortButton.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		sortButton.widthAnchor.constraintEqualToConstant(40).active = true
		sortButton.heightAnchor.constraintEqualToConstant(40).active = true
		
		filterTypeView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(filterTypeView)
		filterTypeView.bottomAnchor.constraintEqualToAnchor(sortView.topAnchor, constant: AppMargins.xl.negative).active = true
		filterTypeView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		filterTypeView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		
		filterButton.setImage(UIImage(named:"filter")?.tintWithColor(AppColor.DarkGray.color), forState: .Normal)
		filterButton.addTarget(self, action: "closeFilters", forControlEvents: .TouchUpInside)
		filterButton.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(filterButton)
		filterButton.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: AppMargins.xl.margin).active = true
		filterButton.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		filterButton.widthAnchor.constraintEqualToConstant(40).active = true
		filterButton.heightAnchor.constraintEqualToConstant(40).active = true
	}
	
	// Configure
	
	func configureWithCategory(categoryVM : BeverageCategoryViewModel?) {
		filterTypeView.configureWithCategory(categoryVM)
		sortView.configureWithCategory(categoryVM)
	}
	
	func closeFilters () {
		print("closeFilters")
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.FilterClose, object: self)
	}
}
