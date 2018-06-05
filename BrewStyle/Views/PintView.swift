//
//  PintView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/17/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//  Img : 133 × 205

class PintView : UIView {
	var color: UIColor? = nil {
		didSet {
			if let newColor = color {
				beerImageView.image = beerImgDefault!.tintWithColor(newColor)
			} else {
				beerImageView.image = beerImgDefault
			}
			
		}
	}
	let beerImgDefault = UIImage(named:"pint_beer_white_2")
	var beerImg : UIImage
	let beerImageView = UIImageView()
	var glassImg = UIImage(named:"pint_glass_4")
	let beerGlassView = UIImageView()
	let ratio : CGFloat = 0.648
	let height : CGFloat = 80.0
	var width : CGFloat {
		get {
			return ratio * height
		}
	}
	
	init() {
		beerImg = beerImgDefault!
		super.init(frame: CGRectZero)
		createPint()
	}
	
	required init?(coder aDecoder: NSCoder) {
		beerImg = beerImgDefault!
		super.init(coder: aDecoder)
	}
	
	func createPint() {
		beerImageView.image = beerImg
		beerImageView.contentMode = .ScaleAspectFit
		beerImageView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(beerImageView)
		beerImageView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		beerImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		beerImageView.heightAnchor.constraintEqualToConstant(height).active = true
		beerImageView.widthAnchor.constraintEqualToConstant(width).active = true
		
		beerGlassView.image = glassImg
		beerGlassView.alpha = 0.3
		beerGlassView.contentMode = .ScaleAspectFit
		beerGlassView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(beerGlassView)
		beerGlassView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		beerGlassView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		beerGlassView.heightAnchor.constraintEqualToConstant(height).active = true
		beerGlassView.widthAnchor.constraintEqualToConstant(width).active = true
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSize(width: width, height: height)
	}
}
