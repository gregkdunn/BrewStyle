//
//  SRMPintRangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/28/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SRMPintRangeView : UIView {
	let srmMinView = SRMStatView()
	let srmMaxView = SRMStatView()
	
	var minSrm : SRM? = nil {
		didSet {
			setSRMValues()
			
		}
	}
	var maxSrm : SRM? = nil {
		didSet {
		setSRMValues()
		
		}
	}
	
	init() {
		super.init(frame: CGRectZero)
		createRange()
	}
	
	convenience init(minSrm:SRM, maxSrm:SRM) {
		self.init()
		self.minSrm = minSrm
		self.maxSrm = maxSrm
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setMinSrm(minSrm: SRM?, maxSrm:SRM?) {
		self.minSrm = minSrm
		self.maxSrm = maxSrm
	}
	
	func resetView() {
		self.minSrm = nil
		self.maxSrm = nil
	}

	func createRange() {
		self.backgroundColor = UIColor.clearColor()
		
		self.addSubview(srmMinView)
		srmMinView.translatesAutoresizingMaskIntoConstraints = false
		srmMinView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		srmMinView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		let toLabel = UILabel()
		toLabel.translatesAutoresizingMaskIntoConstraints = false
		toLabel.text = "/"
		toLabel.font = UIFont.systemFontOfSize(32)
		toLabel.textColor = AppColor.Gray.color
		self.addSubview(toLabel)
		toLabel.leadingAnchor.constraintEqualToAnchor(srmMinView.trailingAnchor, constant: 0).active = true
		toLabel.centerYAnchor.constraintEqualToAnchor(srmMinView.centerYAnchor, constant: 0).active = true
		
		self.addSubview(srmMaxView)
		srmMaxView.translatesAutoresizingMaskIntoConstraints = false
		srmMaxView.centerYAnchor.constraintEqualToAnchor(srmMinView.centerYAnchor, constant: 0).active = true
		srmMaxView.leadingAnchor.constraintEqualToAnchor(toLabel.trailingAnchor, constant: 0).active = true
		
	}
	
	func setSRMValues() {
		srmMinView.srm = minSrm
		srmMaxView.srm = maxSrm
	}
	
	override func intrinsicContentSize() -> CGSize {
		let minStatSize = srmMinView.intrinsicContentSize()
		let width : CGFloat = minStatSize.width + 10 + srmMaxView.intrinsicContentSize().width
		return CGSizeMake(width, minStatSize.height)
	}
	
}