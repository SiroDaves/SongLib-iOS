//
//  ListingDataManager.swift
//  ListingLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class ListingDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }
    
    func saveListing(_ listing: Listing) {
        context.perform {
            do {
                let cdListing = try self.fetchOrCreateCDListing(withId: listing.id)
                cdListing.id = listing.id
                cdListing.parentId = listing.parentId
                cdListing.songId = Int32(listing.songId)
                cdListing.title = listing.title
                cdListing.createdAt = listing.createdAt
                cdListing.updatedAt = listing.updatedAt
                try self.context.save()
                print("✅ New listing \(listing.title) added")
            } catch {
                print("❌ Failed to save listing \(listing.id): \(error)")
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

    private func fetchChildListingCount(for parentId: UUID) -> Int {
        let request: NSFetchRequest<CDListng> = CDListng.fetchRequest()
        request.predicate = NSPredicate(format: "parentId == %@", parentId as CVarArg)

        do {
            return try context.count(for: request)
        } catch {
            print("❌ Failed to count child listings for parent \(parentId): \(error)")
            return 0
        }
    }

    func fetchListing(withId id: UUID) -> Listing? {
        do {
            guard let cdListing = try fetchCDListing(withId: id) else { return nil }
            return Listing(
                id: cdListing.id!,
                parentId: cdListing.parentId!,
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
    
    func deleteListing(withId id: UUID) {
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
        guard let id = cdListing.id,
              let parentId = cdListing.parentId,
              let createdAt = cdListing.createdAt,
              let updatedAt = cdListing.updatedAt else { return nil }

        let songCount = fetchChildListingCount(for: id)

        return Listing(
            id: id,
            parentId: parentId,
            songId: Int(cdListing.songId),
            title: cdListing.title ?? "Untitled listing",
            createdAt: createdAt,
            updatedAt: updatedAt,
            songCount: songCount
        )
    }
    
    private func fetchCDListing(withId id: UUID) throws -> CDListng? {
        let request: NSFetchRequest<CDListng> = CDListng.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchOrCreateCDListing(withId id: UUID) throws -> CDListng {
        if let existing = try fetchCDListing(withId: id) {
            return existing
        } else {
            return CDListng(context: context)
        }
    }
}
