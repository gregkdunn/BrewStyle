//
//  SRM.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/12/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SRM: PFObject, PFSubclassing {
	
	@NSManaged var value : Double
	@NSManaged var rgb : Array<CGFloat>
	@NSManaged var color : BeverageColor?

	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "SRM"
	}
	
	func uiColor() -> UIColor {
		let red : CGFloat = rgb[0]/255.0
		let green : CGFloat  = rgb[1]/255.0
		let blue : CGFloat  = rgb[2]/255.0
		
		//print("SRMColor (\(value)): r\(red) g\(green) b\(blue)")
		
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}
	
	func lovibond() -> Double {
		return ((self.value / 0.76) / 1.3546)
		
	}
	
	func lovibondString() -> String {
		return String(format: "%.2f",self.lovibond())
	}
	
	func ebc() -> Double {
		return (self.value * 1.97)
	}
	
	func ebcString() -> String {
		return String(format: "%.2f",self.ebc())
	}
	
	func isInt() -> Bool {
		let isInteger = floor(self.value) == self.value
		return isInteger
	}
}
