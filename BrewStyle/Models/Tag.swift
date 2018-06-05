//
//  Tag.swift
//  BrewStyle
//
//  Created by Greg Dunn on 6/5/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class Tag: PFObject, PFSubclassing {
	
	@NSManaged var position : Int
	@NSManaged var name : String
	@NSManaged var meaning : String
	@NSManaged var category : TagCategory
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "Tag"
	}
}
