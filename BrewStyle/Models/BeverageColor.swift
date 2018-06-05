//
//  BeverageColor.swift
//  BrewStyle
//
//  Created by Greg Dunn on 8/28/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class BeverageColor: PFObject, PFSubclassing {
	
	@NSManaged var name : String
	@NSManaged var altName : String?
	@NSManaged var min : Int
	@NSManaged var max : Int

	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "BeverageColor"
	}
}
