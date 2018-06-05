//
//  User.swift
//  BrewStyle
//
//  Created by Greg Dunn on 5/3/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class User: PFObject, PFSubclassing {
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "User"
	}
}