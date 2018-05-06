//
//  AllPostsTableViewModel.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

class AllPostsTableViewModel {
    var dysiDataManager: DySiDataManagerProtocol!
    
    init() {
        self.dysiDataManager = DySiDataManager()
    }
}
