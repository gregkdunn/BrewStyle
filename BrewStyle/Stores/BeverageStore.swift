//
//  BeverageStore.swift
//  BrewStyle
//
//  Created by Greg Dunn on 8/28/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class BeverageStore {
	
	static let sharedInstance = BeverageStore()
	
	func fetchTypesWithCompletionBlock(block:(result: [BeverageType]) -> Void ) {
		let query = PFQuery(className: "BeverageType")
		fetchTypesForQuery(query, block: block)
	}
	
	func fetchTypesForQuery(query : PFQuery, block:(result: [BeverageType]) -> Void ) {
		let extendedQuery = query.fromLocalDatastore()
		extendedQuery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
				if error == nil {
					if let objects = objects as? [BeverageType] {
						block(result : objects)
					}
				} else {
					//print("Error: \(error!)")
				}
		}
	}
	
	func fetchCategoriesWithCompletionBlock(block:(result: [BeverageCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageCategory")
		fetchCategoriesForQuery(query, block: block)
	}

	func fetchCategoriesForType(type: BeverageType, block:(result: [BeverageCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageCategory").whereKey("type", equalTo: type)
		fetchCategoriesForQuery(query, block: block)
	}
	
	func fetchCategoriesForQuery(query : PFQuery, block:(result: [BeverageCategoryViewModel]) -> Void ) {
		var extendedQuery = query.includeKey("type")
								 .fromLocalDatastore()
		
		extendedQuery = sortCategoryQuery(filterCategoryQuery(extendedQuery))
		
		extendedQuery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [BeverageCategory] {
					var objectVMs : Array<BeverageCategoryViewModel> = [BeverageCategoryViewModel]()
					for object : BeverageCategory in objects {
						let objectVM : BeverageCategoryViewModel = BeverageCategoryViewModel(category:object)
						objectVMs.append(objectVM)
					}
					block(result : objectVMs)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func filterCategoryQuery(query : PFQuery) -> PFQuery {
		let filteredQuery = query
		
		//get filter object
		//apply filters to query
		
		return filteredQuery
	}
	
	func sortCategoryQuery(query : PFQuery) -> PFQuery {
		let sortedQuery = query
		var sortField : String
		let sort = GKDSort.sharedInstance
		
		switch(sort.categorySortBy) {
			case .Alphabetical :
				sortField = "name"
			default : //.Number
				sortField = "number"
		}
		
		switch(sort.categorySortOrder) {
			case .Descending :
				sortedQuery.orderByDescending(sortField)
			default : //.Ascending
				sortedQuery.orderByAscending(sortField)
		}
		
		return sortedQuery
	}
	
	func fetchSubCategoriesWithCompletionBlock(block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageSubCategory")
		fetchSubCategoriesForQuery(query, block: block)
	}
	
	func fetchSubCategoriesForType(category:BeverageType, block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageSubCategory").whereKey("type", equalTo: category)
		fetchSubCategoriesForQuery(query, block: block)
	}
	
	func fetchSubCategoriesForCategory(category:BeverageCategory, block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageSubCategory").whereKey("category", equalTo: category)
				fetchSubCategoriesForQuery(query, block: block)
	}

	func fetchSubCategoriesForBeverage(beverage:Beverage, block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageSubCategory").whereKey("commercialExample", equalTo: beverage)
		fetchSubCategoriesForQuery(query, block: block)
	}
	
	func fetchSubCategoriesForSRM(srm:SRM, block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageSubCategory")
		if srm.value == 0.0 {
			query.whereKeyDoesNotExist("srmMin").whereKeyDoesNotExist("srmMax")
		} else {
			query.whereKey("srmMin", lessThanOrEqualTo: srm.value).whereKey("srmMax", greaterThanOrEqualTo: srm.value)
		}
		fetchSubCategoriesForQuery(query, block: block)
	}
	
	func fetchSubCategoriesForTag(tag:Tag, block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		let query = PFQuery(className: "BeverageSubCategory").whereKey("tags", equalTo:tag)
		fetchSubCategoriesForQuery(query, block: block)
	}
	
	func fetchSubCategoriesForQuery(query : PFQuery, block:(result: [BeverageSubCategoryViewModel]) -> Void ) {
		var extendedQuery = query.includeKey("srmMinModel")
								 .includeKey("srmMaxModel")
			                     .includeKey("tags")
								 .includeKey("tags.category")
								 .includeKey("commercialExamples")
								 .includeKey("beverages")
								 .includeKey("category")
								 .includeKey("category.type")
								 .fromLocalDatastore()
		
		extendedQuery = sortSubCategoryQuery(filterSubCategoryQuery(extendedQuery))
		
		extendedQuery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				//print("Results: \(objects?.count)")
				if let objects = objects as? [BeverageSubCategory] {
					var objectVMs : Array<BeverageSubCategoryViewModel> = [BeverageSubCategoryViewModel]()
					for object : BeverageSubCategory in objects {
						
						//DB addition Functions
						//object.setSRMModels()
						//object.setBeverageModels()
						
						//objectVM is mutated on display
						var objectVM : BeverageSubCategoryViewModel = BeverageSubCategoryViewModel(subcategory:object)
						objectVMs.append(objectVM)
					}
					block(result : objectVMs)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func filterSubCategoryQuery(query : PFQuery) -> PFQuery {
		let filteredQuery = query
		
		//get filter object
		let filter = GKDFilter.sharedInstance
		
		//TYPE FILTER
		var min = 1
		var max = 147
		switch filter.subCategoryFilterType {
			case .Beer:
				min = 1
				max = 120				
				switch filter.subCategoryFilterBeerType {
					case .Classic :
						min = 1
						max = 102
					case .Specialty :
						min = 103
						max = 120
					case .Pending :
						min = 145
						max = 147
					default :
						break
				}
			case .Cider:
				min = 121
				max = 131
			case .Mead:
				min = 132
				max = 144
			default :
				break
		}
		filteredQuery.whereKey("number", greaterThanOrEqualTo: min)
		filteredQuery.whereKey("number", lessThanOrEqualTo: max)
		
		if filter.subCategoryKeyword.characters.count > 0 {
			filteredQuery.whereKey("name", matchesRegex: filter.subCategoryKeyword, modifiers:"i")
		}
		
		if(filter.subCategoryFilterSRM.min != filter.srmAll.min || filter.subCategoryFilterSRM.max != filter.srmAll.max) {
			filteredQuery.whereKey("srmMin", greaterThanOrEqualTo: filter.subCategoryFilterSRM.min)
			filteredQuery.whereKey("srmMax", lessThanOrEqualTo: filter.subCategoryFilterSRM.max)
		}
		
		if(filter.subCategoryFilterIBU.min != filter.ibuAll.min || filter.subCategoryFilterIBU.max != filter.ibuAll.max) {
			filteredQuery.whereKey("ibuMin", greaterThanOrEqualTo: filter.subCategoryFilterIBU.min)
			filteredQuery.whereKey("ibuMax", lessThanOrEqualTo: filter.subCategoryFilterIBU.max)
		}

		if(filter.subCategoryFilterABV.min != filter.abvAll.min || filter.subCategoryFilterABV.max != filter.abvAll.max) {
			filteredQuery.whereKey("abvMin", greaterThanOrEqualTo: filter.subCategoryFilterABV.min)
			filteredQuery.whereKey("abvMax", lessThanOrEqualTo: filter.subCategoryFilterABV.max)
		}
		
		return filteredQuery
	}
	
	func sortSubCategoryQuery(query : PFQuery) -> PFQuery {
		let sortedQuery = query
		var sortField : String
		var addMinMax : Bool = false
		
		//get sort object
		let sort = GKDSort.sharedInstance
		
		//get sort field
		switch(sort.subCategorySortBy) {
			case .Alphabetical :
				sortField = "name"
			case .SRM :
				sortField = "srm"
				addMinMax = true
			case .IBU :
				sortField = "ibu"
				addMinMax = true
			case .OG :
				sortField = "og"
				addMinMax = true
			case .FG :
				sortField = "fg"
				addMinMax = true
			case .ABV :
				sortField = "abv"
				addMinMax = true
			default : //.Number
				sortField = "number"
		}
		
		switch(sort.subCategorySortOrder) {
			case .Descending :
				if(addMinMax) {
					sortField = sortField + "\(sort.subCategorySortMinMax)"
				}
				sortedQuery.orderByDescending(sortField)//.whereKeyExists(sortField)
				//print("descending by \(sortField)")
			default : //.Ascending
				if(addMinMax) {
					sortField = sortField + "\(sort.subCategorySortMinMax)"
				}
				sortedQuery.orderByAscending(sortField)//.whereKeyExists(sortField)
				//print("ascending by \(sortField)")
		}
		
		return sortedQuery
	}
	
	func fetchBeveragesWithCompletionBlock(block:(result: [Beverage]) -> Void ) {
		let query = PFQuery(className: "Beverage")
		fetchBeveragesForQuery(query, block: block)
	}
	
	func fetchBeveragesForCategory(subCategory:BeverageSubCategory, block:(result: [Beverage]) -> Void ) {
		let query = PFQuery(className: "Beverage").whereKey("subId", equalTo: subCategory.displayId)
		fetchBeveragesForQuery(query, block: block)
	}
	
	
	func fetchBeveragesForQuery(query : PFQuery, block:(result: [Beverage]) -> Void ) {
		let extendedQuery = query.fromLocalDatastore()
		extendedQuery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [Beverage] {
					block(result : objects)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
}

