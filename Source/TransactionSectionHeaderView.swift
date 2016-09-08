//
//  TransactionSectionHeaderView.swift
//  transaction-assignment
//
//  Created by Hamon Riazy on 07/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

class TransactionSectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "com.ryce.transaction-assignment.tableviewheaderidentifier"
    
    let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 20.0))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
