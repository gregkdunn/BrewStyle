//
//  SRMListingController.swift
//  SwiftTabs
//
//  Created by Greg Dunn on 9/18/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

import Foundation

enum SRMCellIdentifiers : String {
	case header = "SRMDetail"
	case srm = "SRMListingCell"
}

enum SRMCollectionViewSections : Int {
	case SRM
}

class SRMListingController: GKDFilterableViewController {
	lazy var data : Array<SRM> = [SRM]()
	let headerTitle = "Colors"
	let headerDesc = "Standard Reference Method is one of several systems modern brewers use to specify beer color. Determination of the SRM value involves measuring the attenuation of light of a particular wavelength (430 nm) in passing through 1 cm of the beer, expressing the attenuation as an absorption and scaling the absorption by a constant (12.7 for SRM; 25 for EBC). The SRM (or EBC) number represents a single point in the absorption spectrum of beer."

	
	override func viewDidLoad() {
		super.viewDidLoad()		
		createSettingsButton()
		configueBackButton()
		createCollectionView()
		//createSubCategoryFilterMenu()
		reloadData()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	// MARK: Data
	override func reloadData() {
		empty.enable()
		resetDisplayedData()
		
		dataDisplayed = 0
		self.data.removeAll()
		collectionView.reloadData()

		ContentStore.sharedInstance.fetchSRMWithCompletionBlock{ (result: [SRM]) in
			self.data = self.showIncrement(result)
			if result.count > 0 {
				self.loadMoreData()
				self.empty.disable()
			} else {
				self.empty.noData()
			}
			
			self.refreshControl.endRefreshing()
		}
	}
	
	
	func showIncrement(result: [SRM]) -> [SRM]{
		var filtered : [SRM] = []
		for srm in result {
			if srm.isInt() {
				filtered.append(srm)
			}
		}
		return filtered
	}
	
	// MARK: Collection View
	override func createCollectionView () {		
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(SRMCell.self, forCellWithReuseIdentifier: SRMCellIdentifiers.srm.rawValue)
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SRMCellIdentifiers.header.rawValue)
		
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		//layout.estimatedItemSize = CGSize(width:collectionView.bounds.size.width, height:96)
		
		empty.configWithIcon(UIImage(named:"pint_stamped"),title:"loading", description: "colors")
		
		refreshControl.addTarget(self, action: "reloadData", forControlEvents: .ValueChanged)
	}
}

extension SRMListingController : UICollectionViewDataSource {
	
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		let sectionIdentifier : SRMCollectionViewSections = SRMCollectionViewSections.init(rawValue: section)!
		
		switch sectionIdentifier {
		case .SRM :
			return dataDisplayed
		}
	}
	
	// MARK - Header
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CategoryDetailView.sizeForText(headerDesc, width:collectionView.bounds.size.width)
	}

	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		let header : CategoryDetailView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SRMCellIdentifiers.header.rawValue, forIndexPath: indexPath) as! CategoryDetailView
		
		header.configWithTitle(headerTitle, description: headerDesc)
		return header as UICollectionReusableView
	}
	
	
	// MARK: - Cell
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell : UICollectionViewCell
		let sectionIdentifier : SRMCollectionViewSections = SRMCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
		case .SRM :
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(SRMCellIdentifiers.srm.rawValue, forIndexPath: indexPath)
			break
		}
		
		configCell(cell, indexPath: indexPath)
		return cell
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		let sectionIdentifier : SRMCollectionViewSections = SRMCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
		case .SRM :
			if let srmCell = cell as? SRMCell,
				let srm : SRM = data[indexPath.row] {
					srmCell.configWithSRM(srm, isHeader: false)
			}
		}
	}
	
}

extension SRMListingController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row > dataDisplayed {
			loadMoreData()
		}
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let sectionIdentifier : SRMCollectionViewSections = SRMCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
		case .SRM :
			return CGSize(width:standardWidth, height:60)
		}
	}
}

extension SRMListingController : UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let selectedSRM  : SRM = data[indexPath.row] else {
			return
		}
		
		self.navigationController?.showSRMDetail(selectedSRM)
	}
}

// Infinite Scrolling
extension SRMListingController : UIScrollViewDelegate {
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
	
	func resetDisplayedData () {
		dataLoading = false
		dataAllLoaded = false
		dataDisplayed = 0
		collectionView.setContentOffset(CGPointMake(0, -(self.collectionView.contentInset.top)), animated: true)
		collectionView.reloadSections(NSIndexSet(index: 0))
	}
}
