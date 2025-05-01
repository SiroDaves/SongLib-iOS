//
//  SongDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class SongDataManager {
    private let coreDataManager: CoreDataManager
    private let bookDataManager: BookDataManager
    
    // Constructor with dependency injection
    init(coreDataManager: CoreDataManager = CoreDataManager.shared,
         bookDataManager: BookDataManager) {
        self.coreDataManager = coreDataManager
        self.bookDataManager = bookDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save songs to Core Data
    func saveSongs(_ songs: [Song]) {
        do {
            // For each song in the input array
            for song in songs {
                // Check if the song already exists
                let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "songId == %d", song.songId)
                
                let existingSongs = try context.fetch(fetchRequest)
                let cdSong: CDSong
                
                if let existingSong = existingSongs.first {
                    // Update existing song
                    cdSong = existingSong
                } else {
                    // Create new song
                    cdSong = CDSong(context: context)
                }
                
                // Set all properties
                cdSong.songId = Int32(song.songId)
                cdSong.book = Int32(song.book)
                cdSong.songNo = Int32(song.songNo)
                cdSong.title = song.title
                cdSong.alias = song.alias
                cdSong.content = song.content
                cdSong.views = Int32(song.views)
                cdSong.likes = Int32(song.likes)
                cdSong.liked = song.liked
                cdSong.created = song.created
                
                // Link to the book if it exists
                if let book = bookDataManager.fetchBookEntity(withId: Int32(song.book)) {
                    cdSong.bookObject = book
                }
            }
            
            try context.save()
        } catch {
            print("Failed to save songs: \(error)")
        }
    }
    
    // Fetch all songs or songs for a specific book
    func fetchSongs(for bookId: Int? = nil) -> [Song] {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        if let bookId = bookId {
            fetchRequest.predicate = NSPredicate(format: "book == %d", bookId)
        }
        
        do {
            let cdSongs = try context.fetch(fetchRequest)
            return cdSongs.map { cdSong in
                return Song(
                    book: Int(cdSong.book),
                    songId: Int(cdSong.songId),
                    songNo: Int(cdSong.songNo),
                    title: cdSong.title ?? "",
                    alias: cdSong.alias ?? "",
                    content: cdSong.content ?? "",
                    views: Int(cdSong.views),
                    likes: Int(cdSong.likes),
                    liked: cdSong.liked,
                    created: cdSong.created ?? "",
                )
            }
        } catch {
            print("Failed to fetch songs: \(error)")
            return []
        }
    }
    
    // Fetch a single song by ID
    func fetchSong(withId id: Int) -> Song? {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdSong = results.first else { return nil }
            
            return Song(
                book: Int(cdSong.book),
                songId: Int(cdSong.songId),
                songNo: Int(cdSong.songNo),
                title: cdSong.title ?? "",
                alias: cdSong.alias ?? "",
                content: cdSong.content ?? "",
                views: Int(cdSong.views),
                likes: Int(cdSong.likes),
                liked: cdSong.liked,
                created: cdSong.created ?? "",
            )
        } catch {
            print("Failed to fetch song: \(error)")
            return nil
        }
    }
    
    // Delete a song by ID
    func deleteSong(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let songToDelete = results.first {
                context.delete(songToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete song: \(error)")
        }
    }
}

