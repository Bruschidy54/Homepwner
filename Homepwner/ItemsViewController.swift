//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/22/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    // MARK: - Add new item button
    
    @IBAction func addNewItem(sender: AnyObject) {
       // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that itme is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = NSIndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
        
    }
    
    
    // MARK: - View life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK - Table view methods
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if Int(sourceIndexPath.row) >= itemStore.allItems.count || Int(destinationIndexPath.row) >= itemStore.allItems.count {
            return
        }
        else {
        // Update the model
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row >= itemStore.allItems.count {
            return sourceIndexPath
        }
        else {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row >= itemStore.allItems.count {
            return false
        }
        else {
            return true
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            
            // Remove the item from the store
            self.itemStore.removeItem(item: item)
                
            // Remove the item's image from the image store
            self.imageStore.deleteImageForKey(key: item.itemKey)
            
            // Also remove that row from the table view with an animation
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
        
            // Present the alert controller
            present(ac, animated: true, completion: nil)
            
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Update the labels for the new preferred text size
        cell.updateLabels()
        
        // Set the text on the cell with the description of the item
        // that is as the nth index of itmes, where n = row this cell
        // will appear in on the tableview
        if indexPath.row >= itemStore.allItems.count {
            cell.nameLabel?.text = "No more items!"
            cell.serialNumberLabel?.text = ""
            cell.valueLabel.text = ""
            cell.isUserInteractionEnabled = false
        }
        else {
        let item = itemStore.allItems[indexPath.row]
            cell.nameLabel.text = item.name
            cell.serialNumberLabel?.text = item.serialNumber
            cell.valueLabel.text  = "$\(item.valueInDollars)"
            if item.valueInDollars < 50 {
                cell.valueLabel.textColor = UIColor.green
            }
            else {
                cell.valueLabel.textColor = UIColor.red
            }
        }
        return cell
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }
    }
    
}
