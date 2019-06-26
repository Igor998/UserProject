//
//  GaleryItem.swift
//  UserProject
//
//  Created by Igor Baric on 4/24/19.
//  Copyright © 2019 ItFusion. All rights reserved.
//

import Foundation
import UIKit

class GaleryItem : NSObject {
    var image: UIImage?
    var dateAdded: Date?
    
    init(_ image: UIImage?, _ dateAdded: Date?) {
        super.init()
        self.image = image
        self.dateAdded = dateAdded
    }
}
