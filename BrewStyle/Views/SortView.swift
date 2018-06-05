//
//  SortView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/6/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SortView : UIView {
	let sortTitle = TitleView()
	let sortByControl = UISegmentedControl()
	let sortMinMaxControl = UISegmentedControl()
	let sortButton = UIButton()
	
	let ascImage = UIImage(named: "sort_asc")
	let desImage = UIImage(named: "sort_dec")
	let touchImage = UIImage(named: "sort_mid")
	var by : SortBy = .Number {
		didSet {
			enableMinMax()
		}
	}
	var minMax : SortMinMax = .Min
	var order : SortOrder = .Ascending {
		didSet {
			setButtonImage()
		}
	}
	
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
		backgroundColor = AppColor.White.alpha(0.5)
		
		sortTitle.translatesAutoresizingMaskIntoConstraints = false
		sortTitle.backgroundColor = UIColor.clearColor()
		sortTitle.configWithTitle("sort", category: nil)
		self.addSubview(sortTitle)
		sortTitle.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		sortTitle.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		sortTitle.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		sortTitle.heightAnchor.constraintEqualToConstant(40).active = true

		createSegments()
		initSelectedSegments()
		sortByControl.tintColor = AppColor.Black.color
		sortByControl.translatesAutoresizingMaskIntoConstraints = false
		sortByControl.addTarget(self, action: "sortByUpdate:", forControlEvents: .ValueChanged)
		self.addSubview(sortByControl)
		sortByControl.topAnchor.constraintEqualToAnchor(sortTitle.bottomAnchor, constant: AppMargins.large.margin).active = true
		sortByControl.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.xl.margin).active = true
		sortByControl.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.xl.doubleNegative + AppMargins.xl.negative + AppMargins.large.negative).active = true
		sortByControl.heightAnchor.constraintEqualToConstant(32).active = true
		
		sortMinMaxControl.tintColor = AppColor.Black.color
		sortMinMaxControl.enabled = false
		sortMinMaxControl.translatesAutoresizingMaskIntoConstraints = false
		sortMinMaxControl.addTarget(self, action: "sortMinMaxUpdate:", forControlEvents: .ValueChanged)
		self.addSubview(sortMinMaxControl)
		sortMinMaxControl.topAnchor.constraintEqualToAnchor(sortTitle.bottomAnchor, constant: AppMargins.large.margin).active = true
		sortMinMaxControl.leadingAnchor.constraintEqualToAnchor(sortByControl.trailingAnchor, constant: AppMargins.small.margin).active = true
		sortMinMaxControl.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.large.negative).active = true
		sortMinMaxControl.heightAnchor.constraintEqualToConstant(32).active = true
		
		setButtonImage()
		sortButton.setImage(touchImage, forState: .Highlighted)
		sortButton.addTarget(self, action: "sortOrderUpdate", forControlEvents: .TouchUpInside)
		sortButton.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(sortButton)
		sortButton.bottomAnchor.constraintEqualToAnchor(sortTitle.bottomAnchor, constant: 4).active = true
		sortButton.centerXAnchor.constraintEqualToAnchor(sortTitle.centerXAnchor, constant:0).active = true
		sortButton.widthAnchor.constraintEqualToAnchor(sortByControl.heightAnchor, constant: 0).active = true
		sortButton.heightAnchor.constraintEqualToAnchor(sortByControl.heightAnchor, constant: 0).active = true
				
	}
	
	//SegmentedControl
	func createSegments() {
		var index = 0
		for field in SortBy.allCases {
			sortByControl.insertSegmentWithTitle(field.btnTitle, atIndex: index, animated: false)
			index++
		}
		for field in SortMinMax.allCases {
			sortMinMaxControl.insertSegmentWithTitle(field.btnTitle, atIndex: index, animated: false)
			index++
		}
		
	}

	func initSelectedSegments () {
		sortByControl.selectedSegmentIndex = by.rawValue
		sortMinMaxControl.selectedSegmentIndex = minMax.rawValue
	}
	
	func enableMinMax() {
		if by.minMaxEnabled {
			sortMinMaxControl.enabled = true
		} else {
			sortMinMaxControl.enabled = false
		}
	}
	
	
	//Button
	func setButtonImage() {
		let buttonImage = (order == .Ascending) ? ascImage : desImage
		sortButton.setImage(buttonImage, forState: .Normal)
		
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategorySortOrder, object: self, userInfo: ["order": order.toDict] )
	}
	
	func toggleButton() {
		order = (order == .Ascending) ? .Descending : .Ascending
	}

	
	//Actions
	func sortByUpdate(sender:UISegmentedControl) {
		if let newBy = SortBy(rawValue: sender.selectedSegmentIndex) {
			by = newBy
			GKDSort.sharedInstance.subCategorySortBy = by
			NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategorySortBy, object: self, userInfo: ["by": by.toDict] )
			sortMinMaxControl.enabled = (by.minMaxEnabled)
		}
		
		//print("sort By: \(by)")
	}

	func sortMinMaxUpdate(sender:UISegmentedControl) {
		if let newMinMax = SortMinMax(rawValue: sender.selectedSegmentIndex) {
			minMax = newMinMax
			GKDSort.sharedInstance.subCategorySortMinMax = minMax
			NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategorySortMinMax, object: self, userInfo: ["minMax": minMax.toDict] )
		}
		
		//print("sort MinMax: \(minMax)")
	}
	
	func sortOrderUpdate() {
		toggleButton()
		GKDSort.sharedInstance.subCategorySortOrder = order
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategorySortOrder, object: self, userInfo: ["order": order.toDict] )

		//print("sort Order: \(order)")
		
	}
	
	override func intrinsicContentSize() -> CGSize {
		let height = 40 + AppMargins.large.margin + 40 + AppMargins.xl.margin
		return CGSize(width: 360 , height: height)
	}
	
	// Config
	func configureWithCategory(categoryVM : BeverageCategoryViewModel?) {
		let fields : [Bool] = SortBy.enableFieldsForCategory(categoryVM)
		enableFieldsFor(fields)
		setCurrentSubCategorySort()
	}
	
	func setCurrentSubCategorySort() {
		by = GKDSort.sharedInstance.subCategorySortBy
		minMax = GKDSort.sharedInstance.subCategorySortMinMax
		order = GKDSort.sharedInstance.subCategorySortOrder
	}
	
	func enableFieldsFor(fields : [Bool]) {
		var i = 0
		
		for field in fields {
			sortByControl.setEnabled(field, forSegmentAtIndex: i)
			i++
		}
	}
}