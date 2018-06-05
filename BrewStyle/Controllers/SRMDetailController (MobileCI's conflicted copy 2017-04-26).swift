//
//  SRMDetailController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/12/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum SRMDetailCellIdentifiers : String {
	case blank = "blankListingCell"
	case srm = "SRMListingCell"
	case Header = "titleView"
	case subcategoryStat = "subCategoryStatCell"

}

enum SRMDetailCollectionViewSections : Int {
	case SRM
	case SubCategories
}

class SRMDetailController: GKDFilterableViewController {
	var srm : SRM? = nil
	var data : Array<BeverageSubCategoryViewModel> = [BeverageSubCategoryViewModel]()
	
	//Cell Height Sizing
	private var standardWidth : CGFloat {
		return UIScreen.mainScreen().bounds.width
	}

	let tap = UITapGestureRecognizer()
		
	convenience init(srm: SRM ) {
			self.init(nibName: nil, bundle: nil)
			self.srm = srm
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
		
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = UIEdgeInsetsZero
		
		createCollectionView()
		createFilterMenu()
		
		GKDFilter.sharedInstance.resetSubcategoryFilter()
		GKDSort.sharedInstance.resetSubcategorySort()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"reloadData", name:Constants.Notification.DefaultsVersion, object:nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: Constants.Notification.SubCategorySort, object: filterMenu)
		
		tap.addTarget(self, action: "toggleSortMenu")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if(data.count == 0) {
			loadSubcategoryDataForSRM(self.srm)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
		
	// MARK: Data
	func loadSubcategoryDataForSRM(srm : SRM?) {
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
		}
		
		if let val = srm {
			BeverageStore.sharedInstance.fetchSubCategoriesForSRM(val, block: block)
		}
	}
	
	func reloadData() {
		empty.enable()
		resetDisplayedData()
		if dataLoading {
			let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
			dispatch_after(time, dispatch_get_main_queue()) {
				self.reloadData()
			}
		} else {
			loadSubcategoryDataForSRM(self.srm)
		}
		
	}
	
	// MARK: Collection View
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(SRMCell.self, forCellWithReuseIdentifier: SRMCellIdentifiers.srm.rawValue)
		collectionView.registerClass(SubcategoryStatCell.self, forCellWithReuseIdentifier: SubCategoryCellIdentifiers.subcategoryStat.rawValue)
		collectionView.registerClass(TitleView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SubCategoryCellIdentifiers.Header.rawValue)
		empty.configWithIcon(UIImage(named:"pint_beer_white_2"),title:"loading", description: "beer styles")
	}
}

// MARK:  UICollectionViewDataSource
extension SRMDetailController : UICollectionViewDataSource {
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return  2;
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionIdentifier : SRMDetailCollectionViewSections = SRMDetailCollectionViewSections.init(rawValue: section)!
		
		switch sectionIdentifier {
		case .SRM :
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
			default :
				let hdr = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.Header.rawValue, forIndexPath: indexPath) as! TitleView
				hdr.configWithTitle("styles :", category: GKDSort.sharedInstance.displaySubCategorySortString())
				
				hdr.addGestureRecognizer(tap)
				
				
				return hdr
			}
		}
		
		return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.PageHeader.rawValue, forIndexPath: indexPath) as! CategoryDetailView
	}
	
	
	// MARK: - Cell
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell : UICollectionViewCell
		let sectionIdentifier : SRMDetailCollectionViewSections = SRMDetailCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .SRM :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SRMCellIdentifiers.srm.rawValue, forIndexPath: indexPath)
				break
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
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		let sectionIdentifier : SRMDetailCollectionViewSections = SRMDetailCollectionViewSections(rawValue: indexPath.section)!
		var currentData = data
		
		switch sectionIdentifier {
		case .SRM :
			if let srmCell = cell as? SRMCell,
				let srm : SRM = self.srm {
					srmCell.configWithSRM(srm, isHeader: true)
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
					subCategoryListingCell.configWithBeverageSubCategoryViewModel(subCategoryVM, showInset: true)
			}
		}
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension SRMDetailController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let sectionIdentifier : SRMDetailCollectionViewSections = SRMDetailCollectionViewSections(rawValue: indexPath.section)!
		
		var currentData = data
		
		switch sectionIdentifier {
		case .SRM :
			if let _ = self.srm {
				return CGSize(width:collectionView.bounds.size.width, height:96)
			} else {
				return CGSizeZero
			}
		case .SubCategories :
			
			if var subCategoryVM : BeverageSubCategoryViewModel = currentData[indexPath.row] {
				if subCategoryVM.landscapeSize.width == CGFloat(0) && subCategoryVM.landscapeSize.height == CGFloat(0) {
					subCategoryVM.landscapeSize =  CGSize(width:collectionView.bounds.size.width, height:204)
					data[indexPath.row] = subCategoryVM
				}
				print("returned \(indexPath.row) : stat>>> \(subCategoryVM.landscapeSize)")
				
				return subCategoryVM.landscapeSize
			}
		}
		return CGSize(width:collectionView.bounds.size.width, height:204)
	}
	
}

// MARK:  UICollectionViewDelegate
extension SRMDetailController : UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if isOpen {
			return
		}
		
		let sectionIdentifier : SRMDetailCollectionViewSections = SRMDetailCollectionViewSections(rawValue: indexPath.section)!
		if sectionIdentifier == .SubCategories {
			guard let selectedSubCategoryVM  : BeverageSubCategoryViewModel = data[indexPath.row] else {
				return
			}
			self.navigationController?.showSubCategoryDetail(selectedSubCategoryVM)
		}
	}
}

extension SRMDetailController : UIScrollViewDelegate {
	
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
		print(">>>INSERTING")
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

