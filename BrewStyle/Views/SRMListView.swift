//
//  SRMListView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/5/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SRMListView : UIView {
	let srmListView = BeverageHeaderDetailView()
	
	convenience init() {
		self.init(frame:CGRectZero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		srmListView.frame = self.bounds
		srmListView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(srmListView)
		srmListView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		srmListView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		srmListView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		srmListView.heightAnchor.constraintEqualToConstant(srmListView.intrinsicContentSize().height).active = true
	}
	
	func configWithSRM(srm: SRM) {
		srmListView.idLabel.backgroundColor = srm.uiColor()
		srmListView.typeIndicator.color = srm.uiColor()
		srmListView.titleLabel.text = srm.valueString()
		srmListView.typeLabel.text = srm.colorString()
	}
}
