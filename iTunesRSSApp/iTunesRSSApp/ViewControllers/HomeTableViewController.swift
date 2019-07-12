//
//  HomeTableViewController.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/10/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit
import Hero

class HomeTableViewController: UITableViewController {
    
    private let client = NetworkClient()
    private let control: UISegmentedControl = UISegmentedControl(items: ["Apple Music","Audio Books","TV Shows"])
    private var mediaType = MediaType.appleMusic.rawValue
    
    // Contains fetch results and updates the tableview whenever the value is set
    private(set) var fetchResults = [Result]() {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.navigationItem.titleView != self.control {
                    self.addControlHeader(size: self.view.frame.width - self.view.frame.midX)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationItem.titleView?.setNeedsDisplay()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable Hero Transitions
        self.hero.isEnabled = true
        
        // Add Header
        addControlHeader(size: CGFloat(view.frame.width - view.frame.midX))
        
        // Prepare cells for dynamic sizing
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register custom cell
        tableView.register(MediaTableViewCell.self, forCellReuseIdentifier: "mediaCellID")
        
        // Fetch data
        client.fetchRSS { (results, error) in
            if let error = error {
                NSLog("Error fetching results: \(error.localizedDescription)")
                return
            }
            if let results = results {
                self.fetchResults = results
            }
        }
    }
    
    func addControlHeader(size: CGFloat){
        
        control.addTarget(self, action: #selector(tappedControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        control.tintColor = #colorLiteral(red: 0.3246651888, green: 0.3246651888, blue: 0.3246651888, alpha: 1)
        navigationItem.titleView = control
        control.centerInSuperview()
        switch mediaType {
        case MediaType.appleMusic.rawValue:
            control.selectedSegmentIndex = 0
        case MediaType.audioBooks.rawValue:
            control.selectedSegmentIndex = 1
        case MediaType.tvShows.rawValue:
            control.selectedSegmentIndex = 2
        default:
            break
        }
    }
    
    @objc private func tappedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mediaType = MediaType.appleMusic.rawValue
            sender.selectedSegmentIndex = 0
        case 1:
            mediaType = MediaType.audioBooks.rawValue
            sender.selectedSegmentIndex = 1
        case 2:
            mediaType = MediaType.tvShows.rawValue
            sender.selectedSegmentIndex = 2
        default:
            break
        }
        
        // Fetch data
        client.fetchRSS(mediaType: mediaType) { (results, error) in
            if let error = error {
                NSLog("Error fetching results: \(error.localizedDescription)")
                return
            }
            if let results = results {
                self.fetchResults = results
            }
        }
    }
    
    // Ensures the table view cell layout margins are correct when rotating orientations
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
        control.fillSuperview()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCellID", for: indexPath)
        
        guard let resultCell = cell as? MediaTableViewCell else { return cell }
        
        let result = fetchResults[indexPath.row]
        resultCell.result = result
        
        return resultCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedResult = fetchResults[indexPath.row]
        
        let mediaDetailVC = MediaDetailViewController()
        mediaDetailVC.hero.isEnabled = true
        mediaDetailVC.result = tappedResult
        mediaDetailVC.savedImage = tappedResult.image
        
//        hero.replaceViewController(with: mediaDetailVC)
        self.navigationController?.pushViewController(mediaDetailVC, animated: true)
    }

   
}
