//
//  BeverageSubCategoryListingController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/12/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

import UIKit

enum SubCategoryCellIdentifiers : String {
	case blank = "blankListingCell"
	case PageHeader = "categoryDetail"
	case Header = "titleView"
	case subcategoryStat = "subCategoryStatCell"
	case subcategoryParent = "subCategoryParentListingCell"
}

enum SubCategoryCollectionViewSections : Int {
	case Category
	case SubCategories
}

class BeverageSubCategoryListingController: GKDFilterableViewController {
	var categoryVM : BeverageCategoryViewModel? = nil
	var data : Array<BeverageSubCategoryViewModel> = [BeverageSubCategoryViewModel]()
	
	//Cell Height Sizing
	private let sizingParentCell = TitleCell()
	private let sizingStatCell = SubcategoryStatCell()


	let tap = UITapGestureRecognizer()
	
	var searchTimer : NSTimer? = nil
	
	convenience init(category:BeverageCategoryViewModel ) {
		self.init(nibName: nil, bundle: nil)
		self.categoryVM = category
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configueBackButton()
		
		if let _ = categoryVM {
			// list one category
		} else {
			// list all subcategories
			createSettingsButton()
			searchBar.delegate = self
			navigationItem.titleView = searchBar
		}
		createCollectionView()
		createSubCategoryFilterMenu()
		
		GKDFilter.sharedInstance.resetSubcategoryFilter()
		GKDSort.sharedInstance.resetSubcategorySort()
		
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = UIEdgeInsetsZero

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: Constants.Notification.SubCategorySort, object: filterMenu)
		
		tap.addTarget(self, action: "toggleSortMenu")
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if(data.count == 0) {
			loadSubcategoryDataForCategory(self.categoryVM)
		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		searchBar.resignFirstResponder()
	}
		
	// MARK: Data
	func loadSubcategoryDataForCategory(categoryVM: BeverageCategoryViewModel?) {
		dataDisplayed = 0
		self.data.removeAll()
		collectionView.reloadData()
		
		let block = { (result: [BeverageSubCategoryViewModel]) in
			self.data = result
			if result.count > 0 {
				self.loadMoreData()
				self.empty.disable()
			} else {
				self.empty.noData()
			}
			self.refreshControl.endRefreshing()
		}

		if let category : BeverageCategory = categoryVM?.beverageCategory {
			filterMenu.configureWithCategory(categoryVM)
			BeverageStore.sharedInstance.fetchSubCategoriesForCategory(category, block: block)
		} else {
			BeverageStore.sharedInstance.fetchSubCategoriesWithCompletionBlock(block)
		}
	}
	
	override func reloadData() {
		if !dataLoading {
			empty.enable()
			resetDisplayedData()
			loadSubcategoryDataForCategory(categoryVM)
		}

	}
	
	// MARK: Collection View
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 72, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(TitleCell.self, forCellWithReuseIdentifier: SubCategoryCellIdentifiers.subcategoryParent.rawValue)
		collectionView.registerClass(SubcategoryStatCell.self, forCellWithReuseIdentifier: SubCategoryCellIdentifiers.subcategoryStat.rawValue)
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SubCategoryCellIdentifiers.PageHeader.rawValue)
		collectionView.registerClass(TitleView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SubCategoryCellIdentifiers.Header.rawValue)
		empty.configWithIcon(UIImage(named:"pint_stamped"),title:"loading", description: "beer styles")
		
		refreshControl.addTarget(self, action: "reloadData", forControlEvents: .ValueChanged)
	}
}

// MARK:  UICollectionViewDataSource
extension BeverageSubCategoryListingController : UICollectionViewDataSource {
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return  2;
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionIdentifier : SubCategoryCollectionViewSections = SubCategoryCollectionViewSections.init(rawValue: section)!
		
		switch sectionIdentifier {
			case .Category :
				return 1
			case .SubCategories :
				return 	dataDisplayed
		}
	}
	
	// MARK - Header
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		if(section > 0) {
			return CGSize(width: standardWidth, height: 56)
		}
		return CGSize(width: standardWidth, height: 0)
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		if let sectionIdentifier : SubCategoryDetailCollectionViewSections = SubCategoryDetailCollectionViewSections(rawValue: indexPath.section) {
				switch sectionIdentifier {
					case .Title :
						let hdr = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.PageHeader.rawValue, forIndexPath: indexPath) as! CategoryDetailView
						return hdr
					default :
						let hdr = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.Header.rawValue, forIndexPath: indexPath) as! TitleView
						
						hdr.configWithTitle("Styles :", category: GKDSort.sharedInstance.displaySubCategorySortString())
						
						hdr.addGestureRecognizer(tap)
						
						
						return hdr
				}
		}
		
		return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.PageHeader.rawValue, forIndexPath: indexPath) as! CategoryDetailView
	}
	
	
	// MARK: - Cell
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell : UICollectionViewCell
		let sectionIdentifier : SubCategoryCollectionViewSections = SubCategoryCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Category :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryCellIdentifiers.subcategoryParent.rawValue, forIndexPath: indexPath)
			
			case .SubCategories :
				if let _ : BeverageSubCategoryViewModel = data[indexPath.row] {
					cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryCellIdentifiers.subcategoryStat.rawValue, forIndexPath: indexPath)
				} else {
					cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryCellIdentifiers.blank.rawValue, forIndexPath: indexPath)
				}
		}
		
		configCell(cell, indexPath: indexPath)
		return cell
	}
	
	func shouldUseStatCell (subCategoryVM: BeverageSubCategoryViewModel) -> Bool {
		return true //!subCategoryVM.isMead()
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		let sectionIdentifier : SubCategoryCollectionViewSections = SubCategoryCollectionViewSections(rawValue: indexPath.section)!
		var currentData = data
		
		switch sectionIdentifier {
			case .Category :
				if let categoryListingCell = cell as? TitleCell {
					if let catVM = categoryVM {
						categoryListingCell.configWithBeverageCategoryViewModel(catVM)
					} else {
						categoryListingCell.configWithTitle("Styles", desciption: "Styles identify the major characteristic of one type of beer, mead or cider. Each style has a well-defined description, which is the basic tool used during judging.")
						

					}
				}
			case .SubCategories :
				if let subCategoryListingCell = cell as? TitleCell,
					let subCategoryVM : BeverageSubCategoryViewModel = currentData[indexPath.row] {
						subCategoryListingCell.cellWidth = standardWidth
						subCategoryListingCell.configWithBeverageSubCategoryViewModel(subCategoryVM)
				}
	
				if let subCategoryListingCell = cell as? SubcategoryStatCell,
					let subCategoryVM : BeverageSubCategoryViewModel = currentData[indexPath.row] {
						subCategoryListingCell.cellWidth = standardWidth
						subCategoryListingCell.configWithBeverageSubCategoryViewModel(subCategoryVM, showInset: categoryVM != nil)
				}
		}
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension BeverageSubCategoryListingController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let sectionIdentifier : SubCategoryCollectionViewSections = SubCategoryCollectionViewSections(rawValue: indexPath.section)!
		
		var currentData = data
		
		switch sectionIdentifier {
			case .Category :
				if let catVM = categoryVM {
					sizingParentCell.prepareForReuse()
					sizingParentCell.cellWidth = collectionView.bounds.size.width - 2
					sizingParentCell.configWithBeverageCategoryViewModel(catVM)
					////print("parent >>> \(sizingParentCell.intrinsicContentSize())")
					return sizingParentCell.intrinsicContentSize()
				} else {
					return CGSize(width:collectionView.bounds.size.width - 2, height:174)
				}
			case .SubCategories :
				if var subCategoryVM : BeverageSubCategoryViewModel = currentData[indexPath.row] {
					//if subCategoryVM.landscapeSize.width == CGFloat(0) && subCategoryVM.landscapeSize.height == CGFloat(0) {
						subCategoryVM.landscapeSize =  CGSize(width:standardWidth, height:204)
						data[indexPath.row] = subCategoryVM
					//}
					//print("returned \(indexPath.row) : stat>>> \(subCategoryVM.landscapeSize)")
					
					return subCategoryVM.landscapeSize
				}
		}
		return CGSize(width:collectionView.bounds.size.width, height:204)
	}
}

// MARK:  UICollectionViewDelegate
extension BeverageSubCategoryListingController : UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if isOpen {
			return
		}
		
		let sectionIdentifier : SubCategoryCollectionViewSections = SubCategoryCollectionViewSections(rawValue: indexPath.section)!
		if sectionIdentifier == .SubCategories {
			guard let selectedSubCategoryVM  : BeverageSubCategoryViewModel = data[indexPath.row] else {
				return
			}
			self.navigationController?.showSubCategoryDetail(selectedSubCategoryVM)
		}
	}
}

extension BeverageSubCategoryListingController : UIScrollViewDelegate {

// Search
	func scrollViewWillBeginDragging(scrollView: UIScrollView)
	{
		//dismiss the keyboard if the search results are scrolled
		searchBar.resignFirstResponder()
	}
	
// Infinite Scrolling
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
		guard insertCount >= 0 else {
			return
		}
		
		dataLoading = true
		var insertIndexPaths : [NSIndexPath] = []
		let start = dataDisplayed
		let total =  start + insertCount
		for (var i = start; i < total; i++) {
			insertIndexPaths.append(NSIndexPath(forItem: i, inSection: 1))
		}
		guard insertIndexPaths.count > 0 else {
			dataLoading = false
			dataAllLoaded = true
			return
		}
		dataDisplayed = dataDisplayed + insertCount
		//print(">>>INSERTING")
		collectionView.insertItemsAtIndexPaths(insertIndexPaths)
		dataLoading = false
		
		collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1) ])
		
	}
	
	func updateInsertDataCount () -> Int {
		guard dataLoading == false else {
			return dataDisplayed
		}
		
		let newCount = (data.count > dataIncrement + dataDisplayed) ? dataIncrement + dataDisplayed : data.count
		insertCount = newCount - dataDisplayed
		return newCount
	}
	
	func resetDisplayedData () {
		dataLoading = false
		dataAllLoaded = false
		dataDisplayed = 0
		collectionView.setContentOffset(CGPointMake(0, -(self.collectionView.contentInset.top)), animated: true)
		collectionView.reloadSections(NSIndexSet(index: 1))
	}
}

//MARK Search

extension BeverageSubCategoryListingController : UISearchBarDelegate {

	func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
		return true
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		GKDFilter.sharedInstance.subCategoryKeyword = searchText
	}
	
	func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		searchTimer?.invalidate()
		searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("performSearch:"), userInfo: searchBar, repeats: false)
		return true
	}
	
	func performSearch(timer: NSTimer) {
		reloadData()
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
