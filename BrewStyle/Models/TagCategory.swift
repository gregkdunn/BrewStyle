//
//  TagType.swift
//  BrewStyle
//
//  Created by Greg Dunn on 6/5/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class TagCategory: PFObject, PFSubclassing {

	@NSManaged var name : String
	@NSManaged var color : UIColor
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "TagCategory"
	}
}
