//
//  BeverageRangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/19/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class BeverageRangeView : UIView {
	let srmRangeView = SRMRangeView()
	let ibuRangeView = IBURangeView()
	let abvRangeView = ABVRangeView()
	let gravityRangeView = GravityRangeView()
	
	var subCategoryVM: BeverageSubCategoryViewModel?
	var viewWidth : CGFloat = 0
	let defaultViewWidth : CGFloat = 360
	
	var defaultValueText = "varies"
	
	init() {
		super.init(frame: CGRectZero)
		createRanges()
	}
	
	convenience init(subCategoryVM:BeverageSubCategoryViewModel) {
		self.init()
		self.subCategoryVM = subCategoryVM
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func createRanges() {
		self.clipsToBounds = false
		self.backgroundColor = UIColor.clearColor()
		
		let container = UIView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = UIColor.clearColor()
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.small.negative).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.small.negative).active = true
		
		
		ibuRangeView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(ibuRangeView)
		ibuRangeView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		ibuRangeView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		ibuRangeView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		ibuRangeView.heightAnchor.constraintEqualToConstant(ibuRangeView.intrinsicContentSize().height).active = true

		srmRangeView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(srmRangeView)
		srmRangeView.topAnchor.constraintEqualToAnchor(ibuRangeView.bottomAnchor, constant: AppMargins.large.double).active = true
		srmRangeView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		srmRangeView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		srmRangeView.heightAnchor.constraintEqualToConstant(srmRangeView.intrinsicContentSize().height).active = true
		
		gravityRangeView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(gravityRangeView)
		gravityRangeView.topAnchor.constraintEqualToAnchor(srmRangeView.bottomAnchor, constant: AppMargins.large.double).active = true
		gravityRangeView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		gravityRangeView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		gravityRangeView.heightAnchor.constraintEqualToConstant(gravityRangeView.intrinsicContentSize().height).active = true
	
		abvRangeView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(abvRangeView)
		abvRangeView.topAnchor.constraintEqualToAnchor(gravityRangeView.bottomAnchor, constant: AppMargins.large.double).active = true
		abvRangeView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		abvRangeView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		abvRangeView.heightAnchor.constraintEqualToConstant(abvRangeView.intrinsicContentSize().height).active = true
	}
	
	func clearData() {
		disableRangeView(srmRangeView)
		disableRangeView(ibuRangeView)
		disableRangeView(abvRangeView)
		disableRangeView(gravityRangeView)
	}
	
	func disableRangeView(rangeView: RangeView) {
		rangeView.disable()
	}
	
	func enableRangeView(rangeView: RangeView) {
		rangeView.defaultValueText = defaultValueText
		rangeView.enable()
	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		self.subCategoryVM = subCategoryVM
		
		if subCategoryVM.shouldDisplaySRM(){
			enableRangeView(srmRangeView)
			srmRangeView.range = (min:subCategoryVM.beverageSubCategory.srmMin, max:subCategoryVM.beverageSubCategory.srmMax)
		} else {
			disableRangeView(srmRangeView)
		}
		
		if subCategoryVM.shouldDisplayIBU(){
			enableRangeView(ibuRangeView)
			ibuRangeView.range = (min:Double(subCategoryVM.beverageSubCategory.ibuMin), max:Double(subCategoryVM.beverageSubCategory.ibuMax))
		} else {
			disableRangeView(ibuRangeView)
		}
		
		if subCategoryVM.shouldDisplayABV(){
			enableRangeView(abvRangeView)
			abvRangeView.range = (min:subCategoryVM.beverageSubCategory.abvMin, max:subCategoryVM.beverageSubCategory.abvMax)
		} else {
			disableRangeView(abvRangeView)
		}
		
		if subCategoryVM.shouldDisplayGravity() {
			enableRangeView(gravityRangeView)
			gravityRangeView.ogRange = (min:subCategoryVM.beverageSubCategory.ogMin, max:subCategoryVM.beverageSubCategory.ogMax)
			gravityRangeView.fgRange = (min:subCategoryVM.beverageSubCategory.fgMin, max:subCategoryVM.beverageSubCategory.fgMax)
			gravityRangeView.createRange()
		} else {
			disableRangeView(gravityRangeView)
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		viewWidth = (viewWidth > 0) ? viewWidth : defaultViewWidth
		var viewHeight : CGFloat = 0
		
		if let _ = subCategoryVM {
				viewHeight += AppMargins.large.double + srmRangeView.intrinsicContentSize().height
				viewHeight += AppMargins.large.double + ibuRangeView.intrinsicContentSize().height
				viewHeight += AppMargins.large.double + abvRangeView.intrinsicContentSize().height
				viewHeight += AppMargins.large.double + gravityRangeView.intrinsicContentSize().height
		}
		
		return CGSize(width: viewWidth, height: viewHeight)
	}
	
}
