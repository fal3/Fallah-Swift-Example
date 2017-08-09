//
//  UIViewController+extensions.swift
//  FallahLevelUp
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Wentworth. All rights reserved.
//
import UIKit

extension UIViewController {
    // MARK: - Show Alert
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, msg: String, completion:@escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction) in
            completion()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
