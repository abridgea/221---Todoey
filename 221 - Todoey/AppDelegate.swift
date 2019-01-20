//
//  AppDelegate.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/15/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		// The following line shows where the plist is saved. And that is where our data are stored.
		// Follow the path shown in the console, all the way to just before Documents (the last directory that will
		// be printed in the console). From one heirarchy above Documents, go to Libary/Preferences. And there
		// should be the plist there where our data are stored.
		// The easiest way to get there probably, copying the print out, and pasted it after typing "open" on terminal. And delete the last directory ("Documents"), and type "Library/Preferences". A folder opens in Finder with the plist in it.

		print (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

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

		print ("applicationWillTerminate")
	}


}

