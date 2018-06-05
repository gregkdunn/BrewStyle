//
//  SubCategoryParentListingCell.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/14/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//



class TitleCell: UICollectionViewCell {
	
	let beverageHeaderView = BeverageHeaderDetailView()
	let descLabel = UILabel()
	let imgView = UIImageView()
	
	var cellWidth : CGFloat = 0
	let defaultCellWidth : CGFloat = 360
	let idSize : CGFloat = 60
	
	var containerTop : NSLayoutConstraint?
	var containerBottom : NSLayoutConstraint?
	
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
		
		let container = UIView()
		container.translatesAutoresizingMaskIntoConstraints = false
		container.backgroundColor = AppStyle.SubCategoryListCell[.ContainerColor]
		
		self.contentView.addSubview(container)
		containerTop = container.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 1)
		containerTop!.active = true
		containerBottom = container.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0)
		containerBottom!.active = true
		container.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		container.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		beverageHeaderView.viewWidth = self.contentView.bounds.width
		beverageHeaderView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(beverageHeaderView)
		beverageHeaderView.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 0).active = true
		beverageHeaderView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: 0).active = true
		beverageHeaderView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 0).active = true
		beverageHeaderView.heightAnchor.constraintEqualToConstant(beverageHeaderView.intrinsicContentSize().height).active = true
		
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.numberOfLines = 0
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		container.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(beverageHeaderView.bottomAnchor, constant: AppMargins.medium.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: AppMargins.large.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor, constant: AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant:AppMargins.large.negative).active = true
		
		
		imgView.contentMode = .ScaleAspectFit
		imgView.translatesAutoresizingMaskIntoConstraints = false
		
		self.contentView.addSubview(imgView)
		imgView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: AppMargins.medium.negative).active = true
		imgView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
		imgView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
		imgView.heightAnchor.constraintEqualToConstant(150).active = true
		imgView.alpha = 0.9
	}
	
	override func prepareForReuse() {
		beverageHeaderView.clearData()
		descLabel.text = ""
		
		super.prepareForReuse()
	}

	func configWithTitle(title : String, desciption : String) {
		beverageHeaderView.configWithTitle(title)
		descLabel.text = desciption
	}
	
	func configWithTitle(title : String, desciption : String, img: UIImage) {
		beverageHeaderView.configWithTitle(title)
		descLabel.text = desciption
		imgView.image = img
	}
	
	func configWithBeverageCategoryViewModel(categoryVM : BeverageCategoryViewModel) {
		beverageHeaderView.configWithBeverageCategoryViewModel(categoryVM)
		descLabel.text = categoryVM.desc()

	}
	
	func configWithBeverageSubCategoryViewModel(subCategoryVM : BeverageSubCategoryViewModel) {
		beverageHeaderView.configWithBeverageSubCategoryViewModel(subCategoryVM)
		descLabel.text = subCategoryVM.description()

	}
	
	override func intrinsicContentSize() -> CGSize {
		cellWidth = (cellWidth > 0) ? cellWidth : defaultCellWidth
		
		// add header height
		var cellHeight = beverageHeaderView.intrinsicContentSize().height
		
		//add desc height
		let descHeight = calculateDescHeight()
		cellHeight  = (descHeight > 0) ? cellHeight + AppMargins.medium.margin + descHeight + AppMargins.large.margin + AppMargins.large.margin : cellHeight + AppMargins.large.margin + AppMargins.large.margin
				
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
		cellWidth = targetWidth
		return intrinsicContentSize()
	}
	
	func calculateDescHeight() -> CGFloat {
		let height : CGFloat =  descLabel.heightNeededForWidth(cellWidth - AppMargins.large.double)
		return height
	}
	
	func setDescHeight(height: CGFloat) {
		if let heightContraint = descHeightConstraint {
			heightContraint.constant = height
		}
	}
}
