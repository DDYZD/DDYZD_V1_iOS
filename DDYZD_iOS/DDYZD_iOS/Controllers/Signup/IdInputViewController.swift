//
//  IdInputViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/09.
//

import UIKit
import Alamofire

class IdInputViewController: UIViewController, UITextFieldDelegate {
    
    public var code : String = ""

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet weak var moveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdTextField.layer.borderWidth = 1.0
        IdTextField.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        IdTextField.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.progressView.setProgress(0.4, animated: true)
        }
        
        addKeyboardNotification()
        
    }
    @IBAction func NextBtn(_ sender: Any) {
        if IdTextField.text == ""{
            alert("아이디를 확인해주세요!")
        }
        else {
            
            let parameters: [String: String] = [
                "id": IdTextField.text!
            ]
            
            let alamo = AF.request(baseURL+"/checkID", method: .post, parameters:parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
            
            alamo.responseJSON(){ response in
                switch response.result
                {
                    case .success(let value):
                        let valueNew = value as? [String:Any]
                        print(valueNew?["message"]as! String)
                        
                        guard let vc = self.storyboard?.instantiateViewController(identifier: "SignupVC3") as? PwdInputViewController else {
                            return
                        }
                        vc.code = self.code
                        vc.id = self.IdTextField.text!
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        
                    case .failure( _):
                        self.alert("이미 있는 아이디입니다.")
                }
            }
        }
    }
    @IBAction func BackBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
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

