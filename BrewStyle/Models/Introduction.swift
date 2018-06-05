//
//  Introduction.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/27/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class Introduction: PFObject, PFSubclassing {
	
	@NSManaged var name : String
	@NSManaged var content : PFFile
	
	private var contentData : NSData?
	private var dataString : String?
	private var attString : NSAttributedString?
	
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
 
	static func parseClassName() -> String {
		return "Introduction"
	}

	func fetchContentData() {
		if let _ = contentData {
			return
		}
		
		content.getDataInBackgroundWithBlock { (newData : NSData?, error : NSError?) -> Void in
			if let currentData = newData {
				self.contentData = currentData
				self.contentString()
				self.contentAttributedString()
			}
		}
	}

	func contentString() -> String {
		if let currentString = dataString {
			return currentString
		}
		
		var data : NSData
		var str = ""
		
		if let currentData = contentData {
			if let newStr = String(data: currentData, encoding: NSUTF8StringEncoding) {
				str = newStr
			}
		} else {
			do {
				try data = content.getData()
				
				if let newStr = String(data: data, encoding: NSUTF8StringEncoding) {
					str = newStr
				}
				
			} catch {
				//print(error)
			}
		}
			
		return str
	}
	
	func contentAttributedString () -> NSAttributedString {
		if let savedAttString = attString {
			return savedAttString
		}
		
		let defaultAttributes = [NSFontAttributeName: AppFonts.body.font, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue]
		let newString = BumbleBee.parser().process(self.contentString(), attributes: defaultAttributes)
		attString = newString
		
		return newString
	}
}
