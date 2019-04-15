//
//  CountPickerView.swift
//  NoteBook
//
//  Created by jhb15 on 15/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

/**
 Class for building a picker view that allows the user select a number from a range, although may not be needed.
 */
class CountPickerView: UIPickerView/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {
    
    var count: Int = 10

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /*func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        <#code#>
    }*/
}
