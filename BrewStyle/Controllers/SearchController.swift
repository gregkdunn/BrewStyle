//
//  SearchController.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/5/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SearchController : TableViewController {
		var navController : MainViewController?
	
		// MARK: - Properties
		
		private let customAccessory: UIView = {
			let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
			view.backgroundColor = .redColor()
			return view
		}()
		
		
		// MARK: - Initializers
		
		convenience init() {
			self.init(style: .Grouped)
		}
		
		
		// MARK: - UIViewController
		
		override func viewDidLoad() {
			super.viewDidLoad()
			
			self.tableView.backgroundColor = AppColor.Beige.color
			tableView.rowHeight = 44
			
			dataSource.sections = [
				Section(rows: [
					Row(text: "Close", selection: { [unowned self] in
						self.closeSettings()
						})
					]),
				Section(header: "Sort", rows: [
					
					Row(text: "Reset", editActions: [
						Row.EditAction(title: "Reset", style: .Destructive, selection: { [unowned self] in
							self.resetSort()
							})
						])
					])
			]
		}
		
		// MARK: - Private
	
		func closeSettings() {
			if let nav = navController {
				nav.hideController()
			}
		}
	
		func resetSort() {
			
		}
	
		private func showAlert(title title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: button, style: .Cancel, handler: nil))
			presentViewController(alert, animated: true, completion: nil)
		}
}