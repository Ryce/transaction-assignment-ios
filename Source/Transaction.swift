//
//  Transaction.swift
//  Loot-Example
//
//  Created by Hamon Riazy on 07/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import Foundation
import CoreLocation

let isoDateFormatter = ISO8601DateFormatter()

struct Transaction {
    let amount: String
    let authorisationDate: Date
    let description: String
    let location: CLLocationCoordinate2D
    let postTransactionBalance: String
    let settlementDate: Date
    
    init?(_ dict: [String : Any]) {
        guard let amount = dict["amount"] as? String,
            let authorisationDateString = dict["authorisation_date"] as? String,
            let authorisationDate = isoDateFormatter.date(from: authorisationDateString),
            let description = dict["authorisation_date"] as? String,
            let locationDict = dict["location"] as? [String : String],
            let locationLatitudeString = locationDict["latitude"],
            let locationLatitude = Double(locationLatitudeString),
            let locationLongitudeString = locationDict["longitude"],
            let locationLongitude = Double(locationLongitudeString),
            let postTransactionBalance = dict["post_transaction_balance"] as? String,
            let settlementDateString = dict["settlement_date"] as? String,
            let settlementDate = isoDateFormatter.date(from: settlementDateString) else { return nil }
        
        self.amount = amount
        self.authorisationDate = authorisationDate
        self.description = description
        self.location = CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
        self.postTransactionBalance = postTransactionBalance
        self.settlementDate = settlementDate
    }
}

struct TransactionRange {
    
    fileprivate var items: [[Transaction]]
    
    public var offset: Int? // pagination can be done with offset and size ...
    public var pageSize: Int?
    
    public var nextPage: String? // ... or should rather be done with a hash to preserve time
    
    init(_ items: [Transaction]) {
        
        var numberOfDays = -1
        var datesCounted = [Date]()
        var days = [[Transaction]]()
        
        items.sorted(by: { $0.authorisationDate > $1.authorisationDate }).forEach { (trx) in
            if !datesCounted.contains(trx.authorisationDate) {
                days.append([Transaction]())
                numberOfDays += 1
                datesCounted.append(trx.authorisationDate)
            } else {
                // TODO: what if the dates are not ordered?
            }
            days[numberOfDays].append(trx)
        }
        
        self.items = days
        
    }
    
}

extension TransactionRange: Collection {
    
    var startIndex : Int { return 0 }
    var endIndex : Int { return self.items.count }
    
    subscript(position : Int) -> [Transaction] {
        return self.items[position]
    }
    
    func index(after i: Int) -> Int {
        guard i != endIndex else { fatalError("Cannot increment endIndex") }
        return i + 1
    }
    
}

