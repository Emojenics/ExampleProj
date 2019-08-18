//
//  File.swift
//  ExampleProject
//
//  Created by Abdur Rahim on 7/28/19.
//  Copyright © 2019 Abdur Rahim. All rights reserved.
//

import Foundation
class CallBack
{
    
//    Important to understand:
//    (String)->() // takes a String returns void
//    ()->(String) // takes void returns a String
    func getBoolValue(number : Int, completion: (_ result: Bool)->()) {
        
        if number > 5 {
            completion(true)
        } else {
            completion(false)
        }
    }
    
}
