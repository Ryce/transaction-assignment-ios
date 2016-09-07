//
//  Session.swift
//  Loot-Example
//
//  Created by Hamon Riazy on 07/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case networkFailure(String)
    case jsonParsingError
    case parsingError
}

struct Session {
    let endpoint = "https://private-710eeb-lootiosinterview.apiary-mock.com/transactions"
    
    func fetchTransactions(completion: @escaping (Result<TransactionRange>) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            guard let url = URL(string: self.endpoint) else { fatalError("URL must be provided") }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return // BAIL
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.networkFailure("No Data provided")))
                    }
                    return // BAIL
                }
                
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String : Any]] else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.jsonParsingError))
                    }
                    return // BAIL
                }
                
                let transactions = TransactionRange(json.flatMap({ Transaction($0) }))
                
                guard transactions.count != 0 else {
                    DispatchQueue.main.async {
                        completion(.failure(SessionError.parsingError))
                    }
                    return // BAIL
                }
                
                DispatchQueue.main.async {
                    completion(.success(transactions))
                }
                
            }
            
            task.resume()
        }
    }
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}
