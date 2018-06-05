//
//  BackgroundView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/6/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class BackgroundView : GradientView {
	//let typeIndicator = TriangleView(color:AppColor.LightSlate.color)
	let typeIndicator = UIImageView(image: UIImage(named: "triangle"))
	convenience init() {
		self.init(frame:CGRectZero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(frame: CGRectZero)
		commonInit()
	}
	
	func commonInit () {
		self.backgroundColor = AppStyle.CollectionView[.BackgroundColor]
		self.gradientWithColors((position: 0.0, color: AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(1.0)), bottomStop: (position: 1.0, color: AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(1.0)))
		
		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(typeIndicator)
		typeIndicator.alpha = 0.1
		typeIndicator.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(140).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(140).active = true
		
	}

}
