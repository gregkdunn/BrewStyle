//
//  MenuController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/9/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class MenuController: TableViewController {
	var navController : MainViewController?
	
	
	// MARK: - Initializers
	
	convenience init() {
		self.init(style: .Grouped)
	}
	
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.backgroundColor = AppColor.Blue.color
		tableView.rowHeight = 44
		
		dataSource.sections = [
			Section(rows: [
				Row(text: "Close", cellClass:Value1Cell.self ,selection: { [unowned self] in
					self.closeSettings()
					})
				]),
			Section(header: "Styles", rows: [
				Row(text: "All Styles", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showSubCategories()
					}),
				Row(text: "By Category", cellClass:Value2Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showCategories()
					}),
				Row(text: "By Color", cellClass:Value2Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showSRM()
					}),
				Row(text: "By Tag", cellClass:Value2Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showTags()
					})
				]),
			Section(header: "Guidelines", rows: [
				Row(text: "2015 Introduction", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showIntroduction()
					}),
				Row(text: "Beer Styles", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showBeerIntroduction()
					}),
				Row(text: "Specialty-Type Beer", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showSpecialtyIntroduction()
					}),
				Row(text: "Cider", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showCiderIntroduction()
					}),
				Row(text: "Mead", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showMeadIntroduction()
					}),
				]),
			Section(header: "Reference", rows: [
				Row(text: "Glossary", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showTerms()
				}),
				Row(text: "Acknowledgements", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.showAcknowledgements()
					})
			]),
			Section(header: "Settings", rows: [
				Row(text: "Reset Data", cellClass:Value1Cell.self, accessory: .DisclosureIndicator, selection: { [unowned self] in
					self.resetData()
				})
			])
		]
	}	
	
	// MARK: - Private
	func showIntroduction() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showIntroduction(nil)
		}
	}

	func showBeerIntroduction() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showIntroduction(.Beer)
		}
	}
	
	func showSpecialtyIntroduction() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showIntroduction(.Specialty)
		}
	}
	
	func showCiderIntroduction() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showIntroduction(.Cider)
		}
	}
	
	func showMeadIntroduction() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showIntroduction(.Mead)
		}
	}

	func showAcknowledgements() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showIntroduction(.Acknowledgements)
		}
	}
	
	func showSRM() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showSRM()
		}
	}
	
	func showTags() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showTags()
		}
	}
	
	func showTerms() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showTerms()
		}
	}
	
	func showCategories() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showCategoriesList()
		}
	}
	
	func showSubCategories() {
		closeSettings()
		if let nav = navController {
			nav.popToRootViewControllerAnimated(false)
			nav.showSubCategoryList(nil)
		}
	}
	
	func resetData() {
		closeSettings()
		DefaultData().updateDefaults()
	}
	
	func iap() {
		
	}
	
	func closeSettings() {
		if let nav = navController {
			//nav.closeSettings()
			nav.hideController()
		}
	}
	
	private func showAlert(title title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: button, style: .Cancel, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
	}
	
	
	
}
