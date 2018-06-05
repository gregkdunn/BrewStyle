//
//  SettingsView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/8/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SettingsView : UIView {

	let titleColor =  AppColor.Black.color
	
	var navController : MainViewController?
	
	override init (frame : CGRect) {
		super.init(frame : frame)
		commonInit()
	}
	
	convenience init () {
		self.init(frame:CGRectZero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func commonInit (){
		self.backgroundColor = UIColor.clearColor()
		
		let titleBg = UIView()
		titleBg.backgroundColor = AppStyle.SettingsMenu[.HeaderColor]
		titleBg.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(titleBg)
		titleBg.topAnchor.constraintEqualToAnchor(self.topAnchor, constant:0).active = true
		titleBg.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		titleBg.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		titleBg.heightAnchor.constraintEqualToConstant(64).active = true
		
		
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillProportionally
		stack.alignment = .Leading
		stack.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(stack)
		stack.topAnchor.constraintEqualToAnchor(titleBg.bottomAnchor, constant: AppMargins.large.margin).active = true
		stack.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: AppMargins.medium.margin).active = true
		stack.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: AppMargins.medium.margin).active = true
		stack.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: AppMargins.large.negative).active = true
		
		
		stack.addArrangedSubview(section("Browse Styles", views: [
			button("- All", action:"showSubCategories"),
			button("- By Category", action: "showCategories"),
			button("- By Color", action:"showSRM"),
			button("- By Tag", action:"showTags"),
			button("- By Commercial Example", action:"iap")
			]))
		
		stack.addArrangedSubview(section("Reference", views: [
			button("- Glossary", action: "showTerms"),

		]))
		
		stack.addArrangedSubview(section("Donate", views: [
			button("- Buy Me a Beer", action: "iap")
		]))
		
		stack.addArrangedSubview(section("Admin", views: [
			button("- Reset Data", action: "resetData")
		]))

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
			nav.toggleSettings()
		}
	}
	
	func section(title: String, text: String, action: Selector) -> UIView  {
		let section = UIView()
		section.translatesAutoresizingMaskIntoConstraints = false
		section.addSubview(header(title))
		section.addSubview(button(text, action: action))
		
		return section
	}

	
	func section(title: String, views: [UIView]) -> UIView  {
		let section = UIView()
		section.translatesAutoresizingMaskIntoConstraints = false
		
		let sectionHeader = header(title)
		section.addSubview(sectionHeader)
		sectionHeader.topAnchor.constraintEqualToAnchor(section.topAnchor, constant: 0).active = true
		sectionHeader.leadingAnchor.constraintEqualToAnchor(section.leadingAnchor, constant: 0).active = true
		sectionHeader.trailingAnchor.constraintEqualToAnchor(section.trailingAnchor, constant: 0).active = true
		sectionHeader.heightAnchor.constraintEqualToConstant(21).active = true
		
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillProportionally
		stack.alignment = .Leading
		stack.translatesAutoresizingMaskIntoConstraints = false
		for view in views {
			stack.addArrangedSubview(view)
		}
		
		section.addSubview(stack)
		stack.topAnchor.constraintEqualToAnchor(sectionHeader.bottomAnchor, constant: AppMargins.small.margin).active = true
		stack.leadingAnchor.constraintEqualToAnchor(section.leadingAnchor, constant: AppMargins.medium.margin).active = true
		stack.trailingAnchor.constraintEqualToAnchor(section.trailingAnchor, constant: 0).active = true
		stack.bottomAnchor.constraintEqualToAnchor(section.bottomAnchor, constant: AppMargins.xl.negative).active = true
		
		let sectionFooter = spacer()
		section.addSubview(sectionFooter)
		sectionFooter.topAnchor.constraintEqualToAnchor(stack.bottomAnchor, constant: AppMargins.small.margin).active = true
		sectionFooter.leadingAnchor.constraintEqualToAnchor(section.leadingAnchor, constant: 0).active = true
		sectionFooter.trailingAnchor.constraintEqualToAnchor(section.trailingAnchor, constant: 0).active = true
		sectionFooter.heightAnchor.constraintGreaterThanOrEqualToConstant(32).active = true
		
		return section
	}
	
	func spacer() -> UIView {
		let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200) )
		//spacer.backgroundColor = AppColor.Purple.color
		spacer.translatesAutoresizingMaskIntoConstraints = false
		return spacer
	}
	
	func header(text:String) -> UILabel {
		let header = UILabel()
		header.font = UIFont(name: "Futura-CondensedMedium", size: 21)
		header.text = text
		header.translatesAutoresizingMaskIntoConstraints = false
		return header
	}
	
	func button(text:String, action:Selector) -> UIButton {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle(text, forState: .Normal)
		button.setTitleColor(titleColor, forState: .Normal)
		if let label = button.titleLabel {
			label.font = AppFonts.body.font
		}
		button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
		return button
	}
}
