//
//  TodoListViewController.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/15/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t"]

	var todoList = [Item]()

//	var checkMark = [Bool]()

	// We are not using UserDefaults to save data anymore. Instead we use, NSCoder.
//	let defaults = UserDefaults.standard

	// The following shows where the data is stored. This is only for demonstrating the way to identify the location of where the plist will be saved. In actual code, extend this command a little as shown further below.
	//		let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	//		print (dataFilePath!) // This line was used to show the dataFilePath. But of course, it does not work here outside of functions.data


	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	// At this point, the plist is not created. It merely created the path.


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.


//		for _ in itemArray {
//			checkMark.append(false)
//		}

		for item in itemArray {
			todoList.append(Item(title: item, done: false))
		}


//		if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//			itemArray = items
//		}

//		if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//			todoList = items
//		}

	}

	// Mark - Tableview Datasource Methods

	// No need to call this when the number of sections is 1.
//	override func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return itemArray.count

		return todoList.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		// The following line creates new cells each time a cell comes into view. This is not a good way to
		// work with a tableview. Cells should be reused --- as shown below.
//		let cell = UITableViewCell.init(style: .default, reuseIdentifier: "ToDoItemCell")

		// This one looks for reusable cells in memory. And if there is none, it creates a new cell.
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

//		cell.textLabel?.text = itemArray[indexPath.row]

		let item = todoList[indexPath.row]
		cell.textLabel?.text = item.title

//		if checkMark[indexPath.row] {
//			cell.accessoryType = .checkmark
//		}
//		else {
//			cell.accessoryType = .none
//		}

//		if item.done {
//			cell.accessoryType = .checkmark
//		}
//		else {
//			cell.accessoryType = .none
//		}

		cell.accessoryType = item.done ? .checkmark : .none

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
//		if let cell = tableView.cellForRow(at: indexPath) {
//			if cell.accessoryType == .none {
//				cell.accessoryType = .checkmark
////				checkMark[indexPath.row] = true
//
//				todoList[indexPath.row].done = true
//			}
//			else {
//				cell.accessoryType = .none
////				checkMark[indexPath.row] = false
//
//				todoList[indexPath.row].done = false
//			}
//		}

		todoList[indexPath.row].done = !todoList[indexPath.row].done
		tableView.reloadData()

		saveData()

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
//			self.itemArray.append(textField.text!)
			// Of course, some error checkings are in order because if nothing is entered in the text field,
			// an empty string is appended to itemArray.

			self.todoList.append(Item(title: textField.text!, done: false))

//			self.defaults.set(self.itemArray, forKey: "TodoListArray")

			// The following block of code was my initial attempt at data persistence. But as it was pointed in the course,
			// UserDefaults is NOT for suited for anything larger than small bits of data. It is very inefficient because
			// it needs to load the entire plist into memory for it to work. So, once the data type gets to the point where
			// it needs to be encoded, like my attempt below, it is time for other ways of persisting data. In Lecture 232,
			// NSCoder was discussed.
//			do {
//				let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self.itemArray, requiringSecureCoding: false)
//
//				self.defaults.set(encodedData, forKey: "TodoListArray")
//				self.tableView.reloadData()
//			}
//			catch {
//				print ("Error while encoding")
//			}

			// ... but the following is how it should be done, using NSEncoder.
			self.saveData()
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}


	func saveData() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(todoList)
			try data.write(to: dataFilePath!)
		}
		catch {
			print ("Error while encoding data: \(error)")
		}

		tableView.reloadData()
	}


}

