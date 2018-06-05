//
//  GKDFilter.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/6/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum FilterType : Int {
	case All
	case Beer
	case Cider
	case Mead
		
	var beerTypeEnabled : Bool {
		var isEnabled = false
		switch self {
		case .Beer :
			isEnabled = true
		default :
			isEnabled = false
		}
		return isEnabled
	}
	
	var toDict : NSNumber {
		return NSNumber(integer: self.rawValue)
	}
	
	static var allCases : [FilterType] {
		return [All, Beer, Cider, Mead]
	}
}

enum FilterBeerType : Int {
	case All
	case Classic
	case Specialty
	case Pending
	
	var title : String {
		var title = ""
		switch self {
		case .All :
			title = "All Styles"
		case .Classic :
			title = "Classic Style"
		case .Specialty :
			title = "Specialty-type"
		case .Pending :
			title = "Pending Styles"
		}
		return title.capitalizedString
	}
	
	var toDict : NSNumber {
		return NSNumber(integer: self.rawValue)
	}
	
	static var allCases : [FilterBeerType] {
		return [All, Classic, Specialty, Pending]
	}
}


struct GKDFilter {
	static var sharedInstance = GKDFilter()
	
	var subCategoryKeyword = ""
	
	var subCategoryFilterType : FilterType = .All
	var subCategoryFilterBeerType : FilterBeerType = .All
	let srmAll : (min:Double, max:Double) = (min:0, max: 40)
	var subCategoryFilterSRM : (min:Double, max:Double) = (min:0, max: 40)
	let ibuAll : (min:Double, max:Double) = (min:0, max: 100)
	var subCategoryFilterIBU : (min:Double, max:Double) = (min:0, max: 100)
	let abvAll : (min:Double, max:Double) = (min:0, max: 14)
	var subCategoryFilterABV : (min:Double, max:Double) = (min:0, max: 14)
	
	mutating func resetSubcategoryFilter() {
		subCategoryKeyword = ""
		subCategoryFilterType = .All
		subCategoryFilterBeerType = .All
		subCategoryFilterSRM = srmAll
		subCategoryFilterIBU = ibuAll
		subCategoryFilterABV = abvAll
	}
	
	func displaySubCategoryFilterString () -> String {
		if subCategoryFilterType.beerTypeEnabled {
			return "\(subCategoryFilterType) : \(subCategoryFilterBeerType.title)"
		}
		return "\(subCategoryFilterType)"
		
	}
}
