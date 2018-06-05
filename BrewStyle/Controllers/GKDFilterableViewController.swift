//
//  GKDFilterableViewController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/3/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class GKDFilterableViewController : UIViewController, ENSideMenuDelegate {
	let settingsBtn = UIButton(frame:  CGRectMake(0, 0, 40, 40))
	
	var filterMenuHeight : CGFloat = (UIScreen.mainScreen().bounds.height < 472) ? UIScreen.mainScreen().bounds.height : 472
	var sortHeight : CGFloat = 152
	var filterHeight : CGFloat = 472
	var filterMenuContentSize : CGSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 472)
	let offset : CGFloat = -100
	let filterMenu = FilterView()
	
	lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
	let layout = GDCollectionViewLayout()
	let empty = EmptyDataView()
	let refreshControl = UIRefreshControl()
	
	var initializing : Bool = true
	var dataAllLoaded : Bool = false
	var dataLoading : Bool = false
	var dataIncrement : Int {
		if self.traitCollection.horizontalSizeClass == .Regular {
			return 41
		}
		return 20
	}
	var dataDisplayed  = 0
	var insertCount = 0
	
	var currentWidth : CGFloat = UIScreen.mainScreen().bounds.width
	var standardWidth : CGFloat {
		if self.traitCollection.horizontalSizeClass == .Regular {
			//print("class 1/2 :\(self.traitCollection.horizontalSizeClass.rawValue)")
			return currentWidth / 2
		}
		//print("class :\(self.traitCollection.horizontalSizeClass.rawValue)")
		return currentWidth
	}
	
	//Filter menu
	let filterSwipeUpGesture = UISwipeGestureRecognizer()
	let collectionViewSwipeUpGesture = UISwipeGestureRecognizer()
	var collectionViewTopConstraint : NSLayoutConstraint?
	var filterTopConstraint : NSLayoutConstraint?
	var isOpen = false
	var originalX = 0.0
	let springSpeed = 8.0
	let springBounciness = 11.0
	
	//Search
	let searchBar = UISearchBar()
	
	//Welcome
	let modalView = BackgroundView()
	let welcomeView = UIView()
	var welcomeViewTopConstraint : NSLayoutConstraint?
	
	var types : [BeverageType] = []

	
	var reloadWhenVisible = false
	
	override func viewDidLoad() {		
		 super.viewDidLoad()
		 createBackground()
		self.sideMenuController()?.sideMenu?.delegate = self
		
		self.navigationController?.navigationBar.hidden = false
		self.navigationController?.hidesBarsOnSwipe = true
		self.navigationController?.hidesBarsOnTap = true
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"dataUpdated", name:Constants.Notification.DataUpdated, object:nil)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if isOpen {
			closeFilterMenu()
		}
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.hidesBarsOnSwipe = true
		self.navigationController?.hidesBarsOnTap = true
		
		if reloadWhenVisible && !initializing {
			collectionView.reloadData()
		}
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		initializing = false
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		currentWidth = size.width
		if isOnScreen && !initializing {
			reloadData()
		} else {
			reloadWhenVisible = true
		}
		
		if isOpen {
			closeFilterMenu()
		}		
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func dataUpdated() {
		//slight delay because of loading errors
		let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
		dispatch_after(time, dispatch_get_main_queue()) {
			self.reloadData()
		}
	}
	
	func reloadData() {
		//override in subclass
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
		navigationItem.leftBarButtonItem = iconButton("star2", target: self, action: "toggleSettings")
	}
	
	func configueBackButton() {
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
	}
	
	func createSubCategoryFilterMenu() {
		navigationItem.rightBarButtonItem = iconButton("filter", target: self, action: "toggleFilterMenu")
				
		filterMenu.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(filterMenu)		
		filterTopConstraint = filterMenu.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 0)
		filterTopConstraint!.active = true
		filterMenu.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 0).active = true
		filterMenu.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: 0).active = true
		filterMenu.heightAnchor.constraintEqualToConstant(filterMenuHeight).active = true
		
		adjustConstraints()
		
		filterSwipeUpGesture.addTarget(self, action: "closeFilterMenu")
		filterSwipeUpGesture.direction = [UISwipeGestureRecognizerDirection.Up]
		filterMenu.addGestureRecognizer(filterSwipeUpGesture)
		
		collectionViewSwipeUpGesture.addTarget(self, action: "closeFilterMenu")
		collectionViewSwipeUpGesture.direction = [UISwipeGestureRecognizerDirection.Up]
		
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
		collectionView.contentInset = UIEdgeInsets(top: 72, left: 0, bottom: 24, right: 0)
				
		empty.frame = collectionView.bounds
		collectionView.backgroundView = empty
		
		refreshControl.tintColor = AppColor.White.color
		collectionView.addSubview(refreshControl)
		collectionView.alwaysBounceVertical = true
		
	}
	
	func toggleSettings() {	
		toggleSideMenuView()
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
		self.navigationController?.hidesBarsOnSwipe = true
		self.navigationController?.hidesBarsOnTap = true
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
		collectionView.removeGestureRecognizer(collectionViewSwipeUpGesture)
	}
	
	func openFilterMenu () {
		if isOpen {
			return
		}
		self.navigationController?.navigationBar.hidden = true
		self.navigationController?.hidesBarsOnSwipe = false
		self.navigationController?.hidesBarsOnTap = false
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
		collectionViewAnimation.toValue = filterMenuHeight -  74
		collectionViewAnimation.springBounciness = CGFloat(springBounciness)
		collectionViewAnimation.springSpeed = CGFloat(springSpeed)
		collectionViewAnimation.name = "collectionOpen"
		collectionViewAnimation.delegate = self
		collectionViewTopConstraint!.pop_addAnimation(collectionViewAnimation, forKey: collectionViewAnimation.name)
		
		isOpen = true
		collectionView.scrollEnabled = false
		collectionView.addGestureRecognizer(collectionViewSwipeUpGesture)
		
		filterMenu.filterTypeView.srmGKDRangeSliderView.frame = filterMenu.filterTypeView.srmGKDRangeSliderView.bounds
		filterMenu.filterTypeView.ibuGKDRangeSliderView.frame = filterMenu.filterTypeView.ibuGKDRangeSliderView.bounds
		filterMenu.filterTypeView.abvGKDRangeSliderView.frame = filterMenu.filterTypeView.abvGKDRangeSliderView.bounds
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
		collectionViewAnimation.toValue = sortHeight - 98
		collectionViewAnimation.springBounciness = CGFloat(springBounciness)
		collectionViewAnimation.springSpeed = CGFloat(springSpeed)
		collectionViewAnimation.name = "collectionOpen"
		collectionViewAnimation.delegate = self
		collectionViewTopConstraint!.pop_addAnimation(collectionViewAnimation, forKey: collectionViewAnimation.name)
		
		isOpen = true
		collectionView.scrollEnabled = false
		collectionView.addGestureRecognizer(collectionViewSwipeUpGesture)
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

	func toggleSideMenu(sender: AnyObject) {
		toggleSideMenuView()
	}
	
	// MARK: - ENSideMenu Delegate
	func sideMenuWillOpen() {
		filterMenu.userInteractionEnabled = false
		collectionView.userInteractionEnabled = false
		UIView.animateWithDuration(0.1) { () -> Void in
			self.navigationController?.navigationBarHidden = true
			self.collectionView.alpha = 0.5
			self.filterMenu.alpha = 0.5
		}
	}
	
	func sideMenuWillClose() {
		filterMenu.userInteractionEnabled = true
		collectionView.userInteractionEnabled = true
		UIView.animateWithDuration(0.2) { () -> Void in
			self.navigationController?.navigationBarHidden = (self.isOpen) ? true : false
			self.collectionView.alpha = 1.0
			self.filterMenu.alpha = 1.0
		}
	}
	
	func sideMenuShouldOpenSideMenu() -> Bool {
		return true
	}
	
	func sideMenuDidClose() {

	}
	
	func sideMenuDidOpen() {

	}
}

extension UIViewController{
	var isOnScreen: Bool{
		return self.isViewLoaded() && view.window != nil
	}
}
