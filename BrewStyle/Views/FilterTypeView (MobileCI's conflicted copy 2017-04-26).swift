//
//  FilterTypeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/14/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

//
//  SortView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/6/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class FilterTypeView : UIView {
	let filterTitle = TitleView()
	let filterTypeControl = UISegmentedControl()
	let filterBeerTypeControl = UISegmentedControl()
	let srmRangeSliderView = SRMRangeSliderView()
	let ibuRangeSliderView = IBURangeSliderView()
	let abvRangeSliderView = ABVRangeSliderView()
	
	var type : FilterType = .All {
		didSet {
			enableBeerType()
		}
	}
	var beerType : FilterBeerType = .All
	
	
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
	
	func commonInit (){
		backgroundColor = UIColor.clearColor()
		createSegments()
		initSelectedSegments()
		enableBeerType()
		
		filterTitle.translatesAutoresizingMaskIntoConstraints = false
		filterTitle.backgroundColor = UIColor.clearColor()
		filterTitle.configWithTitle("filter", category: nil)
		self.addSubview(filterTitle)
		filterTitle.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: AppMargins.large.margin).active = true
		filterTitle.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		filterTitle.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		filterTitle.heightAnchor.constraintEqualToConstant(40).active = true
		
		filterTypeControl.tintColor = AppColor.Black.color
		filterTypeControl.translatesAutoresizingMaskIntoConstraints = false
		filterTypeControl.addTarget(self, action: "sortByUpdate:", forControlEvents: .ValueChanged)
		self.addSubview(filterTypeControl)
		filterTypeControl.topAnchor.constraintEqualToAnchor(filterTitle.bottomAnchor, constant: AppMargins.large.margin).active = true
		filterTypeControl.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.xl.margin).active = true
		filterTypeControl.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.large.negative).active = true
		filterTypeControl.heightAnchor.constraintEqualToConstant(40).active = true
		
		filterBeerTypeControl.tintColor = AppColor.Black.color
		filterBeerTypeControl.translatesAutoresizingMaskIntoConstraints = false
		filterBeerTypeControl.addTarget(self, action: "sortMinMaxUpdate:", forControlEvents: .ValueChanged)
		/*
		self.addSubview(filterBeerTypeControl)
		filterBeerTypeControl.topAnchor.constraintEqualToAnchor(filterTypeControl.bottomAnchor, constant: AppMargins.medium.margin).active = true
		filterBeerTypeControl.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.small.margin).active = true
		filterBeerTypeControl.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.small.negative).active = true
		filterBeerTypeControl.heightAnchor.constraintEqualToConstant(40).active = true
		*/
		
		
		srmRangeSliderView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(srmRangeSliderView)
		srmRangeSliderView.topAnchor.constraintEqualToAnchor(filterTypeControl.bottomAnchor, constant: AppMargins.large.margin).active = true
		srmRangeSliderView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.xl.margin).active = true
		srmRangeSliderView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.large.negative).active = true
		srmRangeSliderView.heightAnchor.constraintEqualToConstant(ibuRangeSliderView.intrinsicContentSize().height).active = true
		
		ibuRangeSliderView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(ibuRangeSliderView)
		ibuRangeSliderView.topAnchor.constraintEqualToAnchor(srmRangeSliderView.bottomAnchor, constant: AppMargins.xl.margin).active = true
		ibuRangeSliderView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.xl.margin).active = true
		ibuRangeSliderView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.large.negative).active = true
		ibuRangeSliderView.heightAnchor.constraintEqualToConstant(ibuRangeSliderView.intrinsicContentSize().height).active = true
		
		abvRangeSliderView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(abvRangeSliderView)
		abvRangeSliderView.topAnchor.constraintEqualToAnchor(ibuRangeSliderView.bottomAnchor, constant: AppMargins.xl.margin).active = true
		abvRangeSliderView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.xl.margin).active = true
		abvRangeSliderView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.large.negative).active = true
		abvRangeSliderView.heightAnchor.constraintEqualToConstant(abvRangeSliderView.intrinsicContentSize().height).active = true
	}
	
	//SegmentedControl
	func createSegments() {
		var index = 0
		for field in FilterType.allCases {
			filterTypeControl.insertSegmentWithTitle("\(field)".lowercaseString, atIndex: index, animated: false)
			index++
		}
		for field in FilterBeerType.allCases {
			filterBeerTypeControl.insertSegmentWithTitle("\(field)".lowercaseString, atIndex: index, animated: false)
			index++
		}
		
	}
	
	func initSelectedSegments () {
		filterTypeControl.selectedSegmentIndex = type.rawValue
		filterBeerTypeControl.selectedSegmentIndex = beerType.rawValue
	}
	
	func enableBeerType() {
		if type.beerTypeEnabled {
			filterBeerTypeControl.enabled = true
		} else {
			filterBeerTypeControl.enabled = false
		}
	}
	
	//Actions
	func sortByUpdate(sender:UISegmentedControl) {
		if let newType = FilterType(rawValue: sender.selectedSegmentIndex) {
			type = newType
			GKDFilter.sharedInstance.subCategoryFilterType = type
			configureWithType(type)
			NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategoryFilterType, object: self, userInfo: ["type": type.toDict] )
			filterBeerTypeControl.enabled = (type.beerTypeEnabled)
		}
		
		print("filter Type: \(type)")
	}
	
	func sortMinMaxUpdate(sender:UISegmentedControl) {
		if let newBeerType = FilterBeerType(rawValue: sender.selectedSegmentIndex) {
			beerType = newBeerType
			GKDFilter.sharedInstance.subCategoryFilterBeerType = beerType
			NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategoryFilterBeerType, object: self, userInfo: ["beerType": beerType.toDict] )
		}
		
		print("filter BeerType: \(beerType)")
	}
	
	override func intrinsicContentSize() -> CGSize {
		let height = AppMargins.xl.margin + 40 + AppMargins.xl.margin + ibuRangeSliderView.intrinsicContentSize().height + AppMargins.xl.margin + srmRangeSliderView.intrinsicContentSize().height + AppMargins.xl.margin + abvRangeSliderView.intrinsicContentSize().height  + AppMargins.xl.margin + AppMargins.xl.margin
		return CGSize(width: 360 , height: height)
	}
	
	// Config
	func configureWithCategory(categoryVM : BeverageCategoryViewModel?) {
		if let cat = categoryVM {
			filterTypeControl.enabled = false
			if cat.isMead() || cat.isCider() {
				srmRangeSliderView.enable = false
				ibuRangeSliderView.enable = false
			}
		}
	}
	
	func configureWithType(type : FilterType ) {
		if type == .Cider || type == .Mead {
			srmRangeSliderView.enable = false
			ibuRangeSliderView.enable = false
		} else {
			srmRangeSliderView.enable = true
			ibuRangeSliderView.enable = true
		}
	}
}