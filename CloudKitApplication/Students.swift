//
//  Students.swift
//  CloudKitApplication
//
//  Created by Michael Maczynski on 10/9/16.
//  Copyright © 2016 Michael Maczynski. All rights reserved.
//


import Foundation
import UIKit

class Students
    
{
    var name: String
    var school: String
    var image: UIImage
    
    
    init(Name n:String,School s:String,image i: UIImage)
    {
        name = n
        school = s
        image = i
        
    }
    
    init()
    {
        name = ""
        school = ""
        image = UIImage()
    }
}
