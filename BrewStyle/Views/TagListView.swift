//
//  TagListView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/26/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TagListView : UIView {
	var subCategoryVM : BeverageSubCategoryViewModel?
	var tagViewModels : [TagViewModel] = [] {
		didSet {
			buildTagViews()
			renderTagList()
		}
	}
	var viewWidth : CGFloat = 0
	var tagViewHeight : CGFloat = 0
	
	private var tagViews : [TagView] = []
	private let rowStack = UIStackView()
	private var colStacks : [UIStackView] = []
	private var rows : CGFloat = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	convenience init(tagVMs: [TagViewModel] = [], margin: CGFloat = 3) {
		self.init(frame:CGRectZero)
		self.tagViewModels = tagVMs
	}
	
	func commonInit() {
		self.backgroundColor = UIColor.clearColor()
		rowStack.translatesAutoresizingMaskIntoConstraints = false
		rowStack.axis = .Vertical
		rowStack.distribution = .FillEqually
		rowStack.alignment = .Leading
		self.addSubview(rowStack)
		rowStack.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		rowStack.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		rowStack.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		rowStack.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
	}
	
	func resetTagViews() {
		for colStack in rowStack.arrangedSubviews {
			if let stack : UIStackView = colStack as? UIStackView {
				for view in stack.arrangedSubviews {
					stack.removeArrangedSubview(view)
					view.removeFromSuperview()
				}
			}			
			rowStack.removeArrangedSubview(colStack)
			colStack.removeFromSuperview()
		}

		colStacks.removeAll()
		tagViews.removeAll()
		rows = 0
	}
	
	func buildTagViews() {
		resetTagViews()
		for tagVM : TagViewModel in tagViewModels {
			var tagView : TagView?
			if let subcatVM = subCategoryVM {
				tagView = TagView(tagVM:tagVM,subCategoryVM: subcatVM, canToggle: false)
			} else {
				tagView = TagView(tagVM:tagVM, enabled:true, canToggle: false)
			}

			if let newTagView = tagView {
				newTagView.translatesAutoresizingMaskIntoConstraints = false
				tagViews.append(newTagView)
			}
		}
		
	}
	
	func renderTagList() {
		var colStacks : [UIStackView] = []
		var currentRow = 0
		var currentRowTagCount = 0
		var currentRowWidth: CGFloat = 0
		var i = 0
		for tagView in tagViews {
			i += 1
			//print(">index: \(i)")
			//print(">\(currentRow) width: \(currentRowWidth)")
			tagView.frame.size = tagView.intrinsicContentSize()
			tagViewHeight = tagView.intrinsicContentSize().height
			
			if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > viewWidth {
				let colStack = UIStackView()
				colStack.translatesAutoresizingMaskIntoConstraints = false
				colStack.axis = .Horizontal
				colStack.distribution = .EqualSpacing
				colStack.alignment = .Leading
				colStack.translatesAutoresizingMaskIntoConstraints = false
				rowStack.addArrangedSubview(colStack)
				
				colStacks.append(colStack)
				currentRow += 1
				currentRowTagCount = 1
				currentRowWidth = tagView.frame.width
				
				colStack.addArrangedSubview(tagView)
			}
			else {
				
				currentRowTagCount += 1
				currentRowWidth += tagView.frame.width
				
				colStacks[currentRow-1].addArrangedSubview(tagView)
			}
		}
		rows = CGFloat(currentRow)
		
		layoutSubviews()
	}
	
	override func intrinsicContentSize() -> CGSize {
		let height = tagViewHeight * rows
		return CGSize(width: viewWidth, height: height)
	}
}
