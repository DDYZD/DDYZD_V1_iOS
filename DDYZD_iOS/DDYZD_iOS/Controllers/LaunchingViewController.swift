//
//  LaunchingViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/11.
//

import UIKit
import Alamofire

class LaunchingViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
            sleep(1)
            if let id = UserDefaults.standard.string(forKey: "id"){
                if let pwd = UserDefaults.standard.string(forKey: "pwd"){
                    let parameters: [String: String] = [
                        "id": id,
                        "password": pwd
                    ]
                        
                    let alamo = AF.request(baseURL+"/login", method: .post, parameters:parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
                        
                    alamo.responseJSON(){ response in
                        switch response.result
                            {
                            //통신성공
                            case .success(let value):
                                let valueNew = value as? [String:Any]
                                token = valueNew?["authorization"] as! String
                                self.goMain()
                            //통신실패
                            case .failure( _):
                                self.goLogin()
                            }
                    }
                }else{
                    goLogin()
                }
            }else{
                goLogin()
            }
    }
        
            
        func goLogin() {
            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
            vcName?.modalTransitionStyle = .coverVertical
            vcName?.modalPresentationStyle = .fullScreen
            self.present(vcName!, animated: true, completion: nil)
        }
        
        func goMain() {
            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "mainNC")
            vcName?.modalTransitionStyle = .coverVertical
            vcName?.modalPresentationStyle = .fullScreen
            self.present(vcName!, animated: true, completion: nil)
        }

}
