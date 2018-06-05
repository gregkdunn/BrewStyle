//
//  UILabel+DynamicHeight.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/24/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

import UIKit

extension UILabel {
	class func heightNeededForText(text: String, font: UIFont, width: CGFloat) -> CGFloat {
		let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.ByWordWrapping
		label.font = font
		label.text = text
		label.sizeToFit()
		return label.bounds.height
	}
	
	class func widthNeededForText(text: String, font: UIFont, height: CGFloat) -> CGFloat {
		let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, height))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.ByWordWrapping
		label.font = font
		label.text = text
		label.sizeToFit()
		return label.bounds.width
	}
	
	func heightNeededForWidth(width: CGFloat) -> CGFloat {
		var neededHeight : CGFloat = 0.0
		
		if let currentText = self.text {
			neededHeight = UILabel.heightNeededForText(currentText, font: self.font, width: width)
		}
		
		return neededHeight
	}

	func widthNeededFoHeight(height: CGFloat) -> CGFloat {
		var neededWidth : CGFloat = 0.0
		
		if let currentText = self.text {
			neededWidth = UILabel.widthNeededForText(currentText, font: self.font, height: height)
		}
		
		return neededWidth
	}
}

extension UITextView {
	class func heightNeededForText(text: String, font: UIFont?, width: CGFloat) -> CGFloat {
		let tv:UITextView = UITextView(frame: CGRectMake(0, 0, width, CGFloat.max))
		if let fnt = font {
			tv.font = fnt
		}
		tv.text = text
		tv.sizeToFit()
		return tv.bounds.height
	}
	
	class func widthNeededForText(text: String, font: UIFont?, height: CGFloat) -> CGFloat {
		let tv:UITextView = UITextView(frame: CGRectMake(0, 0, CGFloat.max, height))
		if let fnt = font {
			tv.font = fnt
		}
		tv.text = text
		tv.sizeToFit()
		return tv.bounds.height
	}
	
	func heightNeededForWidth(width: CGFloat) -> CGFloat {
		var neededHeight : CGFloat = 0.0
		
		if let currentText = self.text {
			neededHeight = UITextView.heightNeededForText(currentText, font: self.font, width: width)
		}
		
		return neededHeight
	}
	
	func widthNeededFoHeight(height: CGFloat) -> CGFloat {
		var neededWidth : CGFloat = 0.0
		
		if let currentText = self.text {
			neededWidth = UITextView.widthNeededForText(currentText, font: self.font, height: height)
		}
		
		return neededWidth
	}
}