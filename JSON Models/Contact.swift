//
//  Contacts.swift
//  AC-iOS-U3W1HW-Parsing
//
//  Created by C4Q on 11/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct ResultsWrapper: Codable {
    let results: [Contact]
    
}

struct Contact: Codable {
    
    let name: Name
    let location: Location
    let email: String
    let phone: String
    let cell: String
    let picture: Picture
}

struct Name: Codable {
    let first: String
    let last: String
}

struct Location: Codable {
    let street: String
    let city: String
    let state: String
    let postcode: String
}

class Picture: Codable {
    let large: String
    let thumbnail: String
    
    private(set) var largeImage: UIImage? = nil
    private(set) var thumbnailImage: UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case large    
        case thumbnail
    }

    func getThumbnail(onComplete: @escaping() -> Void) {
        guard let url = URL(string: thumbnail) else { return }
        UIImage.fetchAsync(url: url) { (image: UIImage) in
            self.thumbnailImage = image
            onComplete()
        }
    }

    private func getLarge() {
        guard let url = URL(string: large) else { return }
        UIImage.fetchAsync(url: url) { (image) in
            self.largeImage = image
        }
    }
}

extension UIImage {
    class func fetchAsync(url: URL, onComplete: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            guard let data = try? Data.init(contentsOf: url) else { return }
            if let image = UIImage(data: data) {
                onComplete(image)
            }
        }
    }
}

class JSONHandler {
    
  static func getContacts() -> [Contact] {
        var contacts = [Contact]()
        if let path = Bundle.main.path(forResource: "userinfo", ofType: "json") {
            let myURL = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: myURL) {
                do {
                    let resultsWrapper = try JSONDecoder().decode(ResultsWrapper.self, from: data)
                    contacts = resultsWrapper.results.sorted { $0.name.first < $1.name.first }
                }
                catch {
                    print(error)
                }
            }
        }
       return contacts
    }
    
}

//
//
//enum Gender {
//    case male
//    case female
//}
//
//class Contact {
//    let gender: Gender
//    let name: Name
//    let location: Location
//    let email: String
//    let phone: String
//    let cell: String
//    let picture: Picture
//
//    init(gender: Gender, name: Name, location: Location, email: String, phone: String, cell: String, picture: Picture) {
//        self.gender = gender
//        self.name = name
//        self.location = location
//        self.email = email
//        self.phone = phone
//        self.cell = cell
//        self.picture = picture
//    }
//
//    convenience init(jsonDict: [String : Any]) {
//        var enumGender: Gender = .male
//
//        //
//
//
//        guard let nameDict = jsonDict["name"] as? [String: String] else { return }
//
//        guard let gender = jsonDict["gender"] as? String else { return }
//
//        if gender == "female" {
//            enumGender = .female
//        }
//
////        let createdName = Name(jsonNameDict: nameDict)
////        let jem = Name(title: "Jer", first: "jsjs", last: "jhh")
//
//        self.init(gender: enumGender, name: createdName, location: <#T##Location#>, email: <#T##String#>, phone: <#T##String#>, cell: <#T##String#>, picture: <#T##Picture#>)
//    }
//
//}
//
//struct Name {
//    let title: String
//    let first: String
//    let last: String
//
//    init(title: String, first: String, last: String) {
//        self.first = first
//        self.title = title
//        self.last = last
//    }
//
//    init (jsonNameDict: [String: String]) {
//        guard let first = jsonNameDict["first"],
//            let last = jsonNameDict["last"],
//            let title = jsonNameDict["title"] else { return }
//
//        self.first = first
//        self.last = last
//        self.title = title
//    }
//}
//
//struct Location {
//    let street: String
//    let city: String
//    let state: String
//    let postcode: String
//}
//
//struct Picture {
//    let large: String
//    let thumbnail: String
//}
//
//
//
//
//
//
