//
//  MainViewController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 4/26/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {

	let filterMenu : FilterView = FilterView()
	var isOpen = false
	
	required init?(coder decoder: NSCoder) {
	    super.init(coder: decoder)
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		self.commonInit()
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	func commonInit () {
		self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationBar.shadowImage = UIImage()
		self.navigationBar.translucent = true
		self.navigationBar.tintColor = AppStyle.NavigationBar[.TintColor]
		DefaultData().testDefaultsVersion()
	}
	
	func toggleSettings() {
		print("toggleSettings")
		if(isOpen) {
			hideController()
		} else {
			showMenu()
		}
	}
}

// MARK:  Navigation
extension UINavigationController {

	
	func showMenu() {
		let controller = MenuController()
		controller.navController = self as? MainViewController
		self.modalPresentationStyle = .FormSheet
		self.modalTransitionStyle = .PartialCurl
		//This will be the size you want
		controller.preferredContentSize = CGSize(width:220, height:220)
		self.presentViewController(controller, animated: true) {
			
		}
	}
	
	func showSearch() {
		let controller = SearchController()
		controller.navController = self as? MainViewController
		self.modalPresentationStyle = .CurrentContext
		self.presentViewController(controller, animated: true) {
			
		}
	}

	func hideController() {
		self.dismissViewControllerAnimated(true) {
			
		}
	}
	
	func showIntroduction (intro : Introductions?) {
		popViewControllerAnimated(false)
		if let currentIntro = intro {
			let controller = IntroductionController(introduction: currentIntro)
			self.pushViewController(controller, animated: false)
		} else {
			let controller = IntroductionController()
			self.pushViewController(controller, animated: false)
		}
	}
	
	func showCategoriesList() {
		popViewControllerAnimated(false)
		let controller = BeverageCategoryListingController()
		self.pushViewController(controller, animated: false)
	}
	
	func showSubCategoryList(categoryVM:BeverageCategoryViewModel?) {
		if let catVM = categoryVM {
			let controller = BeverageSubCategoryListingController(category: catVM)
			self.pushViewController(controller, animated: true)
		} else {
			popViewControllerAnimated(false)
			let controller = BeverageSubCategoryListingController()
			self.pushViewController(controller, animated: true)
		}		
	}
	
		func showSubCategoryDetail(subCategoryVM: BeverageSubCategoryViewModel) {
			let controller = BeverageSubCategoryDetailViewController(subCategory: subCategoryVM)
			self.pushViewController(controller, animated: true)
		}

		func showTagsListForSubCategory(subcategoryVM: BeverageSubCategoryViewModel) {
			let controller = TagListingController(subCategory: subcategoryVM)
			self.pushViewController(controller, animated: true)
		}
	
	
	func showSRM() {
		popViewControllerAnimated(false)
		let controller = SRMListingController()
		self.pushViewController(controller, animated: true)
	}
	
		func showSRMDetail(srm : SRM) {
			let controller = SRMDetailController(srm: srm)
			self.pushViewController(controller, animated: true)
		}
		
	func showTags() {
		popViewControllerAnimated(false)
		let controller = TagGlossaryController()
		self.pushViewController(controller, animated: true)
	}
	
		func showTagDetail(tagVM: TagViewModel) {
			let controller = TagDetailController(tagVM: tagVM)
			self.pushViewController(controller, animated: true)
		}
	
	func showTerms() {
		popViewControllerAnimated(false)
		let controller = TermListingController()
		self.pushViewController(controller, animated: true)
	}

	
}
