//
//  SRMStatView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/17/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SRMStatView : UIView {
	var srm : SRM? = nil {
		didSet {
			setSRMValue()

		}
	}
	var pintView = PintView()
	let srmValueLabel = UILabel()
	let srmValueDefault = "?"
	
	init() {
		super.init(frame: CGRectZero)
		createStat()
	}
	
	convenience init(srm:SRM) {
		self.init()
		self.srm = srm
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func createStat(){
		
		pintView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(pintView)
		
		pintView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		pintView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		pintView.heightAnchor.constraintEqualToConstant(pintView.height).active = true
		pintView.widthAnchor.constraintEqualToConstant(pintView.width).active = true
		
		srmValueLabel.translatesAutoresizingMaskIntoConstraints = false
		srmValueLabel.textColor = AppColor.White.alpha(1.0)
		srmValueLabel.font = AppFonts.header.styled
		setSRMValue()
		self.addSubview(srmValueLabel)
		srmValueLabel.centerXAnchor.constraintEqualToAnchor(pintView.centerXAnchor, constant: 0).active = true
		srmValueLabel.centerYAnchor.constraintEqualToAnchor(pintView.centerYAnchor, constant: AppMargins.large.negative).active = true
		srmValueLabel.sizeToFit()
		
	}
	
	func setSRMValue () {
		if let newSRM = srm {
			if newSRM.value > 0 {
				srmValueLabel.text = (newSRM.value > 0) ? "\(newSRM.value)" : srmValueDefault
				pintView.color = newSRM.uiColor()
				srmValueLabel.textColor = newSRM.uiColor().readableTextColor().colorWithAlphaComponent(1.0)
			} else {
				srmValueLabel.text = srmValueDefault
				pintView.color = nil
				srmValueLabel.textColor = AppColor.Black.color
			}
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		let pintSize = pintView.intrinsicContentSize()
		let viewHeight = pintSize.height
		let viewWidth = pintSize.width
		return CGSize(width: viewWidth, height: viewHeight)
	}
}
