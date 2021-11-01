//
//  DatabaseService.swift
//  MVP test-project
//
//  Created by eduard.stern on 01.11.2021.
//

import UIKit
import CoreData

enum Entities: String {
    case Favourites
    case Hidden
}

protocol DatabaseServiceInterface {
    func insert(in entity: Entities, movie: MovieDetails)
    func removeFavourite(movie: MovieDetails)
    func getMovies(in entity: Entities, completion: (_ moives: [MovieDetails]) -> Void)
}

class DatabaseService: DatabaseServiceInterface {

    let favouritesIdKey = "id"
    let favouritesTitleKey = "title"
    let favouritesDescriptionKey = "plot"
    let favouritesImageKey = "image"
    let favouritesImDbRating = "rating"
    let favouritesFullTitle = "full_title"

    func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        return appDelegate.persistentContainer.viewContext
    }

    func insert(in entity: Entities, movie: MovieDetails) {

        guard let managedContext = getManagedContext(),
              let entity = NSEntityDescription.entity(forEntityName: entity.rawValue,
                                                      in: managedContext) else {
            return
        }

        let currencyPair = NSManagedObject(entity: entity,
                                           insertInto: managedContext)

        currencyPair.setValue(movie.id,
                              forKeyPath: favouritesIdKey)

        if let title = movie.title {
            currencyPair.setValue(title,
                                  forKeyPath: favouritesTitleKey)
        }

        if let plot = movie.plot {
            currencyPair.setValue(plot,
                                  forKeyPath: favouritesDescriptionKey)
        }

        if let image = movie.image {
            currencyPair.setValue(image,
                                  forKeyPath: favouritesImageKey)
        }

        if let rating = movie.imDbRating {
            currencyPair.setValue(rating,
                                  forKeyPath: favouritesImDbRating)
        }

        if let fullTitle = movie.fullTitle {
            currencyPair.setValue(fullTitle,
                                  forKeyPath: favouritesFullTitle)
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getMovies(in entity: Entities, completion: (_ moives: [MovieDetails]) -> Void) {

        guard let managedContext = getManagedContext() else {
            return
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)

        do {
            let managedObjects = try managedContext.fetch(fetchRequest)
            let movies = managedObjects.map { (object) -> MovieDetails in
                let id = object.value(forKey: favouritesIdKey) as? String
                let title = object.value(forKey: favouritesTitleKey) as? String
                let plot = object.value(forKey: favouritesDescriptionKey) as? String
                let image = object.value(forKey: favouritesImageKey) as? String
                let fullTitle = object.value(forKey: favouritesFullTitle) as? String
                let rating = object.value(forKey: favouritesImDbRating) as? String

                return MovieDetails (id: id ?? UUID().uuidString,
                                     title: title,
                                     fullTitle: fullTitle,
                                     plot: plot,
                                     errorMessage: nil,
                                     image: image,
                                     imDbRating: rating)
            }
            completion(movies)
        } catch let error as NSError {
            completion([])
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


    func removeFavourite(movie: MovieDetails) {

        guard let managedContext = getManagedContext() else {
            return
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.Favourites.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == %@", movie.id)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
