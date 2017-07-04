//
//  RealmExtension.swift
//  UniApp
//
//  Created by Maurizio on 04/07/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}
