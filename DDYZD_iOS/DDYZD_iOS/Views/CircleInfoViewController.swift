//
//  CircleInfoViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/09.
//

import UIKit
import Alamofire
import MarkdownView
import SafariServices

class CircleInfoViewController: UIViewController{

    public var circleName : String = ""
    public var circleLogoData : Data? = nil
    
    @IBOutlet weak var circleBackgroundImage: UIImageView!
    @IBOutlet weak var circleLogo: UIImageView!
    @IBOutlet weak var circleNameLable: UILabel!
    @IBOutlet weak var MdView: MarkdownView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        circleLogo.layer.cornerRadius = circleLogo.frame.size.width/2.0
        
        MdView.isScrollEnabled = false
        setMdView()
        circleNameLable.text = circleName
        circleLogo.image = UIImage(data: circleLogoData!)
        getData()
    }
    
    func getData(){
        AF.request( baseURL+"/circles/info?"+now(), method: .get,parameters: [:] ,headers: ["circleName": circleName]).validate().responseJSON(completionHandler: { res in
                    
                    switch res.result {
                        case .success(let value):
                            print(value)
                            let valueNew = value as? [String:Any]
                            
                            
                        case .failure(let err):
                            print("ERROR : \(err)")
                        }
                })
    }
    
    func setMdView(){
        MdView.onTouchLink = { [weak self] request in
          guard let url = request.url else { return false }

          if url.scheme == "file" {
            return true
          } else if url.scheme == "https" {
            let safari = SFSafariViewController(url: url)
            self?.present(safari, animated: true, completion: nil)
            return false
          } else {
            return false
          }
        }

        let session = URLSession(configuration: .default)
        let url = URL(string: baseURL+"/md/blueberry.md")!
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
          let str = String(data: data!, encoding: String.Encoding.utf8)
          DispatchQueue.main.async {
            self?.MdView.load(markdown: str)
          }
        }
        task.resume()
    }
    
    
    @IBAction func goMenu(_ sender: Any) {
        performSegue(withIdentifier: "goMenuVC", sender: nil)
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

}
