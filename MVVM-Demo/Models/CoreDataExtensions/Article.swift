//
//  Article.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

extension Article: Populatable {
    
    typealias DataType = ArticleResponse
    
    func populate(with data: ArticleResponse, coreDataHelper: CoreDataHelper) -> Self {
        try! quickPopulate(data: data)
        return self
    }
    
}
