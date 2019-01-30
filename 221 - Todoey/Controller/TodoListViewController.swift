//
//  TodoListViewController.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/15/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import UIKit
import CoreData		// In the video [How to Save Data with Core Data (Create in CRUD)] (Sec 18 Lec 238) @5:18, Angela says this line is needed. But in practice, the code works without importing CoreData.


// NTS: To make this view controller the delegate of the search bar, we can create an outlet of the search bar, and set the delegate programatically (e.g., mySearchBar.delegate = self). Or, alternatively, simply right-click from the search bar in the Main.storyboard to the yellow view icon at the top of the view conroller, and select "delegate" from the black window that pops open. Either way works. In this code, the latter was used.
class TodoListViewController: UITableViewController {

//	var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t"]

	var todoList = [Item]()

//	var checkMark = [Bool]()

	// We are not using UserDefaults to save data anymore. Instead we use, NSCoder.
//	let defaults = UserDefaults.standard

	// The following shows where the data is stored. This is only for demonstrating the way to identify the location of where the plist will be saved. In actual code, extend this command a little as shown further below.
	//		let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	//		print (dataFilePath!) // This line was used to show the dataFilePath. But of course, it does not work here outside of functions.data

	// After adding Core Data, the line below became obsolete because we are no longer saving data in plist.
//	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	// At this point, the plist is not created. The line above merely created the path. (This was a comment added before adding Core Data.)

	// After adding Core Data, context property was created. It is a handle to the AppDelegate property persistentContainer's viewContext.
	// But since writing "AppDelegate.persistentContainer.viewContext" is not possible (because AppDelegate is a class name, and not an instance object), we need to use the delegate property of the UIApplication singleton. This delegate points to App object, or in other words, AppDelegate.
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	var selectedCategory : Category? {
		didSet {
			loadItems()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

//		for _ in itemArray {
//			checkMark.append(false)
//		}

//		for item in itemArray {
//			todoList.append(Item(title: item, done: false))
//		}


//		if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//			itemArray = items
//		}

//		if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//			todoList = items
//		}

		// The following line become obsolete when Core Data was added.
//		print (dataFilePath!)

		// The following line was added to locate the depository of data after Core Data was added.
		// Copy from /Users/<User Name> all the way to /Documents/. In Terminal, type open, and paste, press return.
		// The partinent Documents directory is opened. Go back up one directory, go into Library, and Application Support.
		// That's where the DataModel files are saved. The file of most interest is, "DataModel.sqlite"
		print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

		// After Category View Controller was created, a property called selectedCategory was created, and its didSet method was used to call loadItems(). cf above in the list of properties.
//		loadItems()
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

		// NTS: If the text value needs to be changed (e.g., "Completed!"), use the following method:
//		todoList[indexPath.row].setValue("Completed!", forKey: "title")

		// NTS: The following line toggles the checkmark on items. A checkmark means the task is complete. Instead, if the item is to be deleted from the list, use the method shown below.
		todoList[indexPath.row].done = !todoList[indexPath.row].done

		// NTS: The following block is some items need to be deleted, rather than having a checkmark. If deleting completed tasks is preferred, comment out the line above that toggles the checkmark.
		// NTS: The order of these 2 lines matters greatly. It is important to remove the item from the context before
		// removing the item from the array. Otherwise, the app will crash when the last item is selected. Or, the app
		// deletes multiple lines when entries other than the last are selected. This is because the first line relies
		// on the array to delete specific item. Once the item is removed from the context, the corresponding item in
		// the array can safely be removed.
//		context.delete(todoList[indexPath.row])	// This removes an item in the context, using the array as a guide.
//		todoList.remove(at: indexPath.row)		// This removes a corresponding item in the array.

		saveItems()

		tableView.deselectRow(at: indexPath, animated: true)
	}


	// MARK: - Add New Items

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

		var textField = UITextField()

		alert.addTextField { (alertTextField) in	// alertTextField is the name given to text field created by alert here.
			alertTextField.placeholder = "Create new item."
			textField = alertTextField				// ... then apparently the address is passed to a variable that function as a pointer to that address, so it can be accessed in the completion closure of the action below.
		}

		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in 	// Apparently, the UIAlertAction parameter in the closure is not used. So, it can probably be _ (underscore) rather than giving it an actual name (action) as it was done in the video, which in this case can be confusing because the variable name is also action.
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

			// When Core Data was added, the following line flagged an error. And it had to be modifed.
//			self.todoList.append(Item(title: textField.text!, done: false))

			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done  = false
			newItem.parentCategory = self.selectedCategory

			self.todoList.append(newItem)


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
			self.saveItems()
		}


		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}


	func saveItems() {

		// When Core Data is added, the code below became obsolete.
//		let encoder = PropertyListEncoder()
//		do {
//			let data = try encoder.encode(todoList)
//			try data.write(to: dataFilePath!)
//		}
//		catch {
//			print ("Error while encoding data: \(error)")
//		}

		// ...and instead, the following code was created.

		do {
			try context.save()
		}
		catch {
			print ("Error saving context: \(error)")
		}

		tableView.reloadData()
	}


//	func loadItems() {
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		// The following block of code became obsolete when Core Data's READ functionality was added.
//		do {
//			if let data = try? Data(contentsOf: dataFilePath!) {
//				let decoder = PropertyListDecoder()
//
//				do {
//					// Note: In the video instructions, itemAray was retooled to be an array of Item.
//					// But in my case, a new array, todoList, was created to be an array of Item.
//					// The property, itemArray, was kept as an array of Strings. So, if the video instructions
//					// were to be followed, an error is flagged below stating ""Cannot assign value of type '[Item]' to type '[String]'".
//					// Be sure to use todoList instead of itemArray in video#234 and on.
//					// Note2: The reason we need to type 'self' below is as follows:
//					// This argument type is "Decodable.Protocol'. And we need to specify the data type because Xcode
//					// cannot reliablly infer the data type in this case. So, '[Item]' is written. But that's not enough.
//					// Since we are not specifying an object, in order to refer to the type (i.e., an array of Item),
//					// 'self' needs to be added. That's the explanation in the video, and the error flag disappears.
//					todoList = try decoder.decode([Item].self, from: data)
//				}
//				catch {
//					print ("Error in decoding.")
//				}
//
//			}
//		}

		// This is where the new set of code begins after Core Data was added.
		// NTS: The video says it is necessary to specify the type <Item>. But it worked without specifying it.
		// NTS: The line below became unnecessary when parameters were added to the method name.
//		let request : NSFetchRequest<Item> = Item.fetchRequest()

		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

		if let addtionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
		}
		else {
			request.predicate = categoryPredicate
		}




		do {
			todoList = try context.fetch(request)
		}
		catch {
			print ("Error fetching data from context: \(error)")
		}

		tableView.reloadData()

	}
}


// MARK: - Search Bar Delegate

extension TodoListViewController : UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request : NSFetchRequest<Item> = Item.fetchRequest()

		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

		request.sortDescriptors = [NSSortDescriptor(key: "tile", ascending: true)]

		loadItems(with: request, predicate: predicate)
	}


	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()

			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
}
