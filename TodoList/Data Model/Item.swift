//
//  Item.swift
//  TodoList
//
//  Created by Demo on 1.08.2018.
//  Copyright © 2018 RN. All rights reserved.
//

import Foundation

// Item class ını Encodable ve Decodable ediyoruz.(bkz. Conform, Interface) Hem Encodable hem de Decodable ın ikisini Codable komutuyla sağlayabiliyoruz. 
class Item: Codable{
    
    
    var title : String = ""
    
    // Item check edildi mi edilmedi mi kontrolü için
    var done : Bool = false

    
}

