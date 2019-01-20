//
//  TodoListViewController.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/15/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]

	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		print (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)


		if let items = defaults.array(forKey: "TodoListArray") as? [String] {
			itemArray = items
		}
	}

	// Mark - Tableview Datasource Methods

	// No need to call this when the number of sections is 1.
//	override func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]

		return cell
	}

	// MARK - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print ("Row selected: \(indexPath.row)   \(itemArray[indexPath.row])")


		// Odd behavior:
		// The following changes make the check mark from apparing.
		//	Instead of using optional binding (i.e., if let), use tableView.cellForRow(at: indexPath)? (need the "?" at the end.)
//		if tableView.cellForRow(at: indexPath)?.accessoryType == .none {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//		}
//		else {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .none
//		}

		// However, if .none and .checkmark are changed places, it works again.
//		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .none
//		}
//		else {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//		}

		// Also, if the UITableView.AccessoryType is specified, it works again.
//		if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//		}
//		else {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .none
//		}

		// But the following is probably the best way to code this.
		if let cell = tableView.cellForRow(at: indexPath) {
			if cell.accessoryType == .none {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		}

		tableView.deselectRow(at: indexPath, animated: true)
	}


	// MARK: - Add New Items

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		var textField = UITextField()

		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item."
			textField = alertTextField
		}

		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			// What will happen once the user clicks the Add Item button to our UIAlert.

			// No need for an optional binding because a text attribute will never be nil.
			// If there is nothing in the attribute, it is set to an empty string.
//			if let newText = textField.text { // alert.textFields?.first?.text {
//				self.itemArray.append(newText)
//			}
			// ... so just force unwrap the text attribute.
			self.itemArray.append(textField.text!)
			// Of course, some error checkings are in order because if nothing is entered in the text field,
			// an empty string is appended to itemArray.

			self.defaults.set(self.itemArray, forKey: "TodoListArray")

			self.tableView.reloadData()
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}




}

