//
//  MasterViewController.swift
//  Loot-Example
//
//  Created by Hamon Riazy on 07/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let session = Session()
    
    private var _transactions: TransactionRange?
    
    var transactions: TransactionRange? {
        get {
            if self._transactions == nil {
                session.fetchTransactions(completion: { (result) in
                    switch result {
                    case .success(let transactions):
                        self._transactions = transactions
                        self.tableView.reloadData()
                    case .failure(let error):
                        // TODO: show proper error
                        self.showAlert(with: error.localizedDescription)
                        break
                    }
                })
            }
            return _transactions
        }
        set {
            self._transactions = newValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let transaction = transactions![indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = transaction
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (transactions?.count) ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = transactions?[section] ?? []
        return section.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let transaction = transactions![indexPath.section][indexPath.row]
        cell.textLabel!.text = transaction.amount
        return cell
    }
    
    // Helpers
    
    func showAlert(with errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

