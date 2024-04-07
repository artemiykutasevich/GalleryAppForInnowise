//
//  CoreDataService.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 6.04.24.
//

import Foundation
import CoreData

// MARK: - CoreDataServiceProtocol

protocol CoreDataServiceProtocol {
    func getFavorites() -> [PageItem]
    func addFavorite(item: PageItem)
    func removeFavorite(item: PageItem)
}

// MARK: - CoreDataService

final class CoreDataService {
    private let coreDataStack = CoreDataStack(modelName: "GalleryAppForInnowise")

    private var context: NSManagedObjectContext {
        coreDataStack.managedContext
    }

    private func saveContext() {
        coreDataStack.saveContext()
    }

    private func findItem(with id: String) -> CDPageItem? {
        let fetchRequest: NSFetchRequest<CDPageItem> = CDPageItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cdID == %@", id)
        do {
            let result = try context.fetch(fetchRequest).first
            return result
        } catch {
            debugPrint("❌ CoreDataService: can't find object with id \(id)")
            return nil
        }
    }

    private func connect(_ page: CDPageItem, _ size: CDPageItemSize) {
        page.cdSize = size
        size.cdPage = page
    }

    private func connect(_ page: CDPageItem, _ post: CDPageItemPost) {
        page.cdPost = post
        post.cdPage = page
    }

    private func connect(_ page: CDPageItem, _ links: CDPageItemURL) {
        page.cdLinks = links
        links.cdPage = page
    }
}

extension CoreDataService: CoreDataServiceProtocol {
    func getFavorites() -> [PageItem] {
        let fetchRequest: NSFetchRequest<CDPageItem> = CDPageItem.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result.toPage()
        } catch {
            debugPrint("❌ CoreDataService: can't fetch favorites  \(error.localizedDescription)")
            return []
        }
    }

    func addFavorite(item: PageItem) {
        guard findItem(with: item.id) == nil else {
            debugPrint("♻️ CoreDataService: is not new item")
            return
        }
        let page = CDPageItem(context: context)
        page.cdID = item.id
        page.cdFavorite = item.isFavorite
        page.cdCreateDate = item.createAt
        let size = CDPageItemSize(context: context)
        size.update(with: item.size)
        connect(page, size)
        let post = CDPageItemPost(context: context)
        post.update(with: item.post)
        connect(page, post)
        let links = CDPageItemURL(context: context)
        links.update(with: item.urls)
        connect(page, links)
        saveContext()
    }

    func removeFavorite(item: PageItem) {
        guard let deletingItem = findItem(with: item.id) else { return }
        context.delete(deletingItem)
        saveContext()
    }
}

// MARK: - Array<T: CDPageItem>

fileprivate extension Array where Element == CDPageItem {
    func toPage() -> [PageItem] {
        self.compactMap({ $0.toPageItem() })
    }
}

// MARK: - CDPageItem

fileprivate extension CDPageItem {
    func toPageItem() -> PageItem {
        return PageItem(
            id: cdID ?? "",
            isFavorite: cdFavorite,
            createAt: cdCreateDate ?? Date(),
            size: cdSize?.toSize() ?? CGSize(),
            post: cdPost?.toPost() ?? PageItemPost(),
            urls: cdLinks?.toLinks() ?? PageItemURL()
        )
    }
}

// MARK: - CDPageItemSize

fileprivate extension CDPageItemSize {
    func update(with: CGSize) {
        cdWidth = with.width.toInt16()
        cdHeight = with.height.toInt16()
    }

    func toSize() -> CGSize {
        return CGSize(
            width: cdWidth.toCGFloat(),
            height: cdHeight.toCGFloat()
        )
    }
}

// MARK: - CDPageItemPost

fileprivate extension CDPageItemPost {
    func update(with: PageItemPost) {
        cdTitle = with.title
        cdDescription = with.description
    }

    func toPost() -> PageItemPost {
        return PageItemPost(
            title: cdTitle ?? "",
            description: cdDescription
        )
    }
}

// MARK: - CDPageItemURL

fileprivate extension CDPageItemURL {
    func update(with: PageItemURL) {
        cdPreview = with.small
        cdRegular = with.regular
    }

    func toLinks() -> PageItemURL {
        return PageItemURL(
            small: cdPreview ?? "",
            regular: cdRegular ?? ""
        )
    }
}
