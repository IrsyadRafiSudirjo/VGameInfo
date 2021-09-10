//
//  GameProvider.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 08/09/21.
//

import CoreData
import UIKit

class GameProvider {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGameDataModel")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()

    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    
    func getAllGames(completion: @escaping(_ games: [Results]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [Results] = []
                for result in results {
                    let game = Results(
                        id: result.value(forKeyPath: "id") as? Int,
                        background_image: result.value(forKeyPath: "background_image") as? String,
                        name: result.value(forKeyPath: "name") as? String,
                        rating: (result.value(forKeyPath: "rating") as? Double)!,
                        released: result.value(forKeyPath: "released") as? String,
                        updated: result.value(forKeyPath: "updateDate") as? String
                    )
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func createGame(
        _ id: Int,
        _ name: String,
        _ background_image: String,
        _ rating: Double,
        _ released: String,
        _ updated: String,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: taskContext) {
                let member = NSManagedObject(entity: entity, insertInto: taskContext)
                    member.setValue(id, forKeyPath: "id")
                    member.setValue(name, forKeyPath: "name")
                    member.setValue(background_image, forKeyPath: "background_image")
                    member.setValue(rating, forKeyPath: "rating")
                    member.setValue(released, forKeyPath: "released")
                    member.setValue(updated, forKeyPath: "updateDate")
                    do {
                        try taskContext.save()
                        completion()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
    
    func getMaxId(gameId: Int,completion: @escaping(_ maxId: Int) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            fetchRequest.predicate = NSPredicate(
                format: "id = %@", "\(gameId)"
            )
            fetchRequest.fetchLimit = 1
            do {
                let lastMember = try taskContext.fetch(fetchRequest)
                if let member = lastMember.first, let position = member.value(forKeyPath: "id") as? Int {
                    completion(position)
                } else {
                    completion(0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteGame(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
}
