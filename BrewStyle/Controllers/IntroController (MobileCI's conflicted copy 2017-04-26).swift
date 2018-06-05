//
//  IntroController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/21/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

enum IntroductionCellIdentifiers : String {
	case Content = "multicolumnCell"
}

enum Introductions : Int {
	case Guidelines
	case Beer
	case Specialty
	case Cider
	case Mead
	case Acknowledgements
	
	var name : String {
		var name = ""
		switch self {
			case .Guidelines :
				name = "2015 Guidelines"
			case .Beer :
				name = "Beer"
			case .Specialty :
				name = "Specialty-Type Beer"
			case Cider :
				name = "Cider"
			case Mead :
				name = "Mead"
		case Acknowledgements :
			name = "Acknowledgements"
		}
		return name
	}
}

enum IntroductionCollectionViewSections : Int {
	case Intro = 0
}

class IntroductionController : GKDFilterableViewController {
	var currentIntro : Introductions = .Guidelines
	var data : Introduction?
	private let sizingMCCell = MultiColumnCell()
	
	convenience init(introduction: Introductions ) {
		self.init(nibName: nil, bundle: nil)
		currentIntro = introduction
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		navigationController?.navigationBarHidden = false
		
		loadIntroduction()
		
		super.viewDidLoad()
		createSettingsButton()
		configueBackButton()
		createCollectionView()
	}
	
	func loadIntroduction() {
		
		ContentStore.sharedInstance.fetchIntroductionForName(currentIntro.name) { (result) -> Void in
			self.data = result
			self.collectionView.reloadData()
		}
	}
	
	
	// MARK: Collection View
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(MultiColumnCell.self, forCellWithReuseIdentifier: IntroductionCellIdentifiers.Content.rawValue)
		empty.configWithIcon(UIImage(named:"pint_beer_white_2"),title:"loading", description: "introduction")
	}
}

extension IntroductionController : UICollectionViewDataSource {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
 
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let _ = data {
			return 1
		}
		return 0
	}
	
	// MARK: - Cell
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell : UICollectionViewCell
		let sectionIdentifier : IntroductionCollectionViewSections = IntroductionCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
		default :
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(IntroductionCellIdentifiers.Content.rawValue, forIndexPath: indexPath)
		}
		
		configCell(cell, indexPath: indexPath)
		return cell
	}
	
	func configCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
		
		let sectionIdentifier : IntroductionCollectionViewSections = IntroductionCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
		default :
			if let mcCell = cell as? MultiColumnCell,
			intro = data {
				mcCell.cellWidth = collectionView.bounds.width
				mcCell.configWithTitle(intro.name, content:intro.contentAttributedString())
			}
		}
	}
}

extension IntroductionController : UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		// 
	}
}

// MARK:  UICollectionViewDelegateFlowLayout
extension IntroductionController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		let sectionIdentifier : IntroductionCollectionViewSections = IntroductionCollectionViewSections(rawValue: indexPath.section)!
		
		switch sectionIdentifier {
			default :
				if let intro = data {
					sizingMCCell.prepareForReuse()
					sizingMCCell.cellWidth = collectionView.bounds.width
					sizingMCCell.configWithTitle(intro.name, content:intro.contentAttributedString())
					self.empty.disable()
					return sizingMCCell.intrinsicContentSize()
				}
		}
		return CGSizeZero
	}
}
