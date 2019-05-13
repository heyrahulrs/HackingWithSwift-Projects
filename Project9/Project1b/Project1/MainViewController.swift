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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(loadImages), with: nil)
    }
    
    @objc func loadImages() {
        
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture")!
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.selectedImageIndex = indexPath.row + 1
        detailViewController.totalImagesCount = pictures.count
        detailViewController.selectedImage = pictures[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }


}

