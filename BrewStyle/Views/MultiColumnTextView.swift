//
//  MultiColumnTextView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/24/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class MultiColumnTextView: UIView {
	let descLabel = UITextView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.backgroundColor = UIColor.clearColor()

		descLabel.backgroundColor = UIColor.clearColor()
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.userInteractionEnabled = false
		self.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:AppMargins.large.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant:AppMargins.small.negative).active = true
	}

	
	class func sizeForText(text: String, width: CGFloat) -> CGSize {
		let viewWidth = width - (AppMargins.large.double)
		let height = UILabel.heightNeededForText(text, font:AppFonts.body.font, width: viewWidth) + 300
		return CGSize(width: width, height: AppMargins.small.margin + height + AppMargins.small.margin + 27 + AppMargins.large.margin )
	}
		
	func configWithContent(content: NSAttributedString?) {
		
		if let newContent = content {
			descLabel.attributedText = newContent
		}
		descLabel.sizeToFit()
	}
}