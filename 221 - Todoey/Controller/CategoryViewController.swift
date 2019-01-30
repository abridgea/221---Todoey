//
//  CategoryViewController.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/27/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories	= [Category]()
	var context		= (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
		return categories.count
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = categories[indexPath.row].name

		return cell
	}


	// MARK: - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// NTS: DO NOT deselect row here. Doing so means the same as not selecting a row when the segue is performed below.
		// performSegue() sends the code to prepare(for segue:), and that block relies on the row that's been selected.
		// The selected row will automatically be deselected when the control returns to CategoryViewControler.
//		tableView.deselectRow(at: indexPath, animated: true)	// NOT NOT deselectRow().

		performSegue(withIdentifier: "goToItems", sender: self)
}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goToItems" {

			let destinationVC = segue.destination as! TodoListViewController

			if let indexPath = tableView.indexPathForSelectedRow {
				destinationVC.selectedCategory = categories[indexPath.row]
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
			let newCategory = Category(context: self.context)
			newCategory.name = textField.text!

			self.categories.append(newCategory)

			self.saveCategories()
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}


	// MARK: - Data Manipulation Methods

	func saveCategories() {
		do {
			try context.save()
		}
		catch {
			print ("Error saving category context: \(error)")
		}

		tableView.reloadData()
	}


	func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
		do {
			categories = try context.fetch(request)
		}
		catch {
			print ("Error loading Categories: \(error)")
		}

		tableView.reloadData()
	}
}
