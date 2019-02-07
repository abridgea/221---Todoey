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
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {

	// The following line uses 'lazy var' instead of 'let'. This was necessary when realm migration feature was added in AppDelegate (cf migrateRealm() method).
	// But I wonder if this is a right way to do this. If this property is supposed to be constant, is it a good idea to use 'var' just so that 'lazy' can be declared?
	lazy var realm = try! Realm()
	
	// The following property was for Core Data.
//    var categories	= [Category]()
	// The following property is for Realm.
	var categories : Results<Category>?
	
	var noCatLabel	= UILabel()
	
	// The following line was for Core Data. No longer needed for Realm.
//	var context		= (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

		loadCategories()
		
		tableView.rowHeight = 80.0

		noCatLabel = UILabel(frame: CGRect(x: 0, y: tableView.rowHeight, width: tableView.frame.width, height: tableView.rowHeight))
		noCatLabel.text = "No Categories Added Yet"
		noCatLabel.textAlignment = .center
		noCatLabel.textColor = .gray
		noCatLabel.isHidden = true
		
		tableView.addSubview(noCatLabel)
    }

	// MARK: - TableView Data Source Methods

	// When SwipeCellKit was initially installed and its tableView(editActionsOptionsForRowAt:) method was used, the app crashed when the last cell was deleted. It was because the code was returning '1' instead of '0' to create a dummy cell to print "No Categories Created Yet" message. SwipeCellKit thought it should be '0' because (categories?.count)! was zero, yet tableView(numberOfRowsInSection:) was returning '1'. The following solution was found in StackOverflow (https://stackoverflow.com/questions/51865246/swipecellkit-deleting-last-row-in-tableview-create-an-error) by John Ayers.
	// The following block that's commented out is the original post. The modified version is shown below.
//	override func numberOfSections(in tableView: UITableView) -> Int {
//		let numOfSectons: Int = 1;
//		if (itemStore.allItems.count>0){
//			tableView.separatorStyle = .singleLine
//			tableView.backgroundView = nil
//		} else{
//			let noDataFrame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
//			let noData: UILabel = UILabel(frame: noDataFrame)
//			noData.text = "No Items!"
//			noData.textColor = .black
//			noData.textAlignment = .center
//			tableView.backgroundView = noData
//			tableView.separatorStyle = .none
//		}
//		return numOfSectons
//	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		if (categories?.count ?? 0 > 0) {
//			tableView.separatorStyle = .singleLine
			noCatLabel.isHidden = true
			tableView.separatorColor = .lightGray
		} else {
			noCatLabel.isHidden = false
		
			// DO NOT toggle the separator line by using .none and .singleLine for tableView.separatorStyle. Doing so would interrupt the cell deletion animation for the last cell. It cuts off the animaiton as soon as it starts. Instead, set the color of the separator to .clear. And set it back to .lightGray when cells are created.
//			tableView.separatorStyle = .none
			tableView.separatorColor = .clear
			
			// NTS: Initially, I tried saving the separator color by creating a global variable (var separatorColor : UIColor?). And setting it to tableView.separatorColor. And after that, I set the color to .clear when there is no cell. And when the cell is created, I would set tableView.separatorColor to the saved value. But for some reason, numberOfSections is called twice in a row. So, the first time, the global variable saves the correct color. But the second time, it is set to .clear. And when a new cell is created, the .clear color is used to color the separator color. Very odd. So, I gave up on that idea, and instead, hard coded .lightGary and .clear.
		}
		return 1
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		// The following line was replaced with the 2 lines below to handle the situation when there is 'zero' category. It wasn't addressed in the video.
		// Additionally, it was discovered that SwipeCellKit's tableView(editActionsOptionsForRowAt) [this is the one that animates the deletion of the cell] crashes when the last is deleted. That's because the code below returns '1' when the last cell is deleted, but the SwipeCellKit thinks it should be '0' because there is no longer any cell. In the code below, our intention was to create a cell so that we can print "No Categories Added Yet".
		
		// This line was the original code in the video. But this addresses the case where categories is nil, while ignoring the case where it is zero. If it is zero, the method returns zero, and no cell is created. That means no message is printed.
//		return categories?.count ?? 1
		
		// So, this code was created. But this eventually posed a problem when SwipeCellKit was installed.
		// When tableView(editActionsOptionsForRowAt:) was used, which plays an animation of the cell being deleted. The problem is that tableView(editActionsOptionsForRowAt:) assumes there is zero cells after the last cell is swiped. But the code below returns 1. This discrepancy causes the app to crash.
//		let numCat = categories?.count ?? 0
//		return numCat == 0 ? 1 : numCat
		
		// So, the follwing code replaced the block above. If the categories count is zero or nil, the line returns zero. These cases are handled by numberOfSections(), where UILabel is created to show the message instead of creating a dummy cell to print the message.
		return categories?.count ?? 0
	}

//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//		cell.delegate = self
//		return cell
//	}
	

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
		
		// The following line was replaced by the block below to handle the situation when there is 'zero' category. It wasn't addressed in the video.
//		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet."
		
		if let catCount = categories?.count {
			if catCount > 0 {
				cell.textLabel?.text = categories![indexPath.row].name
				cell.delegate = self		// This line allows the SwipeCellKit to work its magic.
			}
//			else {
//				cell.textLabel?.text = "No Categories Added Yet."
//			}
		}
//		else {
//			cell.textLabel?.text = "No Categories Added Yet."
//			categories = realm.objects(Category.self)
//		}

//		cell.delegate = self	// Added this line above where categories are made.
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
//			print ("Error saving category context: \(error)")	This was for Core Data.
			print ("Error saving category: \(error)")
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


// MARK: - Swipe Table View Cell Delegate Methods

extension CategoryViewController : SwipeTableViewCellDelegate {

	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		
		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			// handle action by updating model with deletion
			
			if let catToDelete = self.categories?[indexPath.row] {
				do {
					try self.realm.write {
						self.realm.delete(catToDelete)
					}
				}
				catch {
					print ("Error removing category: \(error)")
				}
				
				// tableView(editActionsOptionsForRowAt:) methods expansion style set to .destructive, the following line is not needed because the exansion style deletes the row.
				// Also note that the app crashes when the last row is swiped.
//				tableView.reloadData()
			}
		}
		
		// customize the action appearance
		deleteAction.image = UIImage(named: "delete-icon")
		
		return [deleteAction]
	}
	
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
//		options.transitionStyle = .border
		options.expansionStyle = .destructive

		return options
	}
	
}
