//
//  ToDo.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/17/17.
//
//

import Rope

struct ToDoManager {
    
    func add(json: String) -> Bool {
        
        var result = true
        
        do {
            try PSQL().query("INSERT INTO items (data) VALUES ($1)", params: [json])
        } catch {
            result = false
        }
        
        return result
    }
    
    func delete() -> Bool {
        
        var result = true
        
        do  {
            try PSQL().query("DELETE FROM items", params: [])
        } catch {
            result = false
        }
        
        return result
    }
    
    
    
}
