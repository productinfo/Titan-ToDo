//
//  config.swift
//  ToDo-Titan
//
//  Created by Ryan Collins on 7/18/17.
//
//

import Foundation

struct Config {
    
    var endpoint: String {
        get {
            return "rycol.csrbcgnf18wi.us-east-1.rds.amazonaws.com"
        }
    }
    
    var database: String {
        get {
            return "titan"
        }
    }
    
    var username: String {
        get {
            return "demo"
        }
    }
    
    var password: String {
        get {
            return "titantest"
        }
    }
    
    var port: Int {
        get {
            return 5432
        }
    }
    
    var hostname: String {
        get {
            return "http://34.229.61.202"
        }
    }
}
