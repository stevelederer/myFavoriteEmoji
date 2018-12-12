//
//  PersonController.swift
//  myFavoriteEmoji
//
//  Created by Steve Lederer on 12/12/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

class PersonController {
    
    static let baseURL = URL(string: "https://myfavoriteemoji-d5eb4.firebaseio.com/people")
    
    static func getPerson(completion: @escaping (([Person]?) -> Void)) {
        guard let url = baseURL else { completion(nil) ; return }
        let fullUrl = url.appendingPathExtension("json")
        
        print("📡📡📡\(fullUrl.absoluteString)")
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            let jsonDecoder = JSONDecoder()
            do {
                let personDictionary = try jsonDecoder.decode([String : Person].self, from: data)
                let people = personDictionary.compactMap { $0.value }
                completion(people)
                return
            } catch {
                print("❌ There was an error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            }.resume()
    }
    
    static func postPerson(name: String, favoriteEmoji: String, completion: @escaping (Bool) -> Void) {
        guard let url = baseURL?.appendingPathExtension("json") else { completion(false) ; return }
        
        let person = Person(name: name, favoriteEmoji: favoriteEmoji)
        
        var request = URLRequest(url: url)
        
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(person)
            request.httpMethod = "POST"
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    completion(false)
                    return
                }
                print(response ?? "no response")
                completion(true)
            }.resume()
        } catch {
            print("❌ There was an error in \(#function) :  \(error) \(error.localizedDescription)")
            completion(false)
            return
        }
    }
}
