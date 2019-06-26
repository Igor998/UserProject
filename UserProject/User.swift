//
//  User.swift
//  UserProject
//
//  Created by Igor Baric on 4/17/19.
//  Copyright © 2019 ItFusion. All rights reserved.
//

import Foundation


class User : NSObject, NSCoding {
    var firstName: String?
    var lastName: String?
    var email: String?
    var adress: String?
    var age: String?
    var profileImage: String?
    
    
    
    
    init(firstName: String?, lastName: String?, email: String?, adress: String?, age: String?) {
        
        super.init()
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.adress = adress
        self.age = age
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let adress = aDecoder.decodeObject(forKey: "adress") as? String
        let age = aDecoder.decodeObject(forKey: "age") as? String
        self.init(firstName: firstName, lastName: lastName, email: email, adress: adress, age: age)
            

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(adress, forKey: "adress")
        aCoder.encode(age, forKey: "age")
        
    }
    
    func fullName() -> String? {
        if let firstName = firstName, let lastName = lastName {
            return firstName + " " + lastName
        } else {
            if let firstName = firstName {
                return firstName
            }
            if let lastName = lastName {
                return lastName
            }
        }
        return nil
    }
}
