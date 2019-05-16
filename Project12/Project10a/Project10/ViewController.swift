//
//  ViewController.swift
//  Project10
//
//  Created by Rahul Sharma on 5/14/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

struct Keys {
    static var userDefaults = "persons"
}

class ViewController: UICollectionViewController {
    
    var persons: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Names to Faces"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        
        if let savedData = UserDefaults.standard.object(forKey: Keys.userDefaults) as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
                persons = decodedPeople
                collectionView.reloadData()
            }
        }
        
    }
    
    @objc func didTapAddButton() {
        
        let actionSheet = UIAlertController(title: "Add", message: "Choose a source for the image.", preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(source: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            self?.presentImagePicker(source: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCollectionViewCell else {
            fatalError("Unable to load PersonCell.")
        }
        let person = persons[indexPath.row]
        
        cell.nameLabel.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.imageName)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let person = persons[indexPath.row]
        
        let actionSheet = UIAlertController(title: "Modify", message: "Would you like to rename the person or remove it?", preferredStyle: .actionSheet)
        
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            
            let alert = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            alert.addTextField()
            
            let action1 = UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
                guard let newName = alert?.textFields?[0].text else { return }
                person.name = newName
                
                self?.save()
                self?.collectionView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(action1)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true)
            
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.persons.remove(at: indexPath.row)
            self?.save()
            self?.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(renameAction)
        actionSheet.addAction(removeAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
        
        
    }
    
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: persons, requiringSecureCoding: false) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: Keys.userDefaults)
        }
        
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try! jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", imageName: imageName)
        persons.append(person)
        
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
}
