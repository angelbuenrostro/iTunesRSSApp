//
//  HomeTableViewController.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/10/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "iTunes RSS"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Prepare cells for dynamic sizing
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register custom cell
        tableView.register(MediaTableViewCell.self, forCellReuseIdentifier: "mediaCellID")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCellID", for: indexPath)
        
        guard let resultCell = cell as? MediaTableViewCell else { return cell }

        return resultCell
    }
    

   
}
