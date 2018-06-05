//
//  TagGlossaryController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/20/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

import UIKit

enum TagGlossaryCellIdentifiers : String {
	case header = "overview"
	case tag = "TagListingCell"
}

enum TagGlossaryCollectionViewSections : Int {
	case Tags
}

class TagGlossaryController: GKDFilterableViewController {
	let titleString = "Tags"
	let descString  = "To assist with regrouping styles for other purposes, we have added informational tags to each style. These tags indicate certain attributes of the beer that may be used for grouping purposes. The ‘meaning’ column explains the general intent of the tag, but is not meant to be rigorous, formal definition. In no way do the tags supersede the actual descriptions of the style"
	
	private let sizingTagsCell = TagDefinitionCell()
	
	lazy var data : Array<TagViewModel> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		createSettingsButton()
		configueBackButton()
		createCollectionView()
		//createFilterMenu()
		reloadData()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"reloadData", name:Constants.Notification.DefaultsVersion, object:nil)
	}
	
	// MARK: Data
	
	func reloadData () {
		ContentStore.sharedInstance.fetchTagsWithCompletionBlock {
			(result: [TagViewModel]) in
			self.data = self.sortByCategory(result)
			if result.count > 0 {
				self.collectionView.reloadData()
				self.empty.disable()
			} else {
				self.empty.noData()
			}
			
		}
	}
	
	func sortByCategory (result: [TagViewModel]) -> [TagViewModel]{
		var flavor : [TagViewModel] = []
		var era  : [TagViewModel] = []
		var styleFamily  : [TagViewModel] = []
		var region  : [TagViewModel] = []
		var fermentation : [TagViewModel] = []
		var color : [TagViewModel] = []
		var strength  : [TagViewModel] = []
		
		
		for tagVM in result {
			if let cat = tagVM.category() {
				switch cat {
				case .DominantFlavor :
					flavor.append(tagVM)
				case .Era :
					era.append(tagVM)
				case .StyleFamily :
					styleFamily.append(tagVM)
				case .Region :
					region.append(tagVM)
				case .Fermentation :
					fermentation.append(tagVM)
				case .Color :
					color.append(tagVM)
				case .Strength :
					strength.append(tagVM)
				}
			}
		}
		
		var all : [TagViewModel] = []
		all.appendContentsOf(strength)
		all.appendContentsOf(color)
		all.appendContentsOf(fermentation)
		all.appendContentsOf(region)
		all.appendContentsOf(styleFamily)
		all.appendContentsOf(era)
		all.appendContentsOf(flavor)
		return all
	}
	
	// MARK: Collection View
	
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(TagDefinitionCell.self, forCellWithReuseIdentifier: TagGlossaryCellIdentifiers.tag.rawValue)
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: TagGlossaryCellIdentifiers.header.rawValue)
		
		empty.configWithIcon(UIImage(named:"pint_beer_white_2"),title:"loading", description: "tags")
	}
}

extension TagGlossaryController : UICollectionViewDataSource {
	
	
	// MARK - Header
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CategoryDetailView.sizeForText(descString, width: collectionView.bounds.width)
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		let header : CategoryDetailView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: TagGlossaryCellIdentifiers.header.rawValue, forIndexPath: indexPath) as! CategoryDetailView
		
		header.titleLabel.text = titleString
		header.descLabel.text  = descString
		header.resetGradientFrame()
		
		return header as UICollectionReusableView
	}
	
	//MARK - Cells
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 	data.count
	}
 
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TagGlossaryCellIdentifiers.tag.rawValue, forIndexPath: indexPath) as UICollectionViewCell
		
		configCell(cell, indexPath: indexPath)
		
		return cell
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		if let tagDefCell = cell as? TagDefinitionCell,
			let tagVM : TagViewModel = data[indexPath.row] {
				tagDefCell.cellWidth = collectionView.bounds.width - 2
				tagDefCell.configWithTagViewModel(tagVM, isHeader: false)
		}
	}
}

extension TagGlossaryController : UICollectionViewDelegate {
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let tagVM  : TagViewModel = data[indexPath.row] else {
			return
		}
		self.navigationController?.showTagDetail(tagVM)
		
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension TagGlossaryController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		if let tagVM : TagViewModel = data[indexPath.row] {
			sizingTagsCell.prepareForReuse()
			sizingTagsCell.cellWidth = collectionView.bounds.width - 2
			sizingTagsCell.configWithTagViewModel(tagVM, isHeader: false)
			return sizingTagsCell.intrinsicContentSize()
		}
		
		return CGSize(width: collectionView.bounds.width - 2, height: 55)
	}
}

