//
//  TermListingController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/29/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


import UIKit

enum TermCellIdentifiers : String {
	case header = "overview"
	case term = "TermListingCell"
}

enum TermCollectionViewSections : Int {
	case Terms
}

class TermListingController: GKDFilterableViewController {
	let titleString = "Glossary"
	let descString  = "Some terminology used in the style guidelines may be unfamiliar to some readers. Rather than include a complete dictionary, we have highlighted a few terms that either may not be well understood, or that imply specific meanings within the guidelines. Sometimes ingredient names are used as a shorthand for the character they provide to beer. When judges use these terms, they don’t necessarily imply that those specific ingredients have been used, just that the perceived characteristics match those commonly provided by the mentioned ingredients."
	
	private let sizingTermsCell = TermListingCell()
	
	lazy var data : Array<TermViewModel> = []
	
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
		dataDisplayed = 0
		self.data.removeAll()
		collectionView.reloadData()
		
		ContentStore.sharedInstance.fetchTermsWithCompletionBlock {
			(result: [TermViewModel]) in
			self.data = self.sortByCategory(result)
			if result.count > 0 {
				self.loadMoreData()
				self.empty.disable()	
			} else {
				self.empty.noData()
			}
		}
	}
	
	func sortByCategory (result: [TermViewModel]) -> [TermViewModel]{
		var appearance : [TermViewModel] = []
		var quality  : [TermViewModel] = []
		var yeast  : [TermViewModel] = []
		var malt  : [TermViewModel] = []
		var hop : [TermViewModel] = []
		
		
		for termVM in result {
			if let cat = termVM.category() {
				switch cat {
				case .Appearance :
					appearance.append(termVM)
				case .Quality :
					quality.append(termVM)
				case .Yeast :
					yeast.append(termVM)
				case .Malt :
					malt.append(termVM)
				case .Hop :
					hop.append(termVM)
				}
			}
		}
		
		var sorted : [TermViewModel] = []
		sorted.appendContentsOf(appearance)
		sorted.appendContentsOf(quality)
		sorted.appendContentsOf(yeast)
		sorted.appendContentsOf(malt)
		sorted.appendContentsOf(hop)
		
		return sorted
	}
	
	// MARK: Collection View
	
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(TermListingCell.self, forCellWithReuseIdentifier: CategoryCellIdentifiers.category.rawValue)
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SubCategoryCellIdentifiers.PageHeader.rawValue)

		empty.configWithIcon(UIImage(named:"pint_beer_white_2"),title:"loading", description: "terms")
	}
}

extension TermListingController : UICollectionViewDataSource {
	
	
	// MARK - Header
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CategoryDetailView.sizeForText(descString, width: collectionView.bounds.width)
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		let header : CategoryDetailView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryCellIdentifiers.PageHeader.rawValue, forIndexPath: indexPath) as! CategoryDetailView
		
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
		return 	dataDisplayed
	}
 
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCellIdentifiers.category.rawValue, forIndexPath: indexPath) as UICollectionViewCell
		
		configCell(cell, indexPath: indexPath)
		
		return cell
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		if let termListingCell = cell as? TermListingCell,
			let termVM : TermViewModel = data[indexPath.row] {
				termListingCell.cellWidth = collectionView.bounds.width - 2
				termListingCell.configWithTermViewModel(termVM)
		}
	}
}

extension TermListingController : UICollectionViewDelegate {
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let _  : TermViewModel = data[indexPath.row] else {
			return
		}
		//show subcategories with term
		
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension TermListingController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row > dataDisplayed {
			loadMoreData()
		}
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		if let termVM : TermViewModel = data[indexPath.row] {
			sizingTermsCell.prepareForReuse()
			sizingTermsCell.cellWidth = collectionView.bounds.width - 2
			sizingTermsCell.configWithTermViewModel(termVM)
			return sizingTermsCell.intrinsicContentSize()
		}
		
		return CGSize(width: collectionView.bounds.width - 2, height: 55)
	}
}


// Infinite Scrolling
extension TermListingController : UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height * 0.6
		if offsetY > contentHeight - scrollView.frame.size.height {
			loadMoreData()
		}
	}
	
	func loadMoreData () {
		guard dataLoading == false && dataAllLoaded == false else {
			return
		}
		updateInsertDataCount()
		insertData()
	}
	
	func insertData () {
		dataLoading = true
		var insertIndexPaths : [NSIndexPath] = []
		let start = dataDisplayed
		let total =  start + insertCount
		for (var i = start; i < total; i++) {
			insertIndexPaths.append(NSIndexPath(forItem: i, inSection: 0))
		}
		guard insertIndexPaths.count > 0 else {
			dataLoading = false
			dataAllLoaded = true
			return
		}
		
		dataDisplayed = dataDisplayed + insertCount
		collectionView.insertItemsAtIndexPaths(insertIndexPaths)
		dataLoading = false
		empty.disable()
	}
	
	func updateInsertDataCount () -> Int {
		guard dataLoading == false else {
			return dataDisplayed
		}
		
		let newCount = (data.count > dataIncrement + dataDisplayed) ? dataIncrement + dataDisplayed : data.count
		insertCount = newCount - dataDisplayed
		return newCount
	}
}

