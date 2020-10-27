//
//  MenuViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/21.
//

import UIKit
import Alamofire

class MenuViewController: UIViewController{
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var classNoLable: UILabel!
    @IBOutlet weak var logoutBtnView: UIView!
    @IBOutlet weak var changePwdBtnView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getMyInfo()
        setNavigationBar()
        
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(logout))
        self.logoutBtnView.addGestureRecognizer(logoutGesture)
        let changePwdGesture = UITapGestureRecognizer(target: self, action: #selector(goChangePwdVC))
        self.changePwdBtnView.addGestureRecognizer(changePwdGesture)

    }
    
    func getMyInfo(){
        AF.request( baseURL+"/myInfo?"+now(), method: .get,parameters: [:] ,headers: ["Authentication": "Bearer "+token]).validate().responseJSON(completionHandler: { res in
                    
                    switch res.result {
                        case .success(let value):
                            let valueNew = value as? [String:Any]
                            self.nameLable.text = valueNew?["name"] as? String
                            self.classNoLable.text = valueNew?["classNo"] as? String
                            
                        case .failure(let err):
                            print("ERROR : \(err)")
                        }
                })
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
    
    func now() -> String{
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "ss"
        let current_time_string = formatter_time.string(from: Date())
        return current_time_string
    }
    
    @objc func logout(){
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)
                        let okButton = UIAlertAction(title: "로그아웃", style: .default, handler: { action in
                            UserDefaults.standard.removeObject(forKey: "id")
                            UserDefaults.standard.removeObject(forKey: "pw")
                            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "wattingVC")
                                    vcName?.modalTransitionStyle = .coverVertical
                                    vcName?.modalPresentationStyle = .fullScreen
                                    self.present(vcName!, animated: true, completion: nil)
                        })
                        alert.addAction(cancelButton)
                        alert.addAction(okButton)
                        self.present(alert,animated: true, completion: nil)
    }
    
    @objc func goChangePwdVC(){
        performSegue(withIdentifier: "goChangePwdVC", sender: nil)
    }
}
