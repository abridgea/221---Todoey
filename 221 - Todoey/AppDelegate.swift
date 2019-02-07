//
//  AppDelegate.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/15/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit
//import CoreData		No longer needed after adding Realm.
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		print ("application(didFinishLaunchingWithOptions:)")
		
		print (Realm.Configuration.defaultConfiguration.fileURL!)

		// The following line shows where the plist is saved. And that is where our data are stored.
		// Follow the path shown in the console, all the way to just before Documents (the last directory that will
		// be printed in the console). From one heirarchy above Documents, go to Libary/Preferences. And there
		// should be the plist there where our data are stored.
		// The easiest way to get there probably, copying the print out, and pasted it after typing "open" on terminal. And delete the last directory ("Documents"), and type "Library/Preferences". A folder opens in Finder with the plist in it.

//		print (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

		
		// NTS: The following blocks were coded after adding Realm to the project.
		// Then deleted after a couple of runs because it was only a test.
//		let data = Data()
//		data.name	= "Gan"
//		data.age	= 18
		
//		migrateRealm()
		
		
		// The following realm initializer is not required. But in Video (#256 Review of How Our App Uses Realm for Data Persistence), Angela wanted to keep it just to catch an error when Realm was initialized.
		do {
//			let realm = try Realm()		Instead of using this line, Angela changed it to the following...
			_ = try Realm()
			
			// The following block was deleted after a couple of test runs to add "Gan" and "18".
//			try realm.write {
//				realm.add(data)
//			}
		}
		catch {
			print ("Error creating realm: \(error)")
		}

		
		
		
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

		print ("applicationWillResignActive")
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

		print ("applicationDidEnterBackground")
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

		print ("applicationWillEnterForeground")
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

		print ("applicationDidBecomeActive")
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
//		self.saveContext()		No longer needed after adding Realm.
	}

	// MARK: - Core Data stack

	// persistentContainer property and saveContext() are no longer needed after adding Realm.
	// NTS: NSPersistentContainer is SQLite database.
//	lazy var persistentContainer: NSPersistentContainer = {
//		/*
//		The persistent container for the application. This implementation
//		creates and returns a container, having loaded the store for the
//		application to it. This property is optional since there are legitimate
//		error conditions that could cause the creation of the store to fail.
//		*/
//		let container = NSPersistentContainer(name: "DataModel")	// NTS: The name has to match the name of the new data model in the Navigation panel. Then all the behind the scene set up and relationships are created properly.
//		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//			if let error = error as NSError? {
//				// Replace this implementation with code to handle the error appropriately.
//				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//				/*
//				Typical reasons for an error here include:
//				* The parent directory does not exist, cannot be created, or disallows writing.
//				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
//				* The device is out of space.
//				* The store could not be migrated to the current model version.
//				Check the error message to determine what the actual problem was.
//				*/
//				fatalError("Unresolved error \(error), \(error.userInfo)")
//			}
//		})
//		return container
//	}()
//
//	// MARK: - Core Data Saving support
//
//	func saveContext () {
//		let context = persistentContainer.viewContext
//		if context.hasChanges {
//			do {
//				try context.save()
//			} catch {
//				// Replace this implementation with code to handle the error appropriately.
//				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//				let nserror = error as NSError
//				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//			}
//		}
//	}
	
	func migrateRealm() {
		
		// The following code fixes the problem when a new property is added to Item.swift.
		// With out the migration, the app gives a warning (the green line), and crashes later when 'let realm = try! Realm()' is called in CategoryViewController.
		// Call this from applications(didFinishLaunchingWithOptions), and change 'let' to 'lazy var' where 'let realm = try! Realm()' is called in CategoryViewController. Then the new property is added in realm, and the information for that new property is populated (in this case, with the current date/time).
		let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
			if oldSchemaVersion < 1 {
				migration.enumerateObjects(ofType: Item.className(), { (_, newItem) in
					newItem?["dateCreated"] = Date()
				})
			}
		})

		Realm.Configuration.defaultConfiguration = config
	}


}

