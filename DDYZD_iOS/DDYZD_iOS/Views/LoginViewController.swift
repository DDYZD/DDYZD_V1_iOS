//
//  LoginViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/08.
//

import UIKit
import Alamofire

let baseURL = "http://10.156.147.146"
var token : String = ""

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet weak var PwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdTextField.layer.borderWidth = 1.0
        IdTextField.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        IdTextField.delegate = self
        PwdTextField.layer.borderWidth = 1.0
        PwdTextField.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        PwdTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if IdTextField.text == ""{
            alert("아이디를 확인해주세요!")
        }
        else if PwdTextField.text == ""{
            alert("비밀번호를 확인해주세요!")
        }
        else{
            let parameters: [String: String] = [
                "id": IdTextField.text!,
                "password": PwdTextField.text!
            ]
                    
                    let alamo = AF.request(baseURL+"/login", method: .post, parameters:parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
                    
                    alamo.responseJSON(){ response in
                        switch response.result
                        {
                            //통신성공
                            case .success(let value):
                                
                                let valueNew = value as? [String:Any]
                                print(valueNew?["admin"] as? String)
                                if (valueNew?["admin"] as? String) == nil{
                                    token = valueNew?["authorization"] as! String
                                    
                                    UserDefaults.standard.set(self.IdTextField.text, forKey: "id")
                                    UserDefaults.standard.set(self.PwdTextField.text, forKey: "pwd")
                                    
                                    guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "mainNC") else {
                                        return
                                    }
                                    vcName.modalTransitionStyle = .coverVertical
                                    vcName.modalPresentationStyle = .fullScreen
                                    self.present(vcName, animated: true, completion: nil)
                                    
                                    
                                }
                                else{
                                    self.alert("관리자계정은 웹에서만 가능합니다.")
                                }
                                
                            //통신실패
                            case .failure( _):
                                self.alert("정보가 일치하지 않습니다.")
                        }
                    }
                }
    }
    
    @IBAction func goSignup(_ sender: Any) {
        guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC1") else {
            return
        }
        vcName.modalTransitionStyle = .coverVertical
        vcName.modalPresentationStyle = .fullScreen
        self.present(vcName, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func alert(_ phrases : String) {
        let alert = UIAlertController(title: phrases, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }

}
