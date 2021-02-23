//
//  AddRecordatorioViewController.swift
//  Recordatorios
//
//  Created by marco rodriguez on 23/02/21.
//

import UIKit

class AddRecordatorioViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //implementar la notificacion
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(guardarButton))
        
        
    }
    
     @objc func guardarButton() {
        if let tittleText = titleField.text, !tittleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty {
            let targetDate = datePicker.date
            
            completion?(tittleText, bodyText, targetDate)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
