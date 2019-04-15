//
//  CustomPicker.swift
//  NoteBook
//
//  Created by jhb15 on 15/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class CustomPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var data = [[GuardianContentDateFilter]]()
    
    func setData(dataArrays: [GuardianContentDateFilter]...) {
        for array in dataArrays {
            data.append(array)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row].rawValue
    }
}
