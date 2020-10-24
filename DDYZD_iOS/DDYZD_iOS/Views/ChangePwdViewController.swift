//
//  ChangePwdViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/23.
//

import UIKit
import Alamofire

class ChangePwdViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nowPwd: UITextField!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var newPwdCheck: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        nowPwd.layer.borderWidth = 1.0
        nowPwd.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        nowPwd.delegate = self
        newPwd.layer.borderWidth = 1.0
        newPwd.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        newPwd.delegate = self
        newPwdCheck.layer.borderWidth = 1.0
        newPwdCheck.layer.borderColor = #colorLiteral(red: 0.495298028, green: 0.5103443861, blue: 0.8756814003, alpha: 1)
        newPwdCheck.delegate = self
    }
    
    @IBAction func changeBtn(_ sender: Any) {
        if nowPwd.text == "" {
            alert("현제 비밀번호를 확인해주세요!")
        }
        else if newPwd.text == "" {
            alert("새 비밀번호를 확인해주세요!")
        }
        else if newPwdCheck.text == "" {
            alert("비밀번호 확인을 확인해주세요!")
        }
        else if newPwd.text != newPwdCheck.text {
            alert("새 비밀번호와 비밀번호확인이 같지 않습니다!")
        }
        else{
            let parameters: [String: String] = [
                "nowPassword": nowPwd.text!,
                "newPassword": newPwd.text!
            ]
                    
            let alamo = AF.request(baseURL+"/changePassword", method: .post, parameters:parameters, encoder: JSONParameterEncoder.default, headers: ["Authentication": "Bearer "+token]).validate(statusCode: 200..<300)
                    
            alamo.responseJSON(){ response in
                switch response.result
                {
                    //통신성공
                case .success( _):
                    let alert = UIAlertController(title: "비밀번호가 변경되었습니다!", message: nil, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(okButton)
                    self.present(alert,animated: true, completion: nil)
                        
                                
                            //통신실패
                case .failure( _):
                    self.alert("현제 비밀번호가 일치하지 않습니다.")
                }
            }
        }
        
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
    
    func setNavigationBar(){
        let imageView = UIImageView(image: UIImage(named: "icon"))
            imageView.contentMode = .scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)

            self.navigationItem.titleView = titleView
            self.navigationController?.navigationBar.tintColor = .lightGray
            self.navigationController?.navigationBar.topItem?.title = ""
    }
}
