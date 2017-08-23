//
//  Table_iTunes+CoreDataProperties.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-20.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import Foundation
import CoreData


extension Table_iTunes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Table_iTunes> {
        return NSFetchRequest<Table_iTunes>(entityName: "Table_iTunes")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var price: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var kind: String?
    @NSManaged public var trackName: String?
    @NSManaged public var information: String?

}
