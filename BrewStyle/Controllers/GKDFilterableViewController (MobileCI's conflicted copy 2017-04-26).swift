//
//  GKDFilterableViewController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/3/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class GKDFilterableViewController : UIViewController {
	let settingsBtn = UIButton(frame:  CGRectMake(0, 0, 40, 40))
	
	var filterMenuHeight : CGFloat = UIScreen.mainScreen().bounds.height * 0.67
	var sortHeight : CGFloat = 144
	var filterHeight : CGFloat = 453
	var filterMenuContentSize : CGSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 453)
	let offset : CGFloat = -100
	let filterMenu = FilterView()
	
	lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
	let layout = GDCollectionViewLayout()
	let empty = EmptyDataView()
	
	var dataAllLoaded : Bool = false
	var dataLoading : Bool = false
	let dataIncrement = 20
	var dataDisplayed  = 0
	var insertCount = 0
	
	//Filter menu
	let swipeUpGesture = UISwipeGestureRecognizer()
	var collectionViewTopConstraint : NSLayoutConstraint?
	var filterTopConstraint : NSLayoutConstraint?
	var isOpen = false
	var originalX = 0.0
	let springSpeed = 8.0
	let springBounciness = 11.0
	
	//Search
	let searchBar = UISearchBar()
	
	var types : [BeverageType] = []

	
	override func viewDidLoad() {		
		 super.viewDidLoad()
		 createBackground()
		 self.navigationController?.navigationBar.hidden = false
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if(isOpen) {
			closeFilterMenu()
		}
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		
		collectionView.reloadData()
		if(isOpen) {
			closeFilterMenu()
		}		
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
		
	func iconButton(icon: String, target: AnyObject?, action: String) -> UIBarButtonItem {
		let button = UIButton(frame:  CGRectMake(0, 0, 40, 40))
		button.setBackgroundImage(UIImage(named:icon), forState: .Normal)
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		button.layer.cornerRadius = 4
		button.addTarget(target, action: Selector(action), forControlEvents: .TouchUpInside)
		let barButtonItem = UIBarButtonItem(customView: button)
		barButtonItem.imageInsets = UIEdgeInsetsZero
		return barButtonItem
	}
	
	func createBackground() {
		self.view.backgroundColor = AppStyle.CollectionView[.BackgroundColor]
		let bgView = BackgroundView()
		bgView.translatesAutoresizingMaskIntoConstraints = false
		bgView.frame = self.view.bounds
		self.view.addSubview(bgView)
		bgView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 0).active = true
		bgView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: 0).active = true
		bgView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 0).active = true
		bgView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 0).active = true
	}
	
	func createSettingsButton() {		
		navigationItem.leftBarButtonItem = iconButton("star2", target: self.navigationController, action: "toggleSettings")
	}
	
	func configueBackButton() {
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
	}
	
	func createFilterMenu() {
		navigationItem.rightBarButtonItem = iconButton("filter", target: self, action: "toggleFilterMenu")
				
		filterMenu.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(filterMenu)		
		filterTopConstraint = filterMenu.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 0)
		filterTopConstraint!.active = true
		filterMenu.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 0).active = true
		filterMenu.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: 0).active = true
		filterMenu.heightAnchor.constraintEqualToConstant(filterMenuHeight).active = true
		
		adjustConstraints()
		
		swipeUpGesture.addTarget(self, action: "closeFilterMenu")
		swipeUpGesture.direction = [UISwipeGestureRecognizerDirection.Up]
		filterMenu.addGestureRecognizer(swipeUpGesture)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeFilterMenu", name: Constants.Notification.FilterClose, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
	}
	
	func createCollectionView() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.scrollsToTop = true
		self.view.addSubview(collectionView)
		
		collectionViewTopConstraint = collectionView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 0)
		collectionViewTopConstraint!.active = true
		collectionView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 0).active = true
		collectionView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: 0).active = true
		collectionView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 0).active = true
		
		collectionView.backgroundColor = UIColor.clearColor()
		collectionView.collectionViewLayout = self.layout
		collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
				
		empty.frame = collectionView.bounds
		collectionView.backgroundView = empty
	}
	
	func toggleFilterMenu() {
		if isOpen {
			closeFilterMenu()
		} else {
			openFilterMenu()
		}
	}
	
	func tap(img: AnyObject) {
		toggleFilterMenu()
	}
	
	func orientationChanged(notification: NSNotification) {
		adjustConstraints()
	}
	
	func adjustConstraints() {
		let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
		let navHeight = self.navigationController?.navigationBar.bounds.height
		let constant = -(filterMenuHeight - (statusHeight + navHeight!) - offset)
		filterTopConstraint!.constant = constant
	}
	
	
	// OPEN/CLOSE
	
	func closeFilterMenu () {
		if(!isOpen) {
			return
		}
		self.navigationController?.navigationBar.hidden = false
		NSLog("close Filter Menu")
		
		let filterAnimation = POPSpringAnimation()
		filterAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		filterAnimation.toValue = originalX
		filterAnimation.springBounciness = CGFloat(springBounciness)
		filterAnimation.springSpeed = CGFloat(springSpeed)
		filterAnimation.name = "filterClose"
		filterAnimation.delegate = self
		filterTopConstraint!.pop_addAnimation(filterAnimation, forKey: filterAnimation.name)

		let collectionViewAnimation = POPSpringAnimation()
		collectionViewAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		collectionViewAnimation.toValue = 0
		collectionViewAnimation.springBounciness = CGFloat(springBounciness)
		collectionViewAnimation.springSpeed = CGFloat(springSpeed)
		collectionViewAnimation.name = "collectionClose"
		collectionViewAnimation.delegate = self
		collectionViewTopConstraint!.pop_addAnimation(collectionViewAnimation, forKey: collectionViewAnimation.name)
		
		isOpen = false
		collectionView.scrollEnabled = true
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategorySort, object: filterMenu)
		collectionView.removeGestureRecognizer(swipeUpGesture)
	}
	
	func openFilterMenu () {
		if isOpen {
			return
		}
		self.navigationController?.navigationBar.hidden = true
		searchBar.resignFirstResponder()
		
		NSLog("open Filter Menu")
		
		if let constraint = filterTopConstraint {
			originalX = Double(constraint.constant)
		}
		
		let constraintAnimation = POPSpringAnimation()
		constraintAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		constraintAnimation.toValue = 0
		constraintAnimation.springBounciness = CGFloat(springBounciness)
		constraintAnimation.springSpeed = CGFloat(springSpeed)
		constraintAnimation.name = "filterOpen"
		constraintAnimation.delegate = self
		filterTopConstraint!.pop_addAnimation(constraintAnimation, forKey: constraintAnimation.name)
		
		let collectionViewAnimation = POPSpringAnimation()
		collectionViewAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		collectionViewAnimation.toValue = filterMenuHeight -  64
		collectionViewAnimation.springBounciness = CGFloat(springBounciness)
		collectionViewAnimation.springSpeed = CGFloat(springSpeed)
		collectionViewAnimation.name = "collectionOpen"
		collectionViewAnimation.delegate = self
		collectionViewTopConstraint!.pop_addAnimation(collectionViewAnimation, forKey: collectionViewAnimation.name)
		
		isOpen = true
		collectionView.scrollEnabled = false
		filterMenu.addGestureRecognizer(swipeUpGesture)
		collectionView.addGestureRecognizer(swipeUpGesture)
		
		filterMenu.filterTypeView.srmRangeSliderView.frame = filterMenu.filterTypeView.srmRangeSliderView.bounds
		filterMenu.filterTypeView.ibuRangeSliderView.frame = filterMenu.filterTypeView.ibuRangeSliderView.bounds
		filterMenu.filterTypeView.abvRangeSliderView.frame = filterMenu.filterTypeView.abvRangeSliderView.bounds
	}
	
	func openSortMenu () {
		if isOpen {
			return
		}
		
		self.navigationController?.navigationBar.hidden = true
		searchBar.resignFirstResponder()
		
		NSLog("open Filter Menu")
		
		if let constraint = filterTopConstraint {
			originalX = Double(constraint.constant)
		}
		
		let constraintAnimation = POPSpringAnimation()
		constraintAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		constraintAnimation.toValue = -(filterHeight - sortHeight)
		constraintAnimation.springBounciness = CGFloat(springBounciness)
		constraintAnimation.springSpeed = CGFloat(springSpeed)
		constraintAnimation.name = "filterOpen"
		constraintAnimation.delegate = self
		filterTopConstraint!.pop_addAnimation(constraintAnimation, forKey: constraintAnimation.name)
		
		let collectionViewAnimation = POPSpringAnimation()
		collectionViewAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		collectionViewAnimation.toValue = sortHeight - 64
		collectionViewAnimation.springBounciness = CGFloat(springBounciness)
		collectionViewAnimation.springSpeed = CGFloat(springSpeed)
		collectionViewAnimation.name = "collectionOpen"
		collectionViewAnimation.delegate = self
		collectionViewTopConstraint!.pop_addAnimation(collectionViewAnimation, forKey: collectionViewAnimation.name)
		
		isOpen = true
		collectionView.scrollEnabled = false
		filterMenu.addGestureRecognizer(swipeUpGesture)
		collectionView.addGestureRecognizer(swipeUpGesture)
	}
	
	func toggleMenu() {
		if(isOpen) {
			closeFilterMenu()
		} else {
			openFilterMenu()
		}
	}
	
	func toggleSortMenu() {
		if(isOpen) {
			closeFilterMenu()
		} else {
			openSortMenu()
		}
	}
}
