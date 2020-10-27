//
//  PhoneNumberInputViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/09.
//

import UIKit
import Alamofire

class PhoneNumberInputViewController: UIViewController, UITextFieldDelegate {

    public var code : String = ""
    public var id : String = ""
    public var pwd : String = ""

    
    @IBOutlet weak var ProgressView: UIProgressView!
    @IBOutlet weak var PhoneNumberTextField: UITextField!
    @IBOutlet weak var moveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(code)
        print(id)
        print(pwd)
        
        PhoneNumberTextField.layer.borderWidth = 1.0
        PhoneNumberTextField.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        PhoneNumberTextField.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.ProgressView.setProgress(0.8, animated: true)
        }
        
        addKeyboardNotification()
    }
    @IBAction func NextBtn(_ sender: Any) {
        if PhoneNumberTextField.text == ""{
            alert("전화번호를 확인해주세요!")
        }
        else {
            
            let parameters: [String: String] = [
                "code": code,
                "id": id,
                "password": pwd,
                "phoneNumber": PhoneNumberTextField.text!
            ]
            
            let alamo = AF.request(baseURL+"/signup", method: .post, parameters:parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
            
            alamo.responseJSON(){ response in
                switch response.result
                {
                    case .success(let value):
                        let valueNew = value as? [String:Any]
                        print(valueNew?["message"]as! String)
                        
                        
                        guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "EndofSignupVC") else {
                            return
                        }
                        vcName.modalTransitionStyle = .crossDissolve
                        vcName.modalPresentationStyle = .fullScreen
                        self.present(vcName, animated: true, completion: nil)
                        
                    case .failure( _):
                        self.alert("ERROR")
                }
            }
        }
    }
    @IBAction func BackBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
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
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        moveView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
      }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
        moveView.transform = .identity
    }
    
    func alert(_ phrases : String) {
        let alert = UIAlertController(title: phrases, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }
}
