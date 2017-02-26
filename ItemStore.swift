//
//  ItemStore.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/22/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    let itemArchiveURL: NSURL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive") as NSURL
    }()
    
    // MARK: - Save and load from cache
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
    
    // MARK: - Add, remove, move items
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    
    func removeItem(item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
    
    
}
