//
//  Model.swift
//  ApiPullApp
//
//  Created by Akdag on 20.02.2021.
//

import Foundation
struct Petition : Codable {
    var title :String
    var body : String
    var signatureCount : Int
}
