//
//  Person.swift
//  Project10
//
//  Created by Rahul Sharma on 5/14/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {
    
    var name: String
    var imageName: String

    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        imageName = aDecoder.decodeObject(forKey: "imageName") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageName, forKey: "imageName")
    }
    
}
