//
//  BeverageSubCategory.swift
//  BrewStyle
//
//  Created by Greg Dunn on 8/27/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class BeverageSubCategory: PFObject, PFSubclassing {
	
	@NSManaged var category : BeverageCategory
	@NSManaged var parentSubCategory : BeverageSubCategory?
	@NSManaged var displayId : String
	@NSManaged var name : String
	@NSManaged var desc : String
	@NSManaged var overallImpression : String
	@NSManaged var aroma : String
	@NSManaged var appearance : String
	@NSManaged var flavor : String
	@NSManaged var mouthfeel : String
	@NSManaged var comments : String
	@NSManaged var history : String
	@NSManaged var characteristicIngredients : String
	@NSManaged var styleComparison: String
	@NSManaged var ibuMin : Int
	@NSManaged var ibuMax : Int
	@NSManaged var srmMin : Double
	@NSManaged var srmMax : Double
	@NSManaged var srmMinModel : SRM?
	@NSManaged var srmMaxModel : SRM?
	@NSManaged var ogMin : Double
	@NSManaged var ogMax : Double
	@NSManaged var fgMin : Double
	@NSManaged var fgMax : Double
	@NSManaged var abvMin : Double
	@NSManaged var abvMax : Double
	@NSManaged var vitalStatistics : String
	@NSManaged var tags : Array<Tag>
	@NSManaged var commercialExamples : Array<Beverage>
	@NSManaged var classifications : String
	@NSManaged var varieties : String
	@NSManaged var entryInstructions: String
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "BeverageSubCategory"
	}
	
	func setSRMModels () {
		if(srmMinModel == nil) {
			ContentStore.sharedInstance.fetchSRMForValue(srmMin) { (result) -> Void in
				self.srmMinModel = result
				self.pinInBackground()
				self.saveEventually()
				
			}
		}
		if(srmMaxModel == nil) {
			ContentStore.sharedInstance.fetchSRMForValue(srmMax) { (result) -> Void in
				self.srmMaxModel = result
				self.pinInBackground()
				self.saveEventually()
			}
		}
	}
	
	func setBeverageModels () {
		if(commercialExamples.count == 0 ) {
			BeverageStore.sharedInstance.fetchBeveragesForCategory(self) { (result) -> Void in
				self.addUniqueObjectsFromArray(result, forKey: "commercialExamples")
				self.pinInBackground()
				self.saveEventually()
			}
		}

	}
}
