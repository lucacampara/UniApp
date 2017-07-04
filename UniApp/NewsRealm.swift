//
//  NewsRealm.swift
//  UniApp
//
//  Created by Maurizio on 28/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import RealmSwift
class NewsRealm: Object {
    
    
    dynamic var id = ""
    dynamic var createdAt = ""
    dynamic var updatedAt = ""
    dynamic var slug = ""
    dynamic var status = ""
    dynamic var link = ""
    dynamic var title = ""
    dynamic var content = ""
    dynamic var excerpt = ""
    dynamic var sticky = ""
    dynamic var media = ""
    dynamic var pub_date = ""
    dynamic var v = ""
    
    dynamic var dataNews = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
