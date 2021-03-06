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
            news = Array(realm.objects(NewsRealm.self).sorted(byKeyPath: "pub_date", ascending: false)
)
            //print(news)
            
        } catch _ {
            // ...
        }
        return news
    }
    
    func ritornaDicionaryArrayRealmOrari() -> Dictionary<String, Array<OrarioRealm>>{
        var orari = [OrarioRealm]()
        let dataOdierna = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let result = formatter.string(from: dataOdierna)

        var emptyDictionary = [String: Array<OrarioRealm>]()
        do {
            let realm = try Realm()
            orari = realm.objects(OrarioRealm).sorted(byKeyPath: "time_start").toArray() //print(orari)
            if orari.count > 0 {
                let primaData = orari[0].dataLezione
                var data = orari[0].dataLezione
                var arrayOrariCorrenti = [OrarioRealm]()
                for orario in orari {
                    if (orario.dataLezione >= result) {
                    if (data != orario.dataLezione) {
                        emptyDictionary[data] = arrayOrariCorrenti
                        data = orario.dataLezione
                        print("DATA ", orario.dataLezione)
                        arrayOrariCorrenti.removeAll()
                    }
                    
                    arrayOrariCorrenti.append(orario)
                    
                    }
                }
                
                print("AAA ", emptyDictionary[primaData]?.count)
                if emptyDictionary[primaData]?.count == 0 {
                    print("PRIMA DATA 0: ")
                }
            }
        } catch _ { // ...
        }
        return emptyDictionary
    }
    
}
