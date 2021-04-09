//
//  ToDoListItem+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Lakhlifi Essaddiq on 4/7/21.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItem : Identifiable {

}
