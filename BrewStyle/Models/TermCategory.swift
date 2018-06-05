//
//  TermCategory.swift
//  BrewStyle
//
//  Created by Greg Dunn on 6/8/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class TermCategory: PFObject, PFSubclassing {

	@NSManaged var name : String
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "TermCategory"
	}
}
