//
//  SearchViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 15/08/21.
//

import UIKit

class SearchViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldEdit()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type City"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            print(city)
        }
        
        searchTextField.text = ""
    }
    
    func textFieldEdit() {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
