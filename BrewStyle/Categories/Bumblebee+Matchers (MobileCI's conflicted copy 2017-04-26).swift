//
//  bumblebee+Matchers.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/25/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

extension BumbleBee {
	
	class func parser() -> BumbleBee {
		let parser = BumbleBee()
		
		parser.add("[[?]]", recursive: false) { (pattern: String, text: String, start: Int) -> (String, [NSObject : AnyObject]?) in
			let replace = pattern[pattern.startIndex.advancedBy(2)...pattern.endIndex.advancedBy(-3)]
			return (replace,[NSFontAttributeName: UIFont(name: "Futura-CondensedMedium", size: 19)!,
				NSForegroundColorAttributeName: AppStyle.SubCategoryDetailHeader[.TitleColor]!])
		}
		
		//header pattern
		parser.add("{{?}}", recursive: false) { (pattern: String, text: String, start: Int) -> (String, [NSObject : AnyObject]?) in
			let replace = pattern[pattern.startIndex.advancedBy(2)...pattern.endIndex.advancedBy(-3)]
			return (replace,[NSFontAttributeName: UIFont(name: "Futura-CondensedMedium", size: 17)!,
				NSForegroundColorAttributeName: AppStyle.SubCategoryDetailHeader[.SubHeaderColor]!])
		}
		
		//the bold pattern
		parser.add("_?_", recursive: false) { (pattern: String, text: String, start: Int) -> (String, [NSObject : AnyObject]?) in
			let replace = pattern[pattern.startIndex.advancedBy(1)...pattern.endIndex.advancedBy(-2)]
			return (replace,[NSFontAttributeName: AppFonts.body.bold])
		}
		
		//the italic pattern
		parser.add("~?~", recursive: false) { (pattern: String, text: String, start: Int) -> (String, [NSObject : AnyObject]?) in
			let replace = pattern[pattern.startIndex.advancedBy(1)...pattern.endIndex.advancedBy(-2)]
			return (replace,[NSFontAttributeName: AppFonts.body.italic])
		}

		//the underline pattern
		parser.add("^?^", recursive: false) { (pattern: String, text: String, start: Int) -> (String, [NSObject : AnyObject]?) in
			let replace = pattern[pattern.startIndex.advancedBy(1)...pattern.endIndex.advancedBy(-2)]
			return (replace,[NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
		}
	
		return parser
	}
	
}