//
//  BeverageCategoryListingController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 4/25/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

import UIKit

enum CategoryCellIdentifiers : String {
	case header = "overview"
	case category = "CategoryListingCell"
}

enum CategoryCollectionViewSections : Int {
	case Categories
}

class BeverageCategoryListingController: GKDFilterableViewController {
	lazy var data : Array<BeverageCategoryViewModel> = [BeverageCategoryViewModel]()
	let titleString = "Categories"
	let descString  = "Categories are arbitrary groupings of beer, mead, or cider styles, usually with similar characteristics but some subcategories are not necessarily related to others within the same category. The purpose of the structure within the BJCP Style Guidelines is to group styles of beer, mead and cider to facilitate judging during competitions; do not attempt to derive additional meaning from these groupings. No historical or geographic association is implied."
	
	override func viewDidLoad() {
		super.viewDidLoad()
		createSettingsButton()
		configueBackButton()
		createCollectionView()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if data.count == 0 {
			reloadData()
		}
	}

	// MARK: Data
	override func reloadData () {
		empty.enable()
		dataDisplayed = 0
		self.data.removeAll()
		collectionView.reloadData()
		
		BeverageStore.sharedInstance.fetchCategoriesWithCompletionBlock {
			(result: [BeverageCategoryViewModel]) in
			self.data = result
			if result.count > 0 {
				self.loadMoreData()
				self.empty.disable()				
			} else {
				self.empty.noData()
			}
			self.refreshControl.endRefreshing()
		}
	}
	
	// MARK: Collection View
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self		
		collectionView.registerClass(CategoryListingCell.self, forCellWithReuseIdentifier: CategoryCellIdentifiers.category.rawValue)
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: CategoryCellIdentifiers.header.rawValue)
	
		empty.configWithIcon(UIImage(named:"pint_stamped"),title:"loading", description: "beer categories")
		
		refreshControl.addTarget(self, action: "reloadData", forControlEvents: .ValueChanged)
	}
}

extension BeverageCategoryListingController : UICollectionViewDataSource {
	
	// MARK - Header
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CategoryDetailView.sizeForText(descString, width: collectionView.bounds.width)
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		let header : CategoryDetailView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: CategoryCellIdentifiers.header.rawValue, forIndexPath: indexPath) as! CategoryDetailView
		
			header.titleLabel.text = titleString
			header.descLabel.text  = descString
		
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
		if let categoryListingCell = cell as? CategoryListingCell,
		   let categoryVM : BeverageCategoryViewModel = data[indexPath.row] {
				categoryListingCell.configWithBeverageCategoryViewModel(categoryVM)
		}
	}
}

extension BeverageCategoryListingController : UICollectionViewDelegate {

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let selectedCategoryVM  : BeverageCategoryViewModel = data[indexPath.row] else {
			return
		}
		self.navigationController?.showSubCategoryList(selectedCategoryVM)
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension BeverageCategoryListingController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
			//print("will display \(indexPath.row) >= \(dataDisplayed)")
		if indexPath.row >= dataDisplayed - 1 {
			//print("at the bottom \(indexPath.row) >= \(dataDisplayed)")
			loadMoreData()
		}
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		if let _ : BeverageCategoryViewModel = data[indexPath.row] {
			return CGSizeMake(standardWidth, 55)
		}
		
		return CGSize(width: standardWidth, height: 55)
	}

}

// Infinite Scrolling
extension BeverageCategoryListingController : UIScrollViewDelegate {
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