//
//  Term.swift
//  BrewStyle
//
//  Created by Greg Dunn on 6/8/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class Term: PFObject, PFSubclassing {
	
	@NSManaged var name : String
	@NSManaged var meaning : String
	@NSManaged var category : TermCategory
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "Term"
	}	
}
