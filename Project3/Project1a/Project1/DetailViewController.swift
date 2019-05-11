//
//  DetailViewController.swift
//  Project1
//
//  Created by Rahul on 5/9/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImageIndex: Int = 0
    var totalImagesCount: Int = 0
    
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        
        title = "Image \(selectedImageIndex) of \(totalImagesCount)"
        navigationItem.largeTitleDisplayMode = .never
        
        if let selectedImage = selectedImage {
            imageView.image = UIImage(named: selectedImage)
        }
        
    }
    
    @objc func didTapShareButton() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        guard let selectedImage = selectedImage else { return }
        
        let viewController = UIActivityViewController(activityItems: [image, selectedImage], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
}
