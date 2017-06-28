//
//  ChiamateAPI.swift
//  UniApp
//
//  Created by Maurizio on 26/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit

protocol chiamateAPIDelegate: class {
    func registra(access_token:String, id: String, errore: Bool, tipoErrore: String)
}

protocol controllaCaricamento: class {
    func finitoDiCaricare()
}

enum RichiestaPOST {
    case SIGNUP     //"http://apiunipn.parol.in/V1/user/signup"
    case LOGIN      // "http://apiunipn.parol.in/V1/user/login"
    case FACEBOOK_LOGIN //"apiunipn.parol.in/V1/user/facebook/login"
}

enum RichiestaGET {
    case POSTS     //"apiunipn.parol.in/V1/posts"
    case TIMETABLE      // "apiunipn.parol.in/V1/timetable"
    case TIMETABLE_ITS //"apiunipn.parol.in/V1/timetable/"
    case TIMETABLE_UNITS
    case TIMETABLE_UNIUD
    case TIMETABLE_ISIA
}

class ChiamateAPI: NSObject {
    
    weak var delegate:chiamateAPIDelegate?
    weak var delegateCaricamento:controllaCaricamento?

    
    func richiestaAutenticazionePOST(email: String, password: String, scelta: RichiestaPOST) {
        print("prova")
        
        var access_token = ""
        var id = ""
        var errorMessage = ""
        
        let login = ["email":email, "password":password]
        
        //let url = NSURL(string: "http://apiunipn.parol.in/V1/user/signup")!
        var url: NSURL
        
        //let test = Richiesta.SIGNUP;
        
        switch scelta {
        case .SIGNUP:
            url = NSURL(string: "http://apiunipn.parol.in/V1/user/signup")!
        case .FACEBOOK_LOGIN:
            url = NSURL(string: "http://apiunipn.parol.in/V1/user/facebook/login")!
        case .LOGIN:
            url = NSURL(string: "http://apiunipn.parol.in/V1/user/login")!
        
        }
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        
        do {
            // JSON all the things
            let auth = try JSONSerialization.data(withJSONObject: login, options: .prettyPrinted)
            
            // Set the request content type to JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // The magic...set the HTTP request method to POST
            request.httpMethod = "POST"
            
            // Add the JSON serialized login data to the body
            request.httpBody = auth
            
            // Create the task that will send our login request (asynchronously)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                // Do something with the HTTP response
                print("Got response \(String(describing: response)) with error \(String(describing: error))")
                print("Done.")
                
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("STATUS CODE",httpResponse.statusCode)
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        
                        errorMessage = (responseJSON["error"] ?? "errore") as! String
                        
                        //print("prova print",access_token, id)
                        
                        self.delegate?.registra(access_token: "ERRORE", id: "", errore: true, tipoErrore: errorMessage)
                    }
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    access_token = (responseJSON["access_token"] ?? "errore") as! String
                    id = (responseJSON["id"] ?? "errore") as! String
                    
                    //print("prova print",access_token, id)
                    
                    self.delegate?.registra(access_token: access_token, id: id, errore: false, tipoErrore: "")
                }
                
                
            })
            
            // Start the task on a background thread
            task.resume()
            
        } catch {
            // Handle your errors folks...
            print("Error")
        }
    }
    
    func richiesteDatiGET(access_token: String, scelta: RichiestaGET, pagina: Int) {
        var url: NSURL
        
        //let test = Richiesta.SIGNUP;
        
        switch scelta {
        case .POSTS:
            url = NSURL(string: "http://apiunipn.parol.in/V1/posts/\(pagina)")!
        case .TIMETABLE:
            url = NSURL(string: "http://apiunipn.parol.in/V1/timetable")!
        case .TIMETABLE_ITS:
            url = NSURL(string: "http://apiunipn.parol.in/V1/timetable/its")!
        case .TIMETABLE_UNITS:
            url = NSURL(string: "http://apiunipn.parol.in/V1/timetable/units")!
        case .TIMETABLE_UNIUD:
            url = NSURL(string: "http://apiunipn.parol.in/V1/timetable/uniud")!
        case .TIMETABLE_ISIA:
            url = NSURL(string: "http://apiunipn.parol.in/V1/timetable/isia")!
            
        }
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        
        do {
            // JSON all the things
            //let auth = try JSONSerialization.data(withJSONObject: login, options: .prettyPrinted)
            
            // Set the request content type to JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // The magic...set the HTTP request method to POST
            request.httpMethod = "GET"
            
            
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            
            // Add the JSON serialized login data to the body
            //request.httpBody = auth
            
            // Create the task that will send our login request (asynchronously)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                // Do something with the HTTP response
                print("Got response \(String(describing: response)) with error \(String(describing: error))")
                print("Done.")
                
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("STATUS CODE",httpResponse.statusCode)
                    if (httpResponse.statusCode != 200) {
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        
                        //errorMessage = (responseJSON["error"] ?? "errore") as! String
                        
                        //print("prova print",access_token, id)
                        
                        //self.delegate?.registra(access_token: "ERRORE", id: errorMessage)
                        
                    
                        
                        }
                    }
                }
                
                if (scelta == .POSTS) {
                var posts = [[ : ]]
                
                do {
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let dati = json["data"] as? [[String: Any]] {
                        for campo in dati {
                            
                            var myDictionraryPost = [String: String]()
                            
                            myDictionraryPost["_id"] = campo["_id"] as? String
                            myDictionraryPost["createdAt"] = campo["createdAt"] as? String
                            myDictionraryPost["updatedAt"] = campo["updatedAt"] as? String
                            myDictionraryPost["slug"] = campo["slug"] as? String
                            myDictionraryPost["status"] = campo["status"] as? String
                            myDictionraryPost["link"] = campo["link"] as? String
                            myDictionraryPost["title"] = campo["title"] as? String
                            myDictionraryPost["content"] = campo["content"] as? String
                            myDictionraryPost["excerpt"] = campo["excerpt"] as? String
                            //myDictionraryPost["sticky"] = campo["sticky"] as? String
                            myDictionraryPost["media"] = campo["media"] as? String
                            myDictionraryPost["pub_date"] = campo["pub_date"] as? String
                            //myDictionraryPost["__v"] = campo["__v"] as? String
                            
                            let myBool = campo["__v"] as? Bool;
                            let myString: String = String(myBool!);
                            myDictionraryPost["__v"] = myString
                            
                            let myBoolDue = campo["sticky"] as? Bool;
                            let myStringDue: String = String(myBoolDue!);
                            myDictionraryPost["sticky"] = myStringDue
                            
                            
                            /*
                            if let id = campo["_id"] as? String {
                                posts.append(id)
                            }
                            if let createdAt = campo["createdAt"] as? String {
                                posts.append(createdAt)
                            }
                            if let updatedAt = campo["updatedAt"] as? String {
                                posts.append(updatedAt)
                            }
                            if let slug = campo["slug"] as? String {
                                posts.append(slug)
                            }
                            if let status = campo["status"] as? String {
                                posts.append(status)
                            }
                            if let link = campo["link"] as? String {
                                posts.append(link)
                            }
                            if let title = campo["title"] as? String {
                                posts.append(title)
                            }
                            if let content = campo["content"] as? String {
                                posts.append(content)
                            }
                            if let excerpt = campo["excerpt"] as? String {
                                posts.append(excerpt)
                            }
                            if let sticky = campo["sticky"] as? String {
                                posts.append(sticky)
                            }
                            if let media = campo["media"] as? String {
                                posts.append(media)
                            }
                            if let pub_date = campo["pub_date"] as? String {
                                posts.append(pub_date)
                            }
                            if let v = campo["__v"] as? String {
                                posts.append(v)
                            }
                            */
                            
                            posts.append(myDictionraryPost)
                            //print("dictionary",myDictionraryPost)
                            //print("")
                        }
                        self.delegateCaricamento?.finitoDiCaricare()
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                print(posts)
                }
                
                if (scelta == .TIMETABLE || scelta == .TIMETABLE_ITS || scelta == .TIMETABLE_UNITS || scelta == .TIMETABLE_UNIUD || scelta == .TIMETABLE_ISIA) {
                    
                    var timetable = [[ : ]]
                    
                    do {
                        if let data = data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let lezione = json["month"] as? [[String: Any]] {
                            for campo in lezione {
                                
                                var myDictionraryTimetable = [String: String]()
                                
                                //myDictionraryTimetable["day"] = campo["day"] as? String
                                
                                let pra =  campo["classes"] as? [[String: Any]]
                                //print(pra?.first)
                                
                                for p in pra! {
                                    
                                    let classId = p["class_id"] as? Int;
                                    let classIdString: String = String(classId!);
                                    myDictionraryTimetable["class_id"] = classIdString
                                    

                                    myDictionraryTimetable["name"] = p["name"] as? String
                                    myDictionraryTimetable["prof"] = p["prof"] as? String
                                    myDictionraryTimetable["class"] = p["class"] as? String
                                    myDictionraryTimetable["date"] = p["date"] as? String
                                    myDictionraryTimetable["time_start"] = p["time_start"] as? String
                                    myDictionraryTimetable["time_end"] = p["time_end"] as? String
                                    myDictionraryTimetable["course"] = p["course"] as? String
                                    myDictionraryTimetable["type"] = p["type"] as? String
                                    myDictionraryTimetable["pub_date"] = p["pub_date"] as? String
                                    
                                    let area = p["area"] as? Int;
                                    let areaString: String = String(area!);
                                    myDictionraryTimetable["area"] = areaString
                                }
                                print (myDictionraryTimetable)
                                timetable.append(myDictionraryTimetable)
                                print("dictionary",myDictionraryTimetable)
                                print("")
                            }
                            self.delegateCaricamento?.finitoDiCaricare()
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                    
                }
                
                
            })
            
            // Start the task on a background thread
            task.resume()
            
        } catch {
            // Handle your errors folks...
            print("Error")
        }

    }
}