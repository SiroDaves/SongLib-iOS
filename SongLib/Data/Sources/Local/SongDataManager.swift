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
    
    init(coreDataManager: CoreDataManager = .shared,
         bookDataManager: BookDataManager) {
        self.coreDataManager = coreDataManager
        self.bookDataManager = bookDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }
    
    func saveSong(_ song: Song) {
        context.perform {
            do {
                let cdSong = try self.fetchOrCreateCDSong(withId: song.songId)
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
                try self.context.save()
            } catch {
                print("❌ Failed to save song \(song.songId): \(error)")
            }
        }
    }
    
    func mapCdSongToSong(_ cdSong: CDSong) -> Song {
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
            created: cdSong.created ?? ""
        )
    }
    
    func fetchSongs() -> [Song] {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        do {
            let cdSongs = try context.fetch(fetchRequest)
            return cdSongs.map { cdSong in
                mapCdSongToSong(cdSong)
            }
        } catch {
            print("❌ Failed to fetch songs: \(error)")
            return []
        }
    }
    
    func fetchSong(withId songId: Int) -> Song? {
        do {
            guard let cdSong = try fetchCDSong(withId: songId) else { return nil }
            return mapCdSongToSong(cdSong)
        } catch {
            print("❌ Failed to fetch song with ID \(songId): \(error)")
            return nil
        }
    }
    
    func updateSong(_ song: Song) {
        context.perform {
            do {
                guard let cdSong = try self.fetchCDSong(withId: song.songId) else {
                    print("⚠️ Song with ID \(song.songId) not found.")
                    return
                }
                cdSong.title = song.title
                cdSong.alias = song.alias
                cdSong.content = song.content
                cdSong.liked = song.liked
                try self.context.save()
            } catch {
                print("❌ Failed to update song \(song.songId): \(error)")
            }
        }
    }
    
    func deleteSong(withId songId: Int) {
        context.perform {
            do {
                guard let cdSong = try self.fetchCDSong(withId: songId) else { return }
                self.context.delete(cdSong)
                try self.context.save()
            } catch {
                print("❌ Failed to delete song with ID \(songId): \(error)")
            }
        }
    }
    
    private func fetchCDSong(withId songId: Int) throws -> CDSong? {
        let request: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        request.predicate = NSPredicate(format: "songId == %d", songId)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchOrCreateCDSong(withId songId: Int) throws -> CDSong {
        if let existing = try fetchCDSong(withId: songId) {
            return existing
        } else {
            return CDSong(context: context)
        }
    }
    
    func deleteAllSongs() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSong.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All songs deleted successfully")
        } catch {
            print("❌ Failed to delete songs: \(error)")
        }
    }
}
