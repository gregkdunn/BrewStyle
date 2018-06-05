//
//  BeverageCategory.swift
//  BrewStyle
//
//  Created by Greg Dunn on 6/8/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class BeverageCategory: PFObject, PFSubclassing {
	@NSManaged var number : Int
	@NSManaged var displayId : String
	@NSManaged var name : String
	@NSManaged var desc : String
	@NSManaged var type : BeverageType
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "BeverageCategory"
	}
}
