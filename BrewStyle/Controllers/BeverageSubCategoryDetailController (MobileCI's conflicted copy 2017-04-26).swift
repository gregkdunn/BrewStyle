//
//  BeverageSubCategoryDetailController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/20/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum SubCategoryDetailCellIdentifiers : String {
	case Blank = "blankListingCell"
	case PageHeader = "categoryDetail"
	case Header = "titleView"
	case Title = "TitleCell"
	case Ranges = "subCategoryRangesCell"
	case Appearance = "subCategoryAppearance"
	case Tags = "subCategoryTags"
	case Description = "subCategoryDescriptionCell"
}

enum SubCategoryDetailCollectionViewSections: Int {
	case Title = 0
	case Ranges
	case OverallImpression
	case Aroma
	case Appearance
	case Flavor
	case Mouthfeel
	case Comments
	case History
	case CharacteristicIngredients
	case StyleComparison
	case EntryInstructions
	case Varieties
	case Classifications
	case CommercialExamples
	case Tags
	
	func title(subCategoryVM: BeverageSubCategoryViewModel) -> String {
		var title = ""
		switch self {
		case .Title :
			title = subCategoryVM.nameTitle()
		case Ranges :
			title = subCategoryVM.RangesTitle()
		case .OverallImpression :
			title = subCategoryVM.overallImpressionTitle()
		case .Aroma :
			title = subCategoryVM.aromaTitle()
		case .Appearance :
			title = subCategoryVM.appearanceTitle()
		case .Flavor :
			title = subCategoryVM.flavorTitle()
		case .Mouthfeel :
			title = subCategoryVM.mouthfeelTitle()
		case .Comments :
			title = subCategoryVM.commentsTitle()
		case .History :
			title = subCategoryVM.historyTitle()
		case .CharacteristicIngredients :
			title = subCategoryVM.characteristicIngredientsTitle()
		case .StyleComparison :
			title = subCategoryVM.styleComparisonTitle()
		case .EntryInstructions :
			title = subCategoryVM.entryInstructionsTitle()
		case .Varieties :
			title = subCategoryVM.varietiesTitle()
		case .Classifications :
			title = subCategoryVM.classificationsTitle()
		case .CommercialExamples :
			title = subCategoryVM.commercialExamplesTitle()
		case .Tags :
			title = subCategoryVM.tagsTitle()
		}
		return title
	}
	
	func desc(subCategoryVM: BeverageSubCategoryViewModel) -> String {
		var description = ""
		switch self {
			case .Title :
				description = subCategoryVM.name()
			case .OverallImpression :
				description = subCategoryVM.overallImpression()
			case .Aroma :
				description = subCategoryVM.aroma()
			case .Appearance :
				description = subCategoryVM.appearance()
			case .Flavor :
				description = subCategoryVM.flavor()
			case .Mouthfeel :
				description = subCategoryVM.mouthfeel()
			case .Comments :
				description = subCategoryVM.comments()
			case .History :
				description = subCategoryVM.history()
			case .CharacteristicIngredients :
				description = subCategoryVM.characteristicIngredients()
			case .StyleComparison :
				description = subCategoryVM.styleComparison()
			case .EntryInstructions :
				description = subCategoryVM.entryInstructions()
			case .Varieties :
				description = subCategoryVM.varieties()
			case .Classifications :
				description = subCategoryVM.classifications()
			case .CommercialExamples :
				description = subCategoryVM.commercialExamples()
			case .Tags :
				description = subCategoryVM.tags()
			default :
				description = ""
		}
		return description
	}
}

class BeverageSubCategoryDetailViewController: GKDFilterableViewController {
	var subCategoryVM : BeverageSubCategoryViewModel? = nil
	private let sizingTitleCell = TitleCell()
	private let sizingRangesCell = SubcategoryRangesCell()
	private let sizingAppearanceCell = SubcategoryAppearanceCell()
	private let sizingTagsCell = SubcategoryTagsCell()
	private let sizingDescCell = SubcategoryDescriptionCell()
	
	convenience init(subCategory:BeverageSubCategoryViewModel ) {
		self.init(nibName: nil, bundle: nil)
		self.subCategoryVM = subCategory
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		navigationController?.navigationBarHidden = false
		
		super.viewDidLoad()
		configueBackButton()
		createCollectionView()
	}

	// MARK: Collection View
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self		
		collectionView.registerClass(CategoryDetailView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SubCategoryDetailCellIdentifiers.PageHeader.rawValue)
		collectionView.registerClass(TitleView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: SubCategoryDetailCellIdentifiers.Header.rawValue)
		collectionView.registerClass(TitleCell.self, forCellWithReuseIdentifier: SubCategoryDetailCellIdentifiers.Title.rawValue)
		collectionView.registerClass(SubcategoryRangesCell.self, forCellWithReuseIdentifier: SubCategoryDetailCellIdentifiers.Ranges.rawValue)
		collectionView.registerClass(SubcategoryAppearanceCell.self, forCellWithReuseIdentifier: SubCategoryDetailCellIdentifiers.Appearance.rawValue)
		collectionView.registerClass(SubcategoryTagsCell.self, forCellWithReuseIdentifier: SubCategoryDetailCellIdentifiers.Tags.rawValue)
		collectionView.registerClass(SubcategoryDescriptionCell.self, forCellWithReuseIdentifier: SubCategoryDetailCellIdentifiers.Description.rawValue)
		empty.configWithIcon(UIImage(named:"pint_beer_white_2"),title:"loading", description: "beer style")
	}
}

// MARK:  UICollectionViewDataSource
extension BeverageSubCategoryDetailViewController : UICollectionViewDataSource {
	
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return (SubCategoryDetailCollectionViewSections.Tags.rawValue) + 1
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	// MARK - Header
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		if let sectionIdentifier : SubCategoryDetailCollectionViewSections = SubCategoryDetailCollectionViewSections(rawValue: indexPath.section),
		   let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
			switch sectionIdentifier {
				case .Title :
					let hdr = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.PageHeader.rawValue, forIndexPath: indexPath) as! CategoryDetailView
					return hdr
				default :
					let hdr = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.Header.rawValue, forIndexPath: indexPath) as! TitleView
					hdr.configWithTitle(sectionIdentifier.title(subCatVM), category: nil)
					return hdr
				}
		}
		return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SubCategoryDetailCellIdentifiers.PageHeader.rawValue, forIndexPath: indexPath) as! CategoryDetailView
	}
	
	
	// MARK: - Cell
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell : UICollectionViewCell
		let sectionIdentifier : SubCategoryDetailCollectionViewSections = SubCategoryDetailCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Title :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryDetailCellIdentifiers.Title.rawValue, forIndexPath: indexPath)
			case .Ranges :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryDetailCellIdentifiers.Ranges.rawValue, forIndexPath: indexPath)
			case .Appearance :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryDetailCellIdentifiers.Appearance.rawValue, forIndexPath: indexPath)
			case .Tags :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryDetailCellIdentifiers.Tags.rawValue, forIndexPath: indexPath)
			default :
				cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubCategoryDetailCellIdentifiers.Description.rawValue, forIndexPath: indexPath)
		}
		
		configCell(cell, indexPath: indexPath)
		return cell
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		
		let sectionIdentifier : SubCategoryDetailCollectionViewSections = SubCategoryDetailCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Title :
				if let titleCell = cell as? TitleCell,
					let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
						titleCell.cellWidth = collectionView.bounds.width - 16
						titleCell.configWithBeverageSubCategoryViewModel(subCatVM)
				}
			case .Ranges :
				if let rangesCell = cell as? SubcategoryRangesCell,
					let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
						rangesCell.cellWidth = collectionView.bounds.width - 16
						rangesCell.configWithBeverageSubCategoryViewModel(subCatVM)
				}

			case .Appearance :
				if let appearanceCell = cell as? SubcategoryAppearanceCell,
					let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
						appearanceCell.cellWidth = collectionView.bounds.width - 16
						appearanceCell.configWithBeverageSubCategoryViewModel(subCatVM)
				}
			case .Tags :
				if let tagsCell = cell as? SubcategoryTagsCell,
					let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
						tagsCell.cellWidth = collectionView.bounds.width - 16
						tagsCell.configWithBeverageSubCategoryViewModel(subCatVM)
						self.empty.disable()
				}
			default :
				if let descCell = cell as? SubcategoryDescriptionCell,
					let subCatVM : BeverageSubCategoryViewModel = subCategoryVM {
						descCell.cellWidth = collectionView.bounds.width - 16
						descCell.configWithDescription(sectionIdentifier.desc(subCatVM))
				}
		}
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension BeverageSubCategoryDetailViewController : UICollectionViewDelegateFlowLayout {
	
	// Header
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		if(section > 0) {
			return CGSize(width: collectionView.bounds.width, height: 44)
		}
		return CGSize(width: collectionView.bounds.width, height: 0)
	}
	
	// Cell
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let sectionIdentifier : SubCategoryDetailCollectionViewSections = SubCategoryDetailCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			case .Title :
				if let subCatVM = subCategoryVM {
					sizingTitleCell.prepareForReuse()
					sizingTitleCell.cellWidth = collectionView.bounds.width - 2
					sizingTitleCell.configWithBeverageSubCategoryViewModel(subCatVM)
					//print("Title >>> \(sizingTitleCell.intrinsicContentSize())")
					return sizingTitleCell.intrinsicContentSize()
				}
			case .Ranges :
				if let subCatVM = subCategoryVM {
					sizingRangesCell.prepareForReuse()
					sizingRangesCell.cellWidth = collectionView.bounds.width - 2
					sizingRangesCell.configWithBeverageSubCategoryViewModel(subCatVM)
					//print("Ranges >>> \(sizingRangesCell.intrinsicContentSize())")
					return sizingRangesCell.intrinsicContentSize()
				}
			case .Appearance :
				if let subCatVM = subCategoryVM {
					sizingAppearanceCell.prepareForReuse()
					sizingAppearanceCell.cellWidth = collectionView.bounds.width - 2
					sizingAppearanceCell.configWithBeverageSubCategoryViewModel(subCatVM)
					//print("Appearance >>> \(sizingAppearanceCell.intrinsicContentSize())")
					return sizingAppearanceCell.intrinsicContentSize()

				}
			case .Tags :
				if let subCatVM = subCategoryVM {
					sizingTagsCell.prepareForReuse()
					sizingTagsCell.cellWidth = collectionView.bounds.width - 2
					sizingTagsCell.configWithBeverageSubCategoryViewModel(subCatVM)
					//print("Tags >>> \(sizingTagsCell.intrinsicContentSize())")
					return sizingTagsCell.intrinsicContentSize()
				}
			default :
				if let subCatVM = subCategoryVM {
					sizingDescCell.prepareForReuse()
					sizingDescCell.cellWidth = collectionView.bounds.width - 2
					sizingDescCell.configWithDescription(sectionIdentifier.desc(subCatVM))
					//print("Desc >>> \(sizingDescCell.intrinsicContentSize())")
					return sizingDescCell.intrinsicContentSize()
				}
		}
		return CGSize(width: collectionView.bounds.width - 2, height: 100)
	}
}

// MARK:  UICollectionViewDelegate
extension BeverageSubCategoryDetailViewController : UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if isOpen {
			return
		}
		
		if let sectionIdentifier : SubCategoryDetailCollectionViewSections = SubCategoryDetailCollectionViewSections(rawValue: indexPath.section),
		   let subcatVM = subCategoryVM {
				if sectionIdentifier == .Tags {
					self.navigationController?.showTagsListForSubCategory(subcatVM)
				}
		}

	}
}