//
//  HoomanDetailViewController.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

class HoomanDetailViewController: UIViewController {
    
    // MARK: - Storyboard Outlets
    
    @IBOutlet var nameStaticLabel: UILabel!
    @IBOutlet var nameEntryTextField: UITextField!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    
    var controller: HoomanController!
    
    // MARK: - Custom Action Methods
    
    @IBAction func saveBarButtonAction(_ sender: UIBarButtonItem) {
        if let name = nameEntryTextField.text,
            name.isEmpty == false {
            controller.addHooman(name)
            showAlert(text: "Created Hooman \"\(name)\"") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
 }
    
