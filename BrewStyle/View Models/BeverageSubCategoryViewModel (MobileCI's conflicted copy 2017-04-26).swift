//
//  BeverageSubCategoryViewModel.swift
//  BrewStyle
//
//  Created by Greg Dunn on 8/28/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

struct BeverageSubCategoryViewModel : Listable {
	
	let beverageSubCategory : BeverageSubCategory
	var portraitSize : CGSize = CGSizeZero
	var landscapeSize : CGSize = CGSizeZero
	
	init(subcategory: BeverageSubCategory) {
		self.beverageSubCategory = subcategory
	}
	
	//listing
	
	func id () -> String {
		let idStr = beverageSubCategory.displayId
		
		if idStr.containsString(".") {
			return idStr.substringToIndex(idStr.endIndex.advancedBy(-2)) + "*"
		}
		
		return idStr
	}
	
	func title () -> String {
		return beverageSubCategory.name
	}
	
	func desc () -> String {
		var desc = ""
		if hasDesc() {
			desc = beverageSubCategory.desc + "\n\n"
		}
		
		if isCider() || isMead() {
			return desc + beverageSubCategory.overallImpression
		} else {	
			if isBeer() && !shouldDisplaySRM(){
				return desc + beverageSubCategory.entryInstructions
			} else {
				return desc + beverageSubCategory.overallImpression
			}
		}
	}
	
	func srmMin () -> SRM? {
		return beverageSubCategory.srmMinModel
	}
	
	func srmMax () -> SRM? {
		return beverageSubCategory.srmMaxModel
	}
	
	func ibuRange () -> String {
		return "\(beverageSubCategory.ibuMin) - \(beverageSubCategory.ibuMax)"
	}
	
	func ogRange () -> String {
		return "\(String(format:"%.3f",beverageSubCategory.ogMin)) - \(String(format:"%.3f",beverageSubCategory.ogMax))"
	}
	
	func fgRange () -> String {
		return "\(String(format:"%.3f",beverageSubCategory.fgMin)) - \(String(format:"%.3f",beverageSubCategory.fgMax))"
	}
	
	func abvRange () -> String {
		return "\(String(format:"%.1f",beverageSubCategory.abvMin)) - \(String(format:"%.1f",beverageSubCategory.abvMax))"
	}
	
	//listing - colors 
	
	func idBackgroundColor() -> UIColor {
		if beverageSubCategory.displayId.containsString(".") {
			return AppStyle.Id[.IdDisabledColor]!
		} else {
			return AppStyle.Id[.IdColor]!
		}
	}
	
	func idTextColor() -> UIColor {
		return AppColor.Black.color
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
	
	//detail
	
	func nameTitle() -> String {
		return "Name"
	}

	func descriptionTitle() -> String {
		return "Description"
	}

	func RangesTitle() -> String {
		return "Vital Statistics"
	}
	
	func overallImpressionTitle() -> String {
		return "Overall Impression"
	}

	func aromaTitle() -> String {
		return "Aroma"
	}

	func appearanceTitle() -> String {
		return "Appearance"
	}

	func flavorTitle() -> String {
		return "Flavor"
	}

	func mouthfeelTitle() -> String {
		return "Mouthfeel"
	}

	func commentsTitle() -> String {
		return "Comments"
	}

	func historyTitle() -> String {
		return "History"
	}

	func characteristicIngredientsTitle() -> String {
		return "Characteristic Ingredients"
	}

	func styleComparisonTitle() -> String {
		return "Style Comparison"
	}

	func entryInstructionsTitle() -> String {
		return "Entry Instructions"
	}

	func varietiesTitle() -> String {
		return "Varieties"
	}

	func vitalStatisticsTitle() -> String {
		return "Vital Statistics"
	}

	func classificationsTitle() -> String {
		return "Classifications"
	}

	func commercialExamplesTitle() -> String {
		return "Commercial Examples"
	}

	func tagsTitle () -> String {
		return "Tags"
	}


	func name () -> String {
		return defaultValue(beverageSubCategory.name)
	}

	func type () -> String {
		var type = beverageSubCategory.category.type.name.capitalizedString
		type = type + " > " + beverageSubCategory.category.name
		if(hasParent()) {
			if let parent = beverageSubCategory.parentSubCategory {
			  type = type + " > " + parent.name
			}
		}
		
		return type
	}
	
	func description () -> String {
		return beverageSubCategory.desc
	}

	func overallImpression () -> String {
		return defaultValue(beverageSubCategory.overallImpression)
	}

	func aroma () -> String {
		return defaultValue(beverageSubCategory.aroma)
	}

	func appearance () -> String {
		return defaultValue(beverageSubCategory.appearance)
	}

	func flavor () -> String {
		return defaultValue(beverageSubCategory.flavor)
	}

	func mouthfeel () -> String {
		return defaultValue(beverageSubCategory.mouthfeel)
	}

	func comments () -> String {
		return defaultValue(beverageSubCategory.comments)
	}

	func history () -> String {
		return defaultValue(beverageSubCategory.history)
	}

	func characteristicIngredients () -> String {
		return defaultValue(beverageSubCategory.characteristicIngredients)
	}

	func styleComparison () -> String {
		return defaultValue(beverageSubCategory.styleComparison)
	}

	func entryInstructions () -> String {
		return defaultValue(beverageSubCategory.entryInstructions)
	}

	func varieties () -> String {
		return defaultValue(beverageSubCategory.varieties)
	}

	func vitalStatistics () -> String {
		return beverageSubCategory.vitalStatistics
	}

	func classifications () -> String {
		return defaultValue(beverageSubCategory.classifications)
	}
	
	func commercialExamples () -> String {
		let beerStr = beverageSubCategory.commercialExamples.map{String($0.name)}.joinWithSeparator("\n")
		return beerStr
	}
		
	func tags () -> String {
		var tagStr = ""
		
		for tag : Tag in beverageSubCategory.tags {
			tagStr = tagStr + tag.name + " "
		}
		//has a space on the end
		
		return tagStr
	}
	
	func tagViewModels () -> [TagViewModel] {
		
		var tagVMs : [TagViewModel] = []
		
		for tag : Tag in beverageSubCategory.tags {
			let tagVM = TagViewModel(tag:tag)
			tagVMs.append(tagVM)
		}
		
		return tagVMs
	}

	func defaultValue(value: String) -> String {
		if value.characters.count == 0 {
			return "n/a"
		}
		return value
	}
	
	func defaultRangeValue () -> String {
		if isBeer() {
			return "varies depending on base style"
		}
		if isCider() {
			return "varies"
		}
		if isMead() {
			return "varies by classification"
		}
		return "n/a"
	}
	
	// sub-sub
	
	func hasParent() -> Bool {
		if let _ = beverageSubCategory.parentSubCategory {
			return true
		}
		return false
	}
	
	//content
	
	func hasDesc() -> Bool {
		if beverageSubCategory.desc.characters.count > 0 {
			return true
		}
		return false
	}

	func hasOverallImpression() -> Bool {
		if beverageSubCategory.overallImpression.characters.count > 0 {
			return true
		}
		return false
	}

	func hasEntryInstructions() -> Bool {
		if beverageSubCategory.entryInstructions.characters.count > 0 {
			return true
		}
		return false
	}
	
	
	func hasVitalStatistics() -> Bool {
		if beverageSubCategory.vitalStatistics.characters.count > 0 {
			return true
		}
		return false
	}
	
	// ranges
	
	func shouldDisplaySRM() -> Bool {
		if isMead() || isCider() {
			return false
		}
		
		return true
	}
	
	func shouldDisplayIBU() -> Bool {
		if isMead() || isCider() {
			return false
		}
		
		return true
	}
	
	func shouldDisplayABV() -> Bool {
		return true
	}
	
	func shouldDisplayOG() -> Bool {
		return true
	}
	
	func shouldDisplayFG() -> Bool {
		return true
	}
	
	func shouldDisplayGravity() -> Bool {
		return (shouldDisplayOG() || shouldDisplayFG())
	}
	
	//type
	
	func isBeer() -> Bool {
		if beverageSubCategory.category.type.name.containsString("beer") || beverageSubCategory.category.type.name.containsString("pending") {
			return true
		}
		return false
	}

	func isClassicBeer() -> Bool {
		if beverageSubCategory.category.type.name.containsString("classic style beer") {
			return true
		}
		return false
	}
	
	func isSpecialtyBeer() -> Bool {
		if beverageSubCategory.category.type.name.containsString("specialty-type beer") {
			return true
		}
		return false
	}
	
	func isLocalStyleBeer() -> Bool {
		if beverageSubCategory.category.type.name.containsString("pending") {
			return true
		}
		return false
	}
	
	func isCider() -> Bool {
		if beverageSubCategory.category.type.name.containsString("cider") {
			return true
		}
		return false
	}
	
	func isMead() -> Bool {
		if beverageSubCategory.category.type.name.containsString("mead") {
			return true
		}
		return false
	}
}