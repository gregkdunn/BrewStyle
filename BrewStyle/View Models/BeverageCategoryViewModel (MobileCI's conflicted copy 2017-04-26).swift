//
//  BeverageCategoryViewModel.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/10/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//



struct BeverageCategoryViewModel : Listable {
	let beverageCategory : BeverageCategory
	
	init(category: BeverageCategory) {
		self.beverageCategory = category
	}
	
	func id () -> String {
		return beverageCategory.displayId
	}
	
	func title () -> String {
		return beverageCategory.name
	}

	func desc () -> String {
		return beverageCategory.desc
	}
	
	func heightForDesc ()-> CGFloat {
		return 250.0
	}
	
	func icon() -> UIImage? {
		let type = beverageCategory.type.name
		if type.containsString("beer") {
			return UIImage(named: "hop_cone")
		}
		if type.containsString("cider") {
			return UIImage(named: "apple")
		}
		
		return UIImage(named:"beehive")
	}
	
	func typeIndicatorColor() -> UIColor {
		if isLocalStyleBeer() {
			return AppColor.Purple.color
		}
		if isClassicBeer() {
			return AppColor.Blue.color
		}
		if isSpecialtyBeer() {
			return AppColor.Brown.color
		}
		if isCider() {
			return AppColor.Red.color
		}
		if isMead() {
			return AppColor.BrightYellow.color
		}
		return AppColor.Gray.color
	}
	
	func type () -> String {
		return beverageCategory.type.name.capitalizedString
	}
	
	//type
	
	func isBeer() -> Bool {
		if beverageCategory.type.name.containsString("beer") {
			return true
		}
		return false
	}
	
	func isClassicBeer() -> Bool {
		if beverageCategory.type.name.containsString("classic style beer") {
			return true
		}
		return false
	}
	
	func isSpecialtyBeer() -> Bool {
		if beverageCategory.type.name.containsString("specialty-type beer") {
			return true
		}
		return false
	}
	
	func isLocalStyleBeer() -> Bool {
		if beverageCategory.type.name.containsString("pending") {
			return true
		}
		return false
	}
	
	func isCider() -> Bool {
		if beverageCategory.type.name.containsString("cider") {
			return true
		}
		return false
	}
	
	func isMead() -> Bool {
		if beverageCategory.type.name.containsString("mead") {
			return true
		}
		return false
	}

	
}
