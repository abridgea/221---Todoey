//
//  CategoryViewController.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/27/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit
//import CoreData	// CoreData was no longer needed after RealmSwift was imported.
import RealmSwift

class CategoryViewController: UITableViewController {

	// The following line uses 'lazy var' instead of 'let'. This was necessary when realm migration feature was added in AppDelegate (cf migrateRealm() method).
	// But I wonder if this is a right way to do this. If this property is supposed to be constant, is it a good idea to use 'var' just so that 'lazy' can be declared?
	lazy var realm = try! Realm()
	
	// The following property was for Core Data.
//    var categories	= [Category]()
	// The following property is for Realm.
	var categories : Results<Category>?
	
	// The following line was for Core Data. No longer needed for Realm.
//	var context		= (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

		loadCategories()
    }

	// MARK: - TableView Data Source Methods

	// The following code is not necessary because there is only 1 section.
//	override func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		// The following line was replaced with the 2 lines below to handle the situation when there is 'zero' category. It wasn't addressed in the video.
		
//		return categories?.count ?? 1
		
		let numCat = categories?.count ?? 0
		
		return numCat == 0 ? 1 : numCat
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		
		// The following line was replaced by the block below to handle the situation when there is 'zero' category. It wasn't addressed in the video.
//		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet."
		
		if let catCount = categories?.count {
			cell.textLabel?.text = catCount > 0 ? categories![indexPath.row].name : "No Categories Added Yet."
		}
		else {
			cell.textLabel?.text = "No Categories Added Yet."
			categories = realm.objects(Category.self)
		}

		return cell
	}


	// MARK: - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// NTS: DO NOT deselect row here. Doing so means the same as not selecting a row when the segue is performed below.
		// performSegue() sends the code to prepare(for segue:), and that block relies on the row that's been selected.
		// The selected row will automatically be deselected when the control returns to CategoryViewControler.
//		tableView.deselectRow(at: indexPath, animated: true)	// NOT NOT deselectRow().

		if (categories?.count)! > 0 {
			performSegue(withIdentifier: "goToItems", sender: self)
		}
		else {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goToItems" {
			let destinationVC = segue.destination as! TodoListViewController
			
			if let indexPath = tableView.indexPathForSelectedRow {
				destinationVC.selectedCategory = categories?[indexPath.row]
			}
		}
	}




	// MARK: - Add New Categories

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

		var textField = UITextField()

		alert.addTextField { (alertTextField) in	// alertTextField is the name given to text field created by alert here.
			alertTextField.placeholder = "Create new category"
			textField = alertTextField				// ... then apparently the address is passed to a variable that function as a pointer to that address, so it can be accessed in the completion closure of the action below.
		}

		let action = UIAlertAction(title: "Add Category", style: .default) { _ in	// Apparently, the UIAlertAction parameter in the closure is not used. So, it can probably be _ (underscore) rather than giving it an actual name (action) as it was done in the video, which in this case can be confusing because the variable name is also action.
			
			// The following line was for Core Data.
//			let newCategory = Category(context: self.context)
			
			// The line above was replaced by the next line when Realm was added.
			let newCategory = Category()
			newCategory.name = textField.text!

			// The following line was for Core Data. Since Results<Element> is an auto-updating container type in Realm,
			// there is not need to append anything to it.
//			self.categories.append(newCategory)

			// The following line was for Core Data.
//			self.saveCategories()
			// The following line is for Realm.
			self.save(category: newCategory)
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}


	// MARK: - Data Manipulation Methods

	// The following function declaration was for Core Data.
//	func saveCategories() {
	// The followng function declaration is for Realm.
	func save(category: Category) {
		do {
			// The following line was for Core Data.
//			try context.save()
			// The following line is for Realm.
			try realm.write {
				realm.add(category)
			}
		}
		catch {
			print ("Error saving category context: \(error)")
		}

		tableView.reloadData()
	}


	// The following loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) method
	// was for Core Data. A new loadCategories() is made for Realm.
//	func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
//		do {
//			categories = try context.fetch(request)
//		}
//		catch {
//			print ("Error loading Categories: \(error)")
//		}
//
//		tableView.reloadData()
//	}
	
	// The following loadCategories() was made for Realm.
	func loadCategories() {
		categories = realm.objects(Category.self)	// The use of .self returns the "type" of the object.
													// This line returns all the elements in the realm that are of Category type.
		
		tableView.reloadData()
		
	}
}
