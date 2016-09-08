//
//  TransactionTableViewCell.swift
//  transaction-assignment
//
//  Created by Hamon Riazy on 07/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    static let identifier = "com.ryce.transaction-assignment.tableviewcellidentifier"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var transactionAmountLabel: UILabel!
    
}
