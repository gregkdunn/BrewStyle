//
//  ContentStore.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/17/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//
class ContentStore {
	
	static let sharedInstance = ContentStore()
	
	
	func fetchIntroductionWithCompletionBlock(block:(result: [Introduction]) -> Void ) {
		//print("Intro all!")
		
		let query = PFQuery(className: "Introduction")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [Introduction] {
					//print("all: \(objects.description)")
					block(result : objects)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func fetchIntroductionForName(name: String, block:(result: Introduction) -> Void ) {
		let query = PFQuery(className: "Introduction").whereKey("name", equalTo: name)
		fetchIntroductionForQuery(query, block: block)
	}
	
	func fetchIntroductionForQuery(query : PFQuery, block:(result: Introduction) -> Void ) {
		let extendedQuery = query.fromLocalDatastore().orderByAscending("name")
		
		extendedQuery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let newObjects = objects as? [Introduction] {
					if let object = newObjects.first {
						object.fetchContentData()
						block(result : object)
					} else {
						//print("Intro data conversion error")
					}
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func fetchSRMWithCompletionBlock(block:(result: [SRM]) -> Void ) {
		//print("SRM  all!")
		
		let query = PFQuery(className: "SRM").fromLocalDatastore().includeKey("color").orderByAscending("value")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [SRM] {
					////print("all: \(objects.description)")
					block(result : objects)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func fetchSRMForValue(value:Double, block:(result: SRM) -> Void ) {
		//print("SRM for value: \(value)")
		
		let query = PFQuery(className: "SRM").fromLocalDatastore().whereKey("value", equalTo: value).orderByAscending("value")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [SRM] {
					////print(objects.description)
					if(objects.count > 0) {
						block(result : objects.first!)
					}
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func fetchTagsWithCompletionBlock(block:(result: [TagViewModel]) -> Void ) {
		//print("Tags all!")
		
		let query = PFQuery(className: "Tag").fromLocalDatastore().includeKey("category").addAscendingOrder("position").addAscendingOrder("name")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [Tag] {
					var objectVMs : Array<TagViewModel> = [TagViewModel]()
					for object : Tag in objects {
						let objectVM : TagViewModel = TagViewModel(tag:object)
						objectVMs.append(objectVM)
					}
					block(result : objectVMs)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func fetchTagsForCategory(category: TagCategory, block:(result: [TagViewModel]) -> Void ) {
		//print("Tags for category")
		
		let query = PFQuery(className: "Tag").fromLocalDatastore().whereKey("category", equalTo: category).includeKey("category").addAscendingOrder("name")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [Tag] {
					var objectVMs : Array<TagViewModel> = [TagViewModel]()
					for object : Tag in objects {
						let objectVM : TagViewModel = TagViewModel(tag:object)
						objectVMs.append(objectVM)
					}
					block(result : objectVMs)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}	
	
	func fetchTermsWithCompletionBlock(block:(result: [TermViewModel]) -> Void ) {
		//print("Terms all!")
		
		let query = PFQuery(className: "Term").fromLocalDatastore().includeKey("category").addAscendingOrder("name")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [Term] {
					var objectVMs : Array<TermViewModel> = [TermViewModel]()
					for object : Term in objects {
						let objectVM : TermViewModel = TermViewModel(term:object)
						objectVMs.append(objectVM)
					}
					block(result : objectVMs)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
	
	func fetchTermsForCategory(category: TermCategory, block:(result: [TermViewModel]) -> Void ) {
		//print("Terms for category")
		
		let query = PFQuery(className: "Term").fromLocalDatastore().whereKey("category", equalTo: category).includeKey("category").addAscendingOrder("name")
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [Term] {
					var objectVMs : Array<TermViewModel> = [TermViewModel]()
					for object : Term in objects {
						let objectVM : TermViewModel = TermViewModel(term:object)
						objectVMs.append(objectVM)
					}
					block(result : objectVMs)
				}
			} else {
				//print("Error: \(error!)")
			}
		}
	}
}