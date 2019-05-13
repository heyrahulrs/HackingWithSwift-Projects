//
//  ViewController.swift
//  Project7
//
//  Created by Rahul on 5/12/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
    var filteredPetitions: [Petition] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action:  #selector(didTapCreditsButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilterButton))
        
        performSelector(inBackground: #selector(fetchData), with: nil)
        
        if navigationController?.tabBarItem.tag == 0 {
            title = "Recent"
        } else {
            title = "Top Rated"
        }
        
    }
    
    @objc func fetchData() {
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
    }
    
    func parse(json: Data) {
        let jsonDecoder = JSONDecoder()
        
        if let jsonPetitions = try? jsonDecoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        showAlert(title: "Error", message: "There was a problem loading the feed; please check your connection and try again.")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func filterPetitions(withText text: String) {
        let lowercasedText = text.lowercased()
        
        filteredPetitions = petitions.filter {
            $0.title.lowercased().contains(lowercasedText) || $0.body.lowercased().contains(lowercasedText)
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func didTapCreditsButton() {
        showAlert(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.")
    }
    
    @objc func didTapFilterButton() {
        filteredPetitions.removeAll()
        
        let alert = UIAlertController(title: "Filter Petitions", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        let action1 = UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
            guard let text = alert?.textFields?[0].text, !text.isEmpty else { return }
            
            DispatchQueue.global().async { [weak self] in
                self?.filterPetitions(withText: text)
            }
            
        }
        
        let action2 = UIAlertAction(title: "Clear Filter", style: .destructive) { [weak self] _ in
            guard let petitions = self?.petitions else { return }
            self?.filteredPetitions = petitions
            self?.tableView.reloadData()
        }
        
        alert.addAction(action1)
        alert.addAction(action2)

        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        viewController.selectedPetition = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

}

