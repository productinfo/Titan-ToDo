//
//  JSON.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/19/17.
//
//

import Foundation

func makeJSONString(_ dict: Any) -> String? {
    
    var json: String? = nil
    
    do {
        let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        if let str = String(data: data, encoding: .utf8) {
            json = str
        }
    } catch {
        json = nil
    }
    
    return json
}
