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

class CircleInfoViewController: UIViewController, UICollisionBehaviorDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    public var circleId : Int? = nil
    public var circleName : String = ""
    public var circleLogoData : Data? = nil
    public var circleBackgroundData : Data? = nil
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var circleBackgroundImage: UIImageView!
    @IBOutlet weak var circleLogo: UIImageView!
    @IBOutlet weak var circleNameLable: UILabel!
    @IBOutlet weak var MdView: MarkdownView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var circleTagsCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setNavigationBar()
        circleLogo.layer.cornerRadius = circleLogo.frame.size.width/2.0
        spinner.startAnimating()
        spinner.layer.cornerRadius = 20
        
        MdView.isScrollEnabled = false
        circleNameLable.text = circleName
        circleLogo.image = UIImage(data: circleLogoData!)
        circleBackgroundImage.image = UIImage(data: circleBackgroundData!)
        
        circleTagsCollection.delegate = self
        circleTagsCollection.dataSource = self
    }
    
    var tags = [String]()
    
    func getData(){
        AF.request( baseURL+"/circles/info?"+now(), method: .get,parameters: [:] ,headers: ["circleId": String(circleId!)]).validate().responseJSON(completionHandler: { [self] res in
                    
                    switch res.result {
                        case .success(let value):
                            let valueNew = value as? [String:Any]
                            
                            self.setMdView(valueNew?["md"] as! String)
                            if valueNew?["recruitment"] as! Bool {
                                self.applyBtn.alpha = 1
                                self.applyBtn.isEnabled = true
                            }
                            tags = valueNew?["Tags"] as! [String]
                            circleTagsCollection.reloadData()
                            
                        case .failure(let err):
                            print("ERROR : \(err)")
                        }
                })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagCell
    
        switch tags[indexPath.row] {
        case "웹":
            cell.tagImageView.image = UIImage(named: "webTag")
        case "앱":
            cell.tagImageView.image = UIImage(named: "appTag")
        case "임베디드":
            cell.tagImageView.image = UIImage(named: "embeddedTag")
        case "게임":
            cell.tagImageView.image = UIImage(named: "gameTag")
        case "인공지능":
            cell.tagImageView.image = UIImage(named: "aiTag")
        case "정보보안":
            cell.tagImageView.image = UIImage(named: "securityTag")
        default:
            print("ERROR")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = 25 * (tags.count+1)
        let totalSpacingWidth = tags.count
        
        let leftInset = (239 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func setMdView(_ mdUrl : String){
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
        let url = URL(string: baseURL+mdUrl)!
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
          let str = String(data: data!, encoding: String.Encoding.utf8)
          DispatchQueue.main.async {
            self?.MdView.load(markdown: str)
            self?.spinner.stopAnimating()
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

class tagCell: UICollectionViewCell {
    @IBOutlet weak var tagImageView: UIImageView!
}
