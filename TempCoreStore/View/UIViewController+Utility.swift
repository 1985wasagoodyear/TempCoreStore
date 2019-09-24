//
//  UIViewController+Utility.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

func fatalErrorWrongIndexPath() -> Never {
    fatalError("Invalid access: wrong IndexPath")
}

extension UIViewController {

    func showAlert(text: String, _ okAction: (()->Void)?) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            okAction?()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
