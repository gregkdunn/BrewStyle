//
//  GKDSort.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/6/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum SortBy : Int {
	case Number
	case Alphabetical
	case SRM
	case IBU
	case OG
	case FG
	case ABV
	
	var btnTitle : String {
		var title = ""
		switch self {
			case .Number :
				title = "id"
			case .Alphabetical :
				title = "a-z"
			case .SRM :
				title = "srm"
			case .IBU :
				title = "ibu"
			case .OG :
				title = "og"
			case .FG :
				title = "fg"
			case .ABV :
				title = "abv"
		}
		return title
	}
	
	var title : String {
		return btnTitle.uppercaseString
	}

	var minMaxEnabled : Bool {
		var isEnabled = true
		switch self {
		case .Number  :
			isEnabled = false
		case .Alphabetical :
			isEnabled = false
		default :
			isEnabled = true
		}
		return isEnabled
	}
	
	var toDict : NSNumber {
		return NSNumber(integer: self.rawValue)
	}
	
	static var allCases : [SortBy] {
		return [Number, Alphabetical, SRM, IBU, OG, FG, ABV]
	}
	
	static var beer : [Bool] {
		return [true, true, true, true, true, true, true]
	}
	
	static var cider : [Bool] {
		return [true, true, false, false, true, true, true]
	}
	
	static var mead : [Bool] {
		return [true, true, false, false, true, true, true]
	}
	
	static func enableFieldsForCategory(categoryVM: BeverageCategoryViewModel?) -> [Bool]{
		var cases = SortBy.beer
		
		if let catVM = categoryVM {
			if catVM.isCider() {
				cases = SortBy.cider
			}
			
			if catVM.isMead() {
				cases = SortBy.mead
			}
		}
		return cases
	}
}

enum SortMinMax : Int{
	case Min
	case Max
	
	var btnTitle : String {
		var title = ""
		switch self {
		case .Min :
			title = "min"
		case .Max :
			title = "max"
		}
		return title
	}
	
	var title : String {
		var title = ""
		switch self {
		case .Min :
			title = "minimum"
		case .Max :
			title = "maximum"
		}
		return title.capitalizedString
	}
	
	static var allCases : [SortMinMax] {
		return [Min, Max]
	}
	
	var toDict : NSNumber {
		return NSNumber(integer: self.rawValue)
	}
}

enum SortOrder : Int{
	case Ascending
	case Descending
	
	var toDict : NSNumber {
		return NSNumber(integer: self.rawValue)
	}
}

struct GKDSort {
	static var sharedInstance = GKDSort()
	var categorySortBy : SortBy = .Number
	var categorySortOrder : SortOrder = .Ascending
	var subCategorySortBy : SortBy = .Number
	var subCategorySortMinMax : SortMinMax = .Min
	var subCategorySortOrder : SortOrder = .Ascending
	
	
	mutating func resetSort() {
		resetCategorySort()
		resetSubcategorySort()
	}
	
	mutating func resetCategorySort() {
		categorySortBy = .Number
		categorySortOrder = .Ascending
	}
	
	mutating func resetSubcategorySort() {
		subCategorySortBy = .Number
		subCategorySortMinMax = .Min
		subCategorySortOrder = .Ascending
	}
	
	func displayCategorySortString () -> String {
		return "\(categorySortOrder) by \(categorySortBy.btnTitle)"
	}
	
	func displaySubCategorySortString () -> String {
		if subCategorySortBy.minMaxEnabled {
			return "\(subCategorySortOrder) by \(subCategorySortMinMax.title) \(subCategorySortBy.title)"
		}
		return "\(subCategorySortOrder) by \(subCategorySortBy.title)"

	}
}
