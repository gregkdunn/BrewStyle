//
//  ThemeColor.swift
//  BrewStyle
//
//  Created by Greg Dunn on 5/5/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//
class ThemeColor: PFObject, PFSubclassing {
	
	@NSManaged var themeColorID : Int
	@NSManaged var name : String
	@NSManaged var r: NSNumber
	@NSManaged var g: NSNumber
	@NSManaged var b: NSNumber
	@NSManaged var hex: String
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "ThemeColor"
	}
	
	
	
}
