//
//  ImageObject.swift
//  PhotoJounalHelperProject
//
//  Created by Tiffany Obi on 1/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct ImageObject: Equatable & Codable {
    
    let description: String
    let imageData: Data
    let date: Date
    let identifier = UUID().uuidString

}
