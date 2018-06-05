//
//  MultiColumnCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/24/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class MultiColumnCell: UICollectionViewCell, UIGestureRecognizerDelegate {
	let multiView = MultiColumnTextView()
	let swipeView = UIView()
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	
	let leftSwipe = UISwipeGestureRecognizer()
	let rightSwipe = UISwipeGestureRecognizer()
	
	var title : NSString?
	var content : NSAttributedString?
	
	var descHeightConstraint : NSLayoutConstraint?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.clipsToBounds = true
		self.contentView.backgroundColor = UIColor.clearColor()
		
		let container = GradientView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppStyle.SubCategoryDetailHeader[.BackgroundColor]
		container.gradientWithColors((position: 0.0, color: AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.9)), bottomStop: (position: 1.0, color: AppStyle.SubCategoryDetailHeader[.ContainerGradient]!.colorWithAlphaComponent(0.8)))
		
		self.addSubview(container)
		container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		multiView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(multiView)
		multiView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: AppMargins.medium.margin).active = true
		multiView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		multiView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		multiView.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: 0).active = true
		
		swipeView.translatesAutoresizingMaskIntoConstraints = false
		swipeView.userInteractionEnabled = true
		container.addSubview(swipeView)
		swipeView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		swipeView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		swipeView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		swipeView.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: 0).active = true
		
		leftSwipe.direction = .Left
		leftSwipe.delegate = self
		leftSwipe.addTarget(self, action: "next")
		swipeView.addGestureRecognizer(leftSwipe)
		
		rightSwipe.direction = .Right
		rightSwipe.delegate = self
		rightSwipe.addTarget(self, action: "previous")
		swipeView.addGestureRecognizer(rightSwipe)
		
	}
	
	override func prepareForReuse() {
		multiView.descLabel.text = nil
		super.prepareForReuse()
	}
	
	func configWithTitle(title : String, content: NSAttributedString) {
		self.title = title
		self.content = content
		multiView.configWithContent(content)
		self.layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		if let contentString = content?.string {
			let height = MultiColumnTextView.sizeForText(contentString, width: cellWidth).height
			return CGSize(width: cellWidth, height: height)
		}
		return CGSize(width: cellWidth, height: 100)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func next() {
		print("next notification")
		NSNotificationCenter.defaultCenter().postNotificationName("nextIntro", object:self)
	}
	
	func previous() {
		print("prev notification")		
		NSNotificationCenter.defaultCenter().postNotificationName("previousIntro", object:self)
	}
}
