//
//  JSON.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/19/17.
//
//

import Foundation
import Titan

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

func jsonDataResopnse(withRequest req: RequestType, jsonData: Any) -> (RequestType, ResponseType)? {
    if let response = makeJSONString(jsonData) {
        return (req, Response(200, response, [Header(name: "Content-Type", value: "application/json")]))
    }
    
    return nil
}
