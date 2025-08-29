//
//  ListingDataManager.swift
//  ListingLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class ListingDataManager {
    private let cdManager: CoreDataManager
    
    init(cdManager: CoreDataManager = .shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        cdManager.viewContext
    }
    
    func saveListing(title: String, parentId: Int, songId: Int) {
        context.perform {
            do {
                let cdListing = CDListng(context: self.context)
                cdListing.id = self.cdManager.nextId(context: self.context, entity: "CDListng")
                cdListing.parentId = Int32(parentId)
                cdListing.songId = Int32(songId)
                cdListing.title = title
                cdListing.createdAt = Date()
                cdListing.updatedAt = Date()
                
                try self.context.save()
                print("✅ New listing \(title) saved")
            } catch {
                print("❌ Failed to save listing: \(error)")
            }
        }
    }
    
    func fetchListings(with predicate: NSPredicate? = nil) -> [Listing] {
        let request: NSFetchRequest<CDListng> = CDListng.fetchRequest()
        request.predicate = predicate

        do {
            let cdListings = try context.fetch(request)
            return cdListings.compactMap(mapCDListing)
        } catch {
            print("❌ Failed to fetch listings: \(error)")
            return []
        }
    }

    func fetchListings() -> [Listing] {
        let predicate = NSPredicate(format: "songId == %d", 0)
        return fetchListings(with: predicate)
    }

    func fetchChildListings(for parentId: UUID) -> [Listing] {
        let predicate = NSPredicate(format: "parentId == %@", parentId as CVarArg)
        return fetchListings(with: predicate)
    }

    private func fetchChildListingCount(for parentId: Int) -> Int {
        let request: NSFetchRequest<CDListng> = CDListng.fetchRequest()
        request.predicate = NSPredicate(format: "parentId == %@", parentId as CVarArg)

        do {
            return try context.count(for: request)
        } catch {
            print("❌ Failed to count child listings for parent \(parentId): \(error)")
            return 0
        }
    }

    func fetchListing(withId id: Int) -> Listing? {
        do {
            guard let cdListing = try fetchCDListing(withId: id) else { return nil }
            return Listing(
                id: Int(cdListing.id),
                parentId: Int(cdListing.parentId),
                songId: Int(cdListing.songId),
                title: cdListing.title!,
                createdAt: cdListing.createdAt!,
                updatedAt: cdListing.updatedAt!
            )
        } catch {
            print("❌ Failed to fetch listing with ID \(id): \(error)")
            return nil
        }
    }
    
    func updateListing(_ listing: Listing) {
        context.perform {
            do {
                guard let cdListing = try self.fetchCDListing(withId: listing.id) else {
                    print("⚠️ Listing with ID \(listing.id) not found.")
                    return
                }
                cdListing.title = listing.title
                cdListing.updatedAt = Date()
                try self.context.save()
            } catch {
                print("❌ Failed to update listing \(listing.id): \(error)")
            }
        }
    }
    
    func deleteListing(withId id: Int) {
        context.perform {
            do {
                guard let cdListing = try self.fetchCDListing(withId: id) else { return }
                self.context.delete(cdListing)
                try self.context.save()
            } catch {
                print("❌ Failed to delete listing with ID \(id): \(error)")
            }
        }
    }
    
    func deleteAllListings() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDListng.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All listings deleted successfully")
        } catch {
            print("❌ Failed to delete listings: \(error)")
        }
    }
    
    private func mapCDListing(_ cdListing: CDListng) -> Listing? {
        let songCount = fetchChildListingCount(for: Int(cdListing.id))
        return Listing(
            id: Int(cdListing.id),
            parentId: Int(cdListing.parentId),
            songId: Int(cdListing.songId),
            title: cdListing.title ?? "Untitled listing",
            createdAt: cdListing.createdAt!,
            updatedAt: cdListing.updatedAt!,
            songCount: songCount
        )
    }
    
    private func fetchCDListing(withId id: Int) throws -> CDListng? {
        let request: NSFetchRequest<CDListng> = CDListng.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchOrCreateCDListing(withId id: Int) throws -> CDListng {
        if let existing = try fetchCDListing(withId: id) {
            return existing
        } else {
            return CDListng(context: context)
        }
    }
}
