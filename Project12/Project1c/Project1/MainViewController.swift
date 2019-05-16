//
//  MainViewController.swift
//  Project1
//
//  Created by Rahul on 5/9/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var pictures: [String] = []
    var viewsCount: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        if let viewsCount = UserDefaults.standard.object(forKey: "viewsCount") as? [Int] {
            self.viewsCount = viewsCount
        } else {
            self.viewsCount = Array(repeating: 0, count: pictures.count)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture")!
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "\(viewsCount[indexPath.row]) views"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewsCount[indexPath.row] += 1
        saveViewsCount()
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.selectedImageIndex = indexPath.row + 1
        detailViewController.totalImagesCount = pictures.count
        detailViewController.selectedImage = pictures[indexPath.row]

        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func saveViewsCount() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(viewsCount, forKey: "viewsCount")
    }


}

