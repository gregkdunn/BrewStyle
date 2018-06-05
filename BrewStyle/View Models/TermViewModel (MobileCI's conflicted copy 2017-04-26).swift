//
//  TermViewModel.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/29/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum TermCategories : String {
	case Appearance = "Appearance"
	case Quality = "Quality or Off-Flavor"
	case Yeast = "Yeast or Fermentation"
	case Malt = "Malt or Mashing"
	case Hop = "Hop"
	
	var color : UIColor {
		switch self{
		case .Appearance :
			return AppColor.TagBrown.color
		case .Quality :
			return AppColor.TagRed.color
		case .Yeast :
			return AppColor.TagYellow.color
		case .Malt :
			return AppColor.TagOrange.color
		case .Hop :
			return AppColor.TagGreen.color
		}
	}
}

struct TermViewModel : Listable {
	let term : Term
	
	init(term: Term) {
		self.term = term
	}
	
	func id () -> String {
		return ""
	}
	
	func title () -> String {
		return term.name
	}
	
	func desc () -> String {
		return term.meaning
	}
	
	func categoryName () -> String {
		print(term.category.name)
		return term.category.name
	}
	
	func category () -> TermCategories? {
		return TermCategories(rawValue: categoryName())
	}
	
	func color () -> UIColor {
		if let category = category() {
			return category.color
		}
		return AppColor.Black.color
	}

}