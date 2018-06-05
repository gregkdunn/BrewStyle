//
//  DefaultData.swift
//  BrewStyle
//
//  Created by Greg Dunn on 5/3/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

import Foundation

class DefaultData{
	let defaults : [String] = [Beverage.parseClassName(),
							   BeverageCategory.parseClassName(),
							   BeverageColor.parseClassName(),
							   BeverageType.parseClassName(),
							   StatCategory.parseClassName(),
							   Tag.parseClassName(),
							   TagCategory.parseClassName(),
							   Term.parseClassName(),
							   TermCategory.parseClassName(),
							   BeverageSubCategory.parseClassName(),
							   SRM.parseClassName(),
							   Introduction.parseClassName()]
	var totalUpdates : Int = 0
	var successfulUpdates : Int = 0;
	
	func registerParse () {

		//Register Parse subClasses
		for defaultClass: String in defaults {
			if let cls : AnyClass = NSClassFromString(defaultClass) {
					cls.registerSubclass!()
			}
		}
		
		let config = ParseClientConfiguration.init { (ParseMutableClientConfiguration) -> Void in
			ParseMutableClientConfiguration.applicationId = Constants.Parse.AppId
			ParseMutableClientConfiguration.clientKey = Constants.Parse.ClientKey
			ParseMutableClientConfiguration.server = Constants.Parse.Server
			ParseMutableClientConfiguration.localDatastoreEnabled = true
		}
		
		//Parse.enableLocalDatastore()
		Parse.initializeWithConfiguration(config)
		

		
	}
	
	func testDefaultsVersion() {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		if let localDefaultsVersion: AnyObject? = defaults.valueForKey(Constants.Notification.DefaultsVersion) {
			if(localDefaultsVersion != nil) {
				//print("Local Defaults Version: \(localDefaultsVersion)")
				PFConfig.getConfigInBackgroundWithBlock {
					(config: PFConfig?, error: NSError?) -> Void in
					let version = config?[Constants.Notification.DefaultsVersion] as? Float
					//print("Cloud Defaults Version: \(version)")
					if(localDefaultsVersion as? Float != version) {
						self.updateDefaults()
					}
				}
			} else {
				//print("Local Defaults Version is nil")
				self.updateDefaults()
			}
		}
	}
	
	func updateDefaults() {
		totalUpdates = defaults.count
		successfulUpdates = 0
		
		for defaultClass in defaults {
			self.updateDefault(defaultClass)
		}
	}
	
	func updateDefault(defaultClassString: String){
		PFObject.unpinAllObjectsInBackgroundWithName(defaultClassString)
		let defaultQuery : PFQuery = PFQuery(className: defaultClassString)
		defaultQuery.limit = 1000
		defaultQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error == nil {
				if ((objects) != nil) {
					NSLog(defaultClassString + " got \(objects!.count)");
					PFObject.pinAllInBackground(objects, withName: defaultClassString)
					self.incrementUpdates()
					
				} else {
					NSLog(defaultClassString + ": casting error")
				}
			} else {
				NSLog(defaultClassString + " error:" + error!.description)
			}
		}
	}
	
	func updateDefaultsVersion() {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		//update defaults version
		PFConfig.getConfigInBackgroundWithBlock {
			(config: PFConfig?, error: NSError?) -> Void in
			if let version = config?[Constants.Notification.DefaultsVersion] as? Float {
				//print("Set New Defaults Version: \(version)")
				defaults.setFloat(version, forKey: Constants.Notification.DefaultsVersion)
				NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.DefaultsVersion, object: version)
				NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.DataUpdated, object: nil)
			}
		}
	}

	func incrementUpdates () {
		successfulUpdates += 1
		if (successfulUpdates == totalUpdates) {
			self.updateDefaultsVersion()
		}
	}
}
