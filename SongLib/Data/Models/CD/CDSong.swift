//
//  CDSong.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

@objc(CDSong)
public class CDSong: NSManagedObject {
    @NSManaged public var book: Int32
    @NSManaged public var songId: Int32
    @NSManaged public var songNo: Int32
    @NSManaged public var title: String?
    @NSManaged public var alias: String?
    @NSManaged public var content: String?
    @NSManaged public var views: Int32
    @NSManaged public var likes: Int32
    @NSManaged public var liked: Bool
    @NSManaged public var created: String?
    @NSManaged public var bookObject: CDBook?
}

extension CDSong {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSong> {
        return NSFetchRequest<CDSong>(entityName: "CDSong")
    }
}
