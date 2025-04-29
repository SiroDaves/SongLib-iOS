//
//  CoreDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SongLib")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // CoreData operations for Books
    func saveBooks(_ books: [Book]) {
        let context = viewContext
        
        // First delete existing books
        let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        
        do {
            let existingBooks = try context.fetch(fetchRequest)
            for book in existingBooks {
                context.delete(book)
            }
            
            // Then save new books
            for book in books {
                let cdBook = CDBook(context: context)
                cdBook.id = book.id
                cdBook.title = book.title
                cdBook.author = book.author
                cdBook.coverImage = book.coverImage
            }
            
            try context.save()
        } catch {
            print("Failed to save books: \(error)")
        }
    }
    
    func fetchBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        
        do {
            let cdBooks = try viewContext.fetch(fetchRequest)
            return cdBooks.map { cdBook in
                return Book(
                    id: cdBook.id ?? "",
                    title: cdBook.title ?? "",
                    author: cdBook.author ?? "",
                    coverImage: cdBook.coverImage
                )
            }
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
    
    // CoreData operations for Songs
    func saveSongs(_ songs: [Song], for bookId: String) {
        let context = viewContext
        
        // First delete existing songs for the book
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %@", bookId)
        
        do {
            let existingSongs = try context.fetch(fetchRequest)
            for song in existingSongs {
                context.delete(song)
            }
            
            // Then save new songs
            for song in songs {
                let cdSong = CDSong(context: context)
                cdSong.id = song.id
                cdSong.title = song.title
                cdSong.lyrics = song.lyrics
                cdSong.bookId = song.bookId
            }
            
            try context.save()
        } catch {
            print("Failed to save songs: \(error)")
        }
    }
    
    func fetchSongs(for bookId: String? = nil) -> [Song] {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        
        if let bookId = bookId {
            fetchRequest.predicate = NSPredicate(format: "bookId == %@", bookId)
        }
        
        do {
            let cdSongs = try viewContext.fetch(fetchRequest)
            return cdSongs.map { cdSong in
                return Song(
                    id: cdSong.id ?? "",
                    title: cdSong.title ?? "",
                    lyrics: cdSong.lyrics ?? "",
                    bookId: cdSong.bookId ?? ""
                )
            }
        } catch {
            print("Failed to fetch songs: \(error)")
            return []
        }
    }
}
