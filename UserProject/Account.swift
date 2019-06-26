//
//  Account.swift
//  UserProject
//
//  Created by Igor Baric on 4/24/19.
//  Copyright © 2019 ItFusion. All rights reserved.
//

import Foundation


class Account : NSObject {
    var user: User?
    var galleryItem: [GaleryItem]?
    
    init(_ user: User?, _ galleryItem: [GaleryItem]?) {
        super.init()
        self.user = user
        self.galleryItem = galleryItem
    }
}
