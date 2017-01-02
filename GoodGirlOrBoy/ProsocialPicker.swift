//
//  ProsocialPicker.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 12/31/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit

class ProsocialPicker: UIPickerView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ProsocialBehavior.proArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ProsocialBehavior.proArr[row]
    }

}
