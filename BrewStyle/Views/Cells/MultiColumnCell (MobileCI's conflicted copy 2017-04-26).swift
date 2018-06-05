//
//  MultiColumnCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/24/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class MultiColumnCell: UICollectionViewCell {
	
	let multiView = MultiColumnTextView()
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	
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
		
		multiView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(multiView)
		multiView.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: 0).active = true
		multiView.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 0).active = true
		multiView.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: 0).active = true
		multiView.bottomAnchor.constraintEqualToAnchor(self.contentView.bottomAnchor, constant: 0).active = true
		
	}
	
	override func prepareForReuse() {
		multiView.titleLabel.text = nil
		multiView.descLabel.text = nil
		super.prepareForReuse()
	}
	
	func configWithTitle(title : String, content: NSAttributedString) {
		//multiView.descLabel.numberOfColumns = (cellWidth > 375) ? 2 : 1
		self.title = title
		self.content = content
		multiView.configWithTitle(title, content: content)
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
}
