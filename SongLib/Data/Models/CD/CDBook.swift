//
//  CDBook.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

@objc(CDBook)
public class CDBook: NSManagedObject {
    @NSManaged public var bookId: Int32
    @NSManaged public var title: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var songs: Int32
    @NSManaged public var position: Int32
    @NSManaged public var bookNo: Int32
    @NSManaged public var enabled: Bool
    @NSManaged public var created: String?
    @NSManaged public var songsList: NSSet?
}

extension CDBook {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBook> {
        return NSFetchRequest<CDBook>(entityName: "CDBook")
    }
    
    @objc(addSongsListObject:)
    @NSManaged public func addToSongsList(_ value: CDSong)
    
    @objc(removeSongsListObject:)
    @NSManaged public func removeFromSongsList(_ value: CDSong)
    
    @objc(addSongsList:)
    @NSManaged public func addToSongsList(_ values: NSSet)
    
    @objc(removeSongsList:)
    @NSManaged public func removeFromSongsList(_ values: NSSet)
}
