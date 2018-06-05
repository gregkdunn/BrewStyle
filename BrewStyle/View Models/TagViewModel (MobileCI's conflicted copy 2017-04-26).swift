//
//  TagViewModel.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/25/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum TagCategories : String {
	case DominantFlavor  = "dominant flavor"
	case Era = "era"
	case StyleFamily = "style family"
	case Region = "region of origin"
	case Fermentation = "fermentation/conditioning"
	case Strength = "strength"
	case Color = "color"
	
	var color : UIColor {
		switch self{
			case DominantFlavor :
					return AppColor.TagBlue.color
			case Era :
					return AppColor.TagGreen.color
			case StyleFamily :
					return AppColor.TagYellow.color
			case Region :
					return AppColor.TagOrange.color
			case Fermentation :
					return AppColor.TagRed.color
			case Strength :
					return AppColor.TagPurple.color
			case Color :
					return AppColor.TagTeal.color
		}
	}
}

struct TagViewModel : Listable {
	let tag : Tag
	
	init (tag: Tag) {
		self.tag = tag
	}
	
	func id () -> String {
		return ""
	}
	
	func title () -> String {
		return tag.name
	}
	
	func desc () -> String {
		return tag.meaning
	}
	
	func categoryName () -> String {
		print(tag.category.name)
		return tag.category.name
	}
	
	func category () -> TagCategories? {
		return TagCategories(rawValue: categoryName())
	}
	
	func color () -> UIColor {
		if let category = category() {
			return category.color
		}
		return AppColor.Black.color
	}
	
	func isEnabledFor (subCategoryVM : BeverageSubCategoryViewModel) -> Bool {
		if subCategoryVM.beverageSubCategory.tags.contains(tag) {
			return true
		}
		return false
		
	}
	
}
