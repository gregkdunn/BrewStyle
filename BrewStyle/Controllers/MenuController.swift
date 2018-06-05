//
//  MenuController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/9/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class MenuController: TableViewController {

	convenience init() {
		self.init(style: .Grouped)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.backgroundColor = AppStyle.SettingsMenu[.BackgroundColor]?.colorWithAlphaComponent(0.7)
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
		tableView.rowHeight = 44
		
		//Static Table View
		
		dataSource.sections = [
			Section(header: "2015 bjcp guidelines", rows: [
				Row(text: "guidelines", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showIntroduction()
					}),
				Row(text: "styles", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showSubCategories()
					}),
				Row(text: "by category", cellClass:Value2Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showCategories()
					}),
				Row(text: "by color", cellClass:Value2Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showSRM()
					}),
				Row(text: "by tag", cellClass:Value2Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showTags()
					}),

				Row(text: "glossary", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showTerms()
					})
			]),
		
			Section(header: "About", rows: [
				Row(text: "brew.style", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showAcknowledgements()
					}),
				Row(text: "privacy policy", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showPrivacy()
					}),
			]),


			Section( rows: [
				Row(text: "reset data", cellClass:Value1Cell.self, selection: { [unowned self] in
					self.resetData()
				})
			])
		]
	}	
	
	// MARK: - Private
	func showIntroduction() {
		showIntroduction(nil)
	}

	func showBeerIntroduction() {
		showIntroduction(.Beer)
	}
	
	func showSpecialtyIntroduction() {
		showIntroduction(.Specialty)
	}
	
	func showCiderIntroduction() {
		showIntroduction(.Cider)
	}
	
	func showMeadIntroduction() {
		showIntroduction(.Mead)
	}

	func showAcknowledgements() {
		showIntroduction(.Acknowledgements)
	}
	
	func showPrivacy() {
		showIntroduction(.Privacy)
	}
	
	func showCategories() {
		showCategoriesList()
	}
	
	func showSubCategories() {
		showSubCategoryList(nil)
	}
	
	func resetData() {
		closeSettings()
		if let main = AppDelegate.mainController {
				main.displayAlertView()
		}


		DefaultData().updateDefaults()
	}
	
	func iap() {
		
	}
	
	func closeSettings() {
		toggleSideMenuView()
	}
	
	
	func showMenu() {
		toggleSideMenuView()
	}
	
	func hideController() {
		self.dismissViewControllerAnimated(true) {
			//
		}
	}
	
	func showIntroduction (intro : Introductions?) {
		if let currentIntro = intro {
			let controller = IntroductionController(introduction: currentIntro)
			sideMenuController()?.setContentViewController(controller)
		} else {
			let controller = IntroductionController()
			sideMenuController()?.setContentViewController(controller)
		}
	}
	
	func showCategoriesList() {
		let controller = BeverageCategoryListingController()
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showSubCategoryList(categoryVM:BeverageCategoryViewModel?) {
		if let catVM = categoryVM {
			let controller = BeverageSubCategoryListingController(category: catVM)
			sideMenuController()?.setContentViewController(controller)
		} else {
			let controller = BeverageSubCategoryListingController()
			sideMenuController()?.setContentViewController(controller)
		}
	}
	
	func showSubCategoryDetail(subCategoryVM: BeverageSubCategoryViewModel) {
		let controller = BeverageSubCategoryDetailViewController(subCategory: subCategoryVM)
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showTagsListForSubCategory(subcategoryVM: BeverageSubCategoryViewModel) {
		let controller = TagListingController(subCategory: subcategoryVM)
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showSRM() {
		let controller = SRMListingController()
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showSRMDetail(srm : SRM) {
		let controller = SRMDetailController(srm: srm)
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showTags() {
		let controller = TagGlossaryController()
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showTagDetail(tagVM: TagViewModel) {
		let controller = TagDetailController(tagVM: tagVM)
		sideMenuController()?.setContentViewController(controller)
	}
	
	func showTerms() {
		let controller = TermListingController()
		sideMenuController()?.setContentViewController(controller)
	}
	
}
