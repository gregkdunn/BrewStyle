//
//  TagListingController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/28/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

import UIKit

enum TagListingCellIdentifiers : String {
	case header = "overview"
	case subcategory = "TitleCell"
	case tag = "TagListingCell"
}

enum TagListingCollectionViewSections : Int {
	case Title = 0
	case Tags
}

class TagListingController: GKDFilterableViewController {	
	let titleString = "Tags"
	let descString  = ""
	
	private let sizingTitleCell = TitleCell()
	private let sizingTagsCell = TagListingCell()
	
	var subCategoryVM : BeverageSubCategoryViewModel? = nil
	lazy var data : Array<[TagViewModel]> = []
	
	
	convenience init(subCategory:BeverageSubCategoryViewModel ) {
		self.init(nibName: nil, bundle: nil)
		self.subCategoryVM = subCategory
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//configueBackButton()
		createCollectionView()
		reloadData()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		if let subcat = subCategoryVM?.beverageSubCategory {
			subcat.pinInBackground()
			subcat.saveEventually()
			
		}
	}
	// MARK: Data
	
	override func reloadData () {
		empty.enable()
		ContentStore.sharedInstance.fetchTagsWithCompletionBlock {
			(result: [TagViewModel]) in
			self.data = self.sortByCategory(result)
			if result.count > 0 {
				self.collectionView.reloadData()
				self.empty.disable()
			} else {
				self.empty.noData()
			}
			self.refreshControl.endRefreshing()
		}
	}
	
	func sortByCategory (result: [TagViewModel]) -> [[TagViewModel]]{
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
		
		return [strength, color, fermentation, region, era, styleFamily, flavor]
	}
	
	
	
	// MARK: Collection View
	
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(TitleCell.self, forCellWithReuseIdentifier: TagListingCellIdentifiers.subcategory.rawValue)
		collectionView.registerClass(TagListingCell.self, forCellWithReuseIdentifier: TagListingCellIdentifiers.tag.rawValue)
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: TagListingCellIdentifiers.header.rawValue)
		
		empty.configWithIcon(UIImage(named:"pint_stamped"),title:"loading", description: "tags")
		
		refreshControl.addTarget(self, action: "reloadData", forControlEvents: .ValueChanged)
	}
}

extension TagListingController : UICollectionViewDataSource {
	
	
	// MARK - Header
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSizeZero
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		let header : CategoryDetailView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: TagListingCellIdentifiers.header.rawValue, forIndexPath: indexPath) as! CategoryDetailView
		
		header.titleLabel.text = titleString
		header.descLabel.text  = descString
		
		return header as UICollectionReusableView
	}
	
	//MARK - Cells
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 2
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionIdentifier : TagListingCollectionViewSections = TagListingCollectionViewSections(rawValue: section)!
		
		switch sectionIdentifier {
			case .Title :
				return 1
			case .Tags :
				return 	data.count
		}
	}
 
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell : UICollectionViewCell
		let sectionIdentifier : TagListingCollectionViewSections = TagListingCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Title :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(TagListingCellIdentifiers.subcategory.rawValue, forIndexPath: indexPath) as UICollectionViewCell

			case .Tags :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(TagListingCellIdentifiers.tag.rawValue, forIndexPath: indexPath) as UICollectionViewCell
		}
		
		configCell(cell, indexPath: indexPath)
		
		return cell
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		let sectionIdentifier : TagListingCollectionViewSections = TagListingCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Title :
				if let titleCell = cell as? TitleCell,
					let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
						titleCell.cellWidth = collectionView.bounds.width - 2
						titleCell.configWithBeverageSubCategoryViewModel(subCatVM)
				}
			case .Tags :
				if let tagListingCell = cell as? TagListingCell,
					let tagVMs : [TagViewModel] = data[indexPath.row] {
						tagListingCell.cellWidth = collectionView.bounds.width - 2
						if let subcatVM = subCategoryVM {
							tagListingCell.configWithTagViewModels(tagVMs, subCategoryVM: subcatVM)
						} else {
							tagListingCell.configWithTagViewModels(tagVMs)
						}
				}
		
		}
	}
}

extension TagListingController : UICollectionViewDelegate {
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let _  : [TagViewModel] = data[indexPath.row] else {
			return
		}
		//show subcategories with tag
		
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension TagListingController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		let sectionIdentifier : TagListingCollectionViewSections = TagListingCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Title :
				if let subCatVM = subCategoryVM {
					sizingTitleCell.prepareForReuse()
					sizingTitleCell.cellWidth = collectionView.bounds.width - 2
					sizingTitleCell.configWithBeverageSubCategoryViewModel(subCatVM)
					////print("Title >>> \(sizingTitleCell.intrinsicContentSize())")
					return sizingTitleCell.intrinsicContentSize()
				}
			case .Tags :
				if let tagVMs : [TagViewModel] = data[indexPath.row] {
					sizingTagsCell.prepareForReuse()
					sizingTagsCell.cellWidth = collectionView.bounds.width - 2
					sizingTagsCell.configWithTagViewModels(tagVMs)
					return sizingTagsCell.intrinsicContentSize()
				}
		}
		return CGSizeZero
	}
}
