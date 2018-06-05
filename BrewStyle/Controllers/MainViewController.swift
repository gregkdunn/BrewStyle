//
//  MainViewController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 4/26/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

import UIKit

class MainViewController: ENSideMenuNavigationController {
	
	//Welcome
	let modalView = UIView()
	let welcomeView = GradientView()
	let logoView = UIImageView(image: UIImage(named:"welcome"))
	let okButton = UIButton(type: .Custom)
	var welcomeViewTopConstraint : NSLayoutConstraint?
	let springSpeed = 8.0
	let springBounciness = 11.0
	
	required init?(coder decoder: NSCoder) {
	    super.init(coder: decoder)
	}
	
	override init( menuViewController: UIViewController, contentViewController: UIViewController?) {
		super.init(menuViewController: menuViewController, contentViewController: contentViewController)
		commonInit()
	}
		
	func commonInit () {
		sideMenu?.menuWidth = 240
		
		self.hidesBarsOnSwipe = true
		self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationBar.shadowImage = UIImage()
		self.navigationBar.translucent = true
		self.navigationBar.tintColor = AppStyle.NavigationBar[.TintColor]
		DefaultData().testDefaultsVersion()
		
		createAlertView()
		testInfoVersion()
	}
	
	//Mark Intro Alert View
	
	func testInfoVersion() {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		if let localInfoVersion: AnyObject? = defaults.valueForKey(Constants.Notification.InfoVersion) {
			//print("Local info retrieved")
			if(localInfoVersion != nil) {
				//print("Local Info Version: \(localInfoVersion)")
				PFConfig.getConfigInBackgroundWithBlock {
					(config: PFConfig?, error: NSError?) -> Void in
					let version = config?[Constants.Notification.InfoVersion] as? Float
					//print("Cloud Info Version: \(version)")
					if(localInfoVersion as? Float != version) {
						self.displayAlertView()
					}
				}
			} else {
				//print("Local Info Version is nil")
				self.displayAlertView()
				updateInfoVersion()
			}
		}
	}
	
	
	func updateInfoVersion() {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		//update defaults version
		PFConfig.getConfigInBackgroundWithBlock {
			(config: PFConfig?, error: NSError?) -> Void in
			if let version = config?[Constants.Notification.InfoVersion] as? Float {
				//print("Set New Info Version: \(version)")
				defaults.setFloat(version, forKey: Constants.Notification.InfoVersion)
				NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.InfoVersion, object: version)
			}
		}
	}
	
	func createAlertView() {
		modalView.translatesAutoresizingMaskIntoConstraints = false
		modalView.alpha = 0.0
		modalView.backgroundColor = AppColor.Black.color
		modalView.userInteractionEnabled = true
		
		self.view.addSubview(modalView)
		modalView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 0).active = true
		modalView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: 0).active = true
		modalView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 0).active = true
		modalView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: 0).active = true
		
		welcomeView.translatesAutoresizingMaskIntoConstraints = false
		welcomeView.clipsToBounds = true
		welcomeView.layer.cornerRadius = AppMargins.large.margin
		welcomeView.backgroundColor = AppStyle.SubCategoryDetailHeader[.BackgroundColor]
		welcomeView.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.9)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.3)))
		
		self.view.addSubview(welcomeView)
		welcomeViewTopConstraint = welcomeView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: -400)
		if let topConstraint = welcomeViewTopConstraint {
			topConstraint.active = true
		}
		welcomeView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0).active = true
		welcomeView.widthAnchor.constraintEqualToConstant(300).active = true
		welcomeView.heightAnchor.constraintEqualToConstant(300).active = true
		
		logoView.translatesAutoresizingMaskIntoConstraints = false
		logoView.contentMode = .ScaleAspectFit
		logoView.userInteractionEnabled = true
		
		welcomeView.addSubview(logoView)
		logoView.centerYAnchor.constraintEqualToAnchor(welcomeView.centerYAnchor, constant: 0).active = true
		logoView.centerXAnchor.constraintEqualToAnchor(welcomeView.centerXAnchor, constant: 0).active = true
		logoView.widthAnchor.constraintEqualToConstant(230).active = true
		logoView.heightAnchor.constraintEqualToConstant(230).active = true
		
		okButton.translatesAutoresizingMaskIntoConstraints = false
		okButton.setTitleColor(AppColor.Red.color, forState: .Normal)
		
		welcomeView.addSubview(okButton)
		okButton.bottomAnchor.constraintEqualToAnchor(welcomeView.bottomAnchor, constant: AppMargins.large.negative).active = true
		okButton.centerXAnchor.constraintEqualToAnchor(welcomeView.centerXAnchor, constant: 0).active = true
	}
	
	func displayAlertView() {
		
		disableNav()
		
		okButton.setTitle("loading data", forState: .Normal)
		
		let alphaAnimation = POPSpringAnimation()
		alphaAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as! POPAnimatableProperty
		alphaAnimation.toValue = 0.90
		alphaAnimation.name = "modalOpen"
		alphaAnimation.delegate = self
		modalView.pop_addAnimation(alphaAnimation, forKey: alphaAnimation.name)
		
		let constraintAnimation = POPSpringAnimation()
		constraintAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		constraintAnimation.toValue = 100
		constraintAnimation.springBounciness = CGFloat(springBounciness)
		constraintAnimation.springSpeed = CGFloat(springSpeed)
		constraintAnimation.name = "welcomeOpen"
		constraintAnimation.delegate = self
		welcomeViewTopConstraint!.pop_addAnimation(constraintAnimation, forKey: constraintAnimation.name)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableCloseAlertView", name: Constants.Notification.DataUpdated, object: nil)
	}
	
	func enableCloseAlertView() {
		okButton.setTitle("close", forState: .Normal)
		okButton.addTarget(self, action: "closeAlertView", forControlEvents: .TouchUpInside)
		
		let tap = UITapGestureRecognizer()
		tap.addTarget(self, action: "closeAlertView")
		logoView.addGestureRecognizer(tap)
		
		let tap2 = UITapGestureRecognizer()
		tap2.addTarget(self, action: "closeAlertView")
		modalView.addGestureRecognizer(tap2)
		
		NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.Notification.DataUpdated, object: nil)
	}
	
	func closeAlertView() {
		print("close alert view")
		
		enableNav()
		
		let constraintAnimation = POPSpringAnimation()
		constraintAnimation.property = POPAnimatableProperty.propertyWithName(kPOPLayoutConstraintConstant) as! POPAnimatableProperty
		constraintAnimation.toValue = -400
		constraintAnimation.springBounciness = CGFloat(springBounciness)
		constraintAnimation.springSpeed = CGFloat(springSpeed)
		constraintAnimation.name = "welcomeClose"
		constraintAnimation.delegate = self
		welcomeViewTopConstraint!.pop_addAnimation(constraintAnimation, forKey: constraintAnimation.name)
		
		let alphaAnimation = POPBasicAnimation()
		alphaAnimation.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as! POPAnimatableProperty
		alphaAnimation.toValue = 0
		alphaAnimation.duration = 0.3
		alphaAnimation.name = "modalClose"
		alphaAnimation.delegate = self
		modalView.pop_addAnimation(alphaAnimation, forKey: alphaAnimation.name)
	}
	
	
	func enableNav() {
		navigationBar.hidden = false
		hidesBarsOnSwipe = true
		hidesBarsOnTap = true
	}
	
	func disableNav() {
		navigationBar.hidden = true
		hidesBarsOnSwipe = false
		hidesBarsOnTap = false
	}
}

// MARK:  Navigation
extension UINavigationController {

	
	func showMenu() {
		toggleSideMenuView()
	}
	
	func hideController() {
		self.dismissViewControllerAnimated(true) {
			
		}
	}
	
	func showIntroduction (intro : Introductions?) {
		popViewControllerAnimated(false)
		if let currentIntro = intro {
			let controller = IntroductionController(introduction: currentIntro)
			sideMenuController()?.setContentViewController(controller)
			//self.pushViewController(controller, animated: false)
		} else {
			let controller = IntroductionController()
			sideMenuController()?.setContentViewController(controller)
			//self.pushViewController(controller, animated: false)
		}
	}
	
	func showCategoriesList() {
		popViewControllerAnimated(false)
		let controller = BeverageCategoryListingController()
		sideMenuController()?.setContentViewController(controller)
		//self.pushViewController(controller, animated: false)
	}
	
	func showSubCategoryList(categoryVM:BeverageCategoryViewModel?) {
		if let catVM = categoryVM {
			let controller = BeverageSubCategoryListingController(category: catVM)
			//sideMenuController()?.setContentViewController(controller)
			self.pushViewController(controller, animated: true)
		} else {
			popViewControllerAnimated(false)
			let controller = BeverageSubCategoryListingController()
			sideMenuController()?.setContentViewController(controller)
			//self.pushViewController(controller, animated: true)
		}		
	}
	
		func showSubCategoryDetail(subCategoryVM: BeverageSubCategoryViewModel) {
			let controller = BeverageSubCategoryDetailViewController(subCategory: subCategoryVM)
			//sideMenuController()?.setContentViewController(controller)
			self.pushViewController(controller, animated: true)
		}

		func showTagsListForSubCategory(subcategoryVM: BeverageSubCategoryViewModel) {
			let controller = TagListingController(subCategory: subcategoryVM)
			//sideMenuController()?.setContentViewController(controller)
			self.pushViewController(controller, animated: true)
		}
	
	
	func showSRM() {
		popViewControllerAnimated(false)
		let controller = SRMListingController()
		sideMenuController()?.setContentViewController(controller)
		//self.pushViewController(controller, animated: true)
	}
	
		func showSRMDetail(srm : SRM) {
			let controller = SRMDetailController(srm: srm)
			//sideMenuController()?.setContentViewController(controller)
			self.pushViewController(controller, animated: true)
		}
		
	func showTags() {
		popViewControllerAnimated(false)
		let controller = TagGlossaryController()
		sideMenuController()?.setContentViewController(controller)
		//self.pushViewController(controller, animated: true)
	}
	
		func showTagDetail(tagVM: TagViewModel) {
			let controller = TagDetailController(tagVM: tagVM)
			//sideMenuController()?.  setContentViewController(controller)
			self.pushViewController(controller, animated: true)
		}
	
	func showTerms() {
		popViewControllerAnimated(false)
		let controller = TermListingController()
		sideMenuController()?.setContentViewController(controller)
		//self.pushViewController(controller, animated: true)
	}
}
