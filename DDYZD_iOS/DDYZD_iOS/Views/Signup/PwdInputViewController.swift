//
//  PsdInputViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/09.
//

import UIKit

class PwdInputViewController: UIViewController, UITextFieldDelegate {

    public var code : String = ""
    public var id : String = ""

    
    @IBOutlet weak var ProgressView: UIProgressView!
    @IBOutlet weak var PwdTextField: UITextField!
    @IBOutlet weak var PwdCheckTextField: UITextField!
    @IBOutlet weak var moveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PwdTextField.layer.borderWidth = 1.0
        PwdTextField.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        PwdTextField.delegate = self
        PwdCheckTextField.layer.borderWidth = 1.0
        PwdCheckTextField.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        PwdCheckTextField.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.ProgressView.setProgress(0.6, animated: true)
        }
        
        addKeyboardNotification()
    }
    @IBAction func NextBtn(_ sender: Any) {
        if PwdTextField.text == ""{
            alert("비밀번호를 확인해주세요!")
        }
        else if PwdCheckTextField.text == ""{
            alert("비밀번호 확인을 확인해주세요!")
        }
        else if PwdTextField.text != PwdCheckTextField.text {
            alert("비밀번호와 비밀번호확인이 같지 않습니다!")
        }
        else{
            guard let vc = storyboard?.instantiateViewController(identifier: "SignupVC4") as? PhoneNumberInputViewController else {
                return
            }
            vc.code = code
            vc.id = id
            vc.pwd = PwdTextField.text!
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
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
