//
//  Students.swift
//  CloudKitApplication
//
//  Created by Michael Maczynski on 10/9/16.
//  Copyright © 2016 Michael Maczynski. All rights reserved.
//


import Foundation

class Students
    
{
    var name: String
    var school: String
    var image: String
    
    
    init(Name n:String,School s:String,image i: String)
    {
        name = n
        school = s
        image = i
        
    }
    
    init()
    {
        name = ""
        school = ""
        image = ""
    }
}
