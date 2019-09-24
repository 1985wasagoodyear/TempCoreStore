//
//  HoomanDetailViewController.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

class HoomanDetailViewController: UIViewController {
    
    @IBOutlet var nameStaticLabel: UILabel!
    @IBOutlet var nameEntryTextField: UITextField!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    var controller: HoomanController!
    
    @IBAction func saveBarButtonAction(_ sender: UIBarButtonItem) {
        if let name = nameEntryTextField.text, name.isEmpty == false {
            controller.addHooman(name)
            showAlertAndDismiss(text: "Created Hooman \"\(name)\"")
        }
    }
    
    func showAlertAndDismiss(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

 }
    
