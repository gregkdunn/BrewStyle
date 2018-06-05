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
	case Privacy
	
	static var allCases : [Introductions] {
		return [Guidelines, Beer, Specialty, Cider, Mead]
	}
	
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
			case Privacy :
				name = "Privacy"
		}
		return name
	}

	var title : String {
		var title = ""
		switch self {
		case .Guidelines :
			title = "intro"
		case .Beer :
			title = "beer"
		case .Specialty :
			title = "specialty"
		case Cider :
			title = "cider"
		case Mead :
			title = "mead"
		case Acknowledgements :
			title = "thanks"
		case Privacy :
			title = "privacy"
		}
		return title
	}
}

enum IntroductionCollectionViewSections : Int {
	case Intro = 0
}

class IntroductionController : GKDFilterableViewController {
	let typeIndicator = UIImageView(image: UIImage(named: "triangle_slate"))
	
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
		super.viewDidLoad()
		createSettingsButton()
		//configueBackButton()
		if(currentIntro != .Acknowledgements && currentIntro != .Privacy) {
			createIntroSelector()
		}

		createCollectionView() 
	}
	
	func loadIntroduction() {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			ContentStore.sharedInstance.fetchIntroductionForName(self.currentIntro.name) { (result) -> Void in
				self.data = result
				result.fetchContentData()
				dispatch_async(dispatch_get_main_queue()) {
					self.collectionView.reloadData()
					self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top , animated: true)
					self.refreshControl.endRefreshing()
				}
			}
		}
	}
	
	override func reloadData() {
		empty.enable()
		loadIntroduction()
	}
	
	
	func createIntroSelector() {
		let contentSwitcher = UISegmentedControl()
		contentSwitcher.tintColor = AppColor.Black.color
		contentSwitcher.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
		contentSwitcher.addTarget(self, action: "switchIntro:", forControlEvents: .ValueChanged)
		var index = 0
		for field in Introductions.allCases {
			contentSwitcher.insertSegmentWithTitle(field.title, atIndex: index, animated: false)
			index++
		}
		
		if let selected = Introductions.allCases.indexOf(currentIntro) {
			contentSwitcher.selectedSegmentIndex = selected
		}		
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "previousIntro", name: "previousIntro", object: nil)		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "nextIntro", name: "nextIntro", object: nil)
		
		
		navigationItem.titleView = contentSwitcher
	}
	
	func previousIntro() {
		if let current = Introductions.allCases.indexOf(currentIntro) {
			var prev = 0
		
			if current > 0 {
				prev = current - 1
			} else {
				prev = Introductions.allCases.count - 1
			}
			
			if let newIntro = Introductions(rawValue: prev) {
				currentIntro = newIntro
				loadIntroduction()
			}
		}

	}
	
	func nextIntro() {
		if let current = Introductions.allCases.indexOf(currentIntro) {
			var next = 0
			
			if current > Introductions.allCases.count - 1 {
				next = current + 1
			} else {
				next = 0
			}
			
			if let newIntro = Introductions(rawValue: next) {
				currentIntro = newIntro
				loadIntroduction()
			}
		}
	}
	
	func switchIntro(sender: UISegmentedControl) {
		data = nil
		empty.enable()
		collectionView.reloadData()
		
		if let newIntro = Introductions(rawValue: sender.selectedSegmentIndex) {
			currentIntro = newIntro
			loadIntroduction()
		}
	}
	
	// MARK: Collection View
	override func createCollectionView () {
		super.createCollectionView()
		collectionView.contentInset = UIEdgeInsets(top: 72, left: 0, bottom: 24, right: 0)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(MultiColumnCell.self, forCellWithReuseIdentifier: IntroductionCellIdentifiers.Content.rawValue)
		empty.configWithIcon(UIImage(named:"pint_stamped"),title:"loading", description: "introduction")
		refreshControl.addTarget(self, action: "reloadData", forControlEvents: .ValueChanged)
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
		loadIntroduction()
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
				
				mcCell.cellWidth = collectionView.bounds.width - 2
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
					sizingMCCell.cellWidth = collectionView.bounds.width - 2
					sizingMCCell.configWithTitle(intro.name, content:intro.contentAttributedString())
					self.empty.disable()
					return sizingMCCell.intrinsicContentSize()
				}
		}
		return CGSizeZero
	}
}
