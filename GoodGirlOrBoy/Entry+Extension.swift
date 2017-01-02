//
//  Entry+Extension.swift
//  GoodGirlOrBoy
//
//  Created by Madushani Lekam Wasam Liyanage on 12/28/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation

extension Entry {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        date = NSDate()
    }
    
    var formattedDateAndTime: String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let string = formatter.string(from: date! as Date)
        
        return string
    }
   
}
