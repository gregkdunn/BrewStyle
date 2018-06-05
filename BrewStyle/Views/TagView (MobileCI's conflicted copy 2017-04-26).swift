//
//  TagView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/27/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TagView : UIView {
	var tagVM : TagViewModel? = nil
	var subCategoryVM: BeverageSubCategoryViewModel? = nil
	
	var color : UIColor = UIColor.blackColor()
	let disabledColor = UIColor.grayColor()
	var text : String = "" {
		didSet {
			label.text = text
			layoutSubviews()
		}
	}
	var enabled : Bool = true {
		didSet {
			setBGColor()
		}
	}
	var canToggle : Bool = false

	
	let margin : CGFloat = 3
	let label = UILabel()
	var textSize : CGFloat = AppFonts.body.rawValue
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	convenience init () {
	    self.init(frame:CGRectZero)
	}
	
	convenience init(tagVM : TagViewModel) {
		self.init(frame:CGRectZero)
		self.color = tagVM.color()
		self.text = tagVM.title()
		self.enabled = true
	}
	
	
	convenience init(color: UIColor, text: String, enabled: Bool) {
		self.init(frame:CGRectZero)
		self.color = color
		self.text = text
		self.enabled = enabled
	}
	
	convenience init(tagVM: TagViewModel, enabled: Bool, canToggle: Bool = false) {
		self.init(frame:CGRectZero)
		self.color = tagVM.color()
		self.text = tagVM.title()
		self.enabled = enabled
		self.canToggle = canToggle
		
		setBGColor()
		label.text = text
		layoutSubviews()
	}

	convenience init(tagVM: TagViewModel, subCategoryVM: BeverageSubCategoryViewModel, canToggle: Bool = false) {
		self.init(frame:CGRectZero)
		self.tagVM = tagVM
		self.subCategoryVM = subCategoryVM
		self.color = tagVM.color()
		self.text = tagVM.title()
		self.canToggle = canToggle
		self.enabled = tagVM.isEnabledFor(subCategoryVM)
		
		
		setBGColor()
		label.text = text
		setupToggle()
		
		layoutSubviews()

	}
	
	func commonInit() {
		clipsToBounds = true
		self.layer.cornerRadius = 8
		
		label.clipsToBounds = true
		label.layer.cornerRadius = 4
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = UIColor.clearColor()
		label.textColor = AppColor.White.color
		label.font = UIFont(name: "Futura-CondensedMedium", size: 16)
		label.textAlignment = .Center
		label.text = text
		self.addSubview(label)
		label.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		label.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.small.negative).active = true
		label.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: AppMargins.small.negative).active = true
		label.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
	}
	
	func setupToggle () {
		if(canToggle) {
			let tap = UITapGestureRecognizer(target: self, action: "toggle")
			label.addGestureRecognizer(tap)
			label.userInteractionEnabled = true
		}
	}
	
	func configWithTagViewModel(tagVM : TagViewModel) {
		self.color = tagVM.color()
		self.text = tagVM.title()
		self.enabled = true
		setBGColor()
	}
	
	
	func toggle() {
		if(canToggle) {
			enabled = !(enabled)
			
			if let subcatVM = subCategoryVM,
				let tagViewModel = tagVM{
					if enabled {
						// tag editor
						//subcatVM.beverageSubCategory.addObject(tagViewModel.tag, forKey: "tags")
					} else {
						// tag editor
						//subcatVM.beverageSubCategory.removeObject(tagViewModel.tag, forKey: "tags")
					}
			}
		}
	}
	
	func setBGColor () {
		label.backgroundColor  = (enabled) ? color : disabledColor
		if let bgcolor = label.backgroundColor {
			label.textColor = bgcolor.readableTextColor().colorWithAlphaComponent(0.75)
		}
		
	}
	override func intrinsicContentSize() -> CGSize {
		let viewHeight = AppMargins.medium.double + AppMargins.small.margin + textSize
		let viewWidth = AppMargins.medium.double + AppMargins.small.margin + label.widthNeededFoHeight(viewHeight)
		return CGSize(width: viewWidth, height: viewHeight)
	}

}
