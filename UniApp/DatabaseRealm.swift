//
//  DatabaseRealm.swift
//  UniApp
//
//  Created by Maurizio on 28/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import RealmSwift
class DatabaseRealm: NSObject {

    func ritornaArrayNews() -> Array<NewsRealm> {
        var news = [NewsRealm]()
        do {
            let realm = try Realm()
            news = Array(realm.objects(NewsRealm.self))
            //print(news)
            
            
        } catch _ {
            // ...
        }
        return news
    }
    
    func ritornaArrayOrari() ->Array<Any> {
        var orari = [OrarioRealm]()
        do {
            let realm = try Realm()
            orari = realm.objects(OrarioRealm).toArray()
            //print(orari)
        
            
        } catch _ {
            // ...
        }
        
        return orari
    }
    
}
