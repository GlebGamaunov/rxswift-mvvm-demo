//
//  BaseRepository.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData
import RxSwift

/// Helper class for managing resource models between API and Core Data.
/// Resource models are models that conform to the Identifiable protocol.
/// Able to save API responses directly to Core Data as well as retrieving them.
protocol BaseRepository {
    associatedtype ModelType: Populatable
    
    init(coreDataHelper: CoreDataHelper)
    
    /// Returns core data object with the specified id (if it exists).
    ///
    /// - Parameter id: Object ID
    /// - Returns: Core data object
    func getById(id: Int32) -> Observable<ModelType?>
    
    /// Returns all objects of this repository's type.
    ///
    /// - Returns: List of Core data objects
    func getAll() -> Observable<[ModelType]>
    
    /// Saves a single instance of core data object populated with the specified data.
    ///
    /// - Parameter apiResponseData: Data to prefill the object with
    /// - Returns: Core data object
    func saveSingle(_ apiResponseData: ModelType.DataType) -> Observable<ModelType>
    
    /// Saves an array core data objects populated with the specified data.
    ///
    /// - Parameter apiResponseData: Data to prefill the objects with
    /// - Returns: Array of Core data objects
    func saveList(_ apiResponseData: [ModelType.DataType]) -> Observable<[ModelType]>
    
    /// Saves the Core data context associated with this repository.
    func saveRepository()
}

class BaseRepositoryImpl<ModelType: Populatable>: BaseRepository {
    
    internal var coreDataHelper: CoreDataHelper
    
    required init(coreDataHelper: CoreDataHelper) {
        self.coreDataHelper = coreDataHelper
    }
    
    func getById(id: Int32) -> Observable<ModelType?> {
        return coreDataHelper.getObjectById(ModelType.self, id: id)
    }
    
    func getAll() -> Observable<[ModelType]> {
        return coreDataHelper.getObjects(ModelType.self)
    }
    
    func saveSingle(_ apiResponseData: ModelType.DataType) -> Observable<ModelType> {
        return initFromResponse(apiResponseData)
            .do(onNext: { [unowned self] object in
                if object.hasChanges {
                    self.coreDataHelper.saveContext()
                }
            })
    }
    
    func saveList(_ apiResponseData: [ModelType.DataType]) -> Observable<[ModelType]> {
        var objectList = [Observable<ModelType>]()
        objectList.reserveCapacity(apiResponseData.count)
        for data in apiResponseData {
            objectList.append(initFromResponse(data))
        }
        return Observable.zip(objectList)
            .do(onNext: {  [unowned self] objectList in
                if objectList.first(where: { $0.hasChanges }) != nil {
                    self.coreDataHelper.saveContext()
                }
            })
    }
    
    func saveRepository() {
        coreDataHelper.saveContext()
    }
    
    private func initFromResponse(_ apiResponseData: ModelType.DataType) -> Observable<ModelType> {
        return coreDataHelper.getExistingOrNew(ModelType.self, id: apiResponseData.id)
            .map { [unowned self] in $0.populate(with: apiResponseData, coreDataHelper: self.coreDataHelper) }
    }
    
}