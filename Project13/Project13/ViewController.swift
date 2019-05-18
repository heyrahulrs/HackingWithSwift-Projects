//
//  ViewController.swift
//  Project13
//
//  Created by Rahul Sharma on 5/18/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBOutlet weak var changeFilterButton: UIButton!

    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    @IBAction func didTapSaveButton() {
        guard let image = imageView.image else {
            showAlert(title: "Error!", message: "No image imported to apply filter. Import an image first!")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:)), nil)
    }

    @IBAction func didTapChangeFilterButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
        }
        present(alert, animated: true)
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProccessing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
    }

    @objc func didTapAddButton() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func setFilter(_ action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProccessing()
    }
    
    func applyProccessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2.0, y: currentImage.size.height / 2.0), forKey: kCIInputCenterKey)
        }
        
        guard let image = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            imageView.image = uiImage
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?) {
        if let error = error {
            showAlert(title: "Save error", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved!", message: "Your altered image has been saved to your photos.")
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProccessing()
    }
}

