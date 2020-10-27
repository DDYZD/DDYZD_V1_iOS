//
//  MainViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/07.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewingCircles = [circle]()
    var circlesArrAll = [circle]()
    var circlesArrWeb = [circle]()
    var circlesArrApp = [circle]()
    var circlesArrEmbedded = [circle]()
    var circlesArrEtc = [circle]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getAdData()
        
        setNavigationBarLogo()
        
        spinner.layer.cornerRadius = 20
        spinner.startAnimating()
        
        getCirclesData("")
        getCirclesData("/web")
        getCirclesData("/app")
        getCirclesData("/embedded")
        getCirclesData("/etc")
    }

    func getAdData(){
        
        Ads.removeAll()
        
        AF.request( baseURL+"/ad?"+now(), method: .get,parameters: [:] ,headers: [:]).validate().responseJSON(completionHandler: { res in
                    
                    switch res.result {
                        case .success(let value):
                            if let data = value as? [[String:Any]]{
                                DispatchQueue.global().async {
                                    for dataIndex in data {
                                        Ads.append(ad(circleId: dataIndex["circleId"] as! Int,
                                                      adImage: try! Data(contentsOf: URL(string: baseURL + (dataIndex["adImage"] as! String))!)))
                                    }
                                    DispatchQueue.main.async {
                                        self.collectionView.delegate = self
                                        self.collectionView.dataSource = self
                                    }
                                }
                            }
                            
                        case .failure(let err):
                            print("ERROR : \(err)")
                        }
                })
    }
    
    func getCirclesData(_ kind : String){
        AF.request( baseURL+"/circles"+kind+"?"+now(), method: .get,parameters: [:]).validate().responseJSON(completionHandler: { res in
                    
                    switch res.result {
                        case .success(let value):
                            
                            if let data = value as? [[String:Any]]{
                                
                                switch kind {
                                case "/web":
                                    for dataIndex in data {
                                        DispatchQueue.global().async {
                                            self.circlesArrWeb.append(circle(name: dataIndex["name"] as! String,
                                                                          Tags: dataIndex["Tags"] as! [String],
                                                                          logo: try! Data(contentsOf: URL(string: baseURL + (dataIndex["logo"] as! String))!),
                                                                          background: try! Data(contentsOf: URL(string: baseURL + (dataIndex["background"] as! String))!),
                                                                          id: dataIndex["id"] as! Int
                                                                          )
                                            )
                                        }
                                        
                                    }
                                case "/app":
                                    for dataIndex in data {
                                        DispatchQueue.global().async {
                                            self.circlesArrApp.append(circle(name: dataIndex["name"] as! String,
                                                                          Tags: dataIndex["Tags"] as! [String],
                                                                          logo: try! Data(contentsOf: URL(string: baseURL + (dataIndex["logo"] as! String))!),
                                                                          background: try! Data(contentsOf: URL(string: baseURL + (dataIndex["background"] as! String))!),
                                                                          id: dataIndex["id"] as! Int
                                                                          )
                                            )
                                        }
                                        
                                    }
                                case "/embedded":
                                    for dataIndex in data {
                                        DispatchQueue.global().async {
                                            self.circlesArrEmbedded.append(circle(name: dataIndex["name"] as! String,
                                                                          Tags: dataIndex["Tags"] as! [String],
                                                                          logo: try! Data(contentsOf: URL(string: baseURL + (dataIndex["logo"] as! String))!),
                                                                          background: try! Data(contentsOf: URL(string: baseURL + (dataIndex["background"] as! String))!),
                                                                          id: dataIndex["id"] as! Int
                                                                          )
                                            )
                                        }
                                        
                                    }
                                case "/etc":
                                    for dataIndex in data {
                                        DispatchQueue.global().async {
                                            self.circlesArrEtc.append(circle(name: dataIndex["name"] as! String,
                                                                          Tags: dataIndex["Tags"] as! [String],
                                                                          logo: try! Data(contentsOf: URL(string: baseURL + (dataIndex["logo"] as! String))!),
                                                                          background: try! Data(contentsOf: URL(string: baseURL + (dataIndex["background"] as! String))!),
                                                                          id: dataIndex["id"] as! Int
                                                                          )
                                            )
                                        }
                                        
                                    }
                                default:
                                    DispatchQueue.global().async {
                                        for dataIndex in data{
                                            self.circlesArrAll.append(circle(name: dataIndex["name"] as! String,
                                                                             Tags: dataIndex["Tags"] as! [String],
                                                                             logo: try! Data(contentsOf: URL(string: baseURL + (dataIndex["logo"] as! String))!),
                                                                             background: try! Data(contentsOf: URL(string: baseURL + (dataIndex["background"] as! String))!),
                                                                             id: dataIndex["id"] as! Int
                                                                        )
                                            )
                                        }
                                        DispatchQueue.main.async {
                                            self.viewingCircles = self.circlesArrAll
                                            self.collectionView.reloadData()
                                            self.spinner.stopAnimating()
                                        }
                                    }
                                }
                            }
                        case .failure(let err):
                            print("ERROR : \(err)")
                        }
                })
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            viewingCircles = circlesArrAll
            collectionView.reloadData()
        case 1:
            viewingCircles = circlesArrWeb
            collectionView.reloadData()
        case 2:
            viewingCircles = circlesArrApp
            collectionView.reloadData()
        case 3:
            viewingCircles = circlesArrEmbedded
            collectionView.reloadData()
        case 4:
            viewingCircles = circlesArrEtc
            collectionView.reloadData()
        default:
            print("ERROR")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewingCircles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "circleCell", for: indexPath) as! circleCell
    
        cell.circleLogo.image = UIImage(data: viewingCircles[indexPath.row].logo)
        cell.circleName.text = viewingCircles[indexPath.row].name
        
        return cell
    }
    
    
    var start : Bool = false
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableView", for: indexPath) as? reusableView
            headerView?.adPageView.numberOfPages = Ads.count
            headerView?.adImageView.image = UIImage(data: Ads[headerView!.adPageView.currentPage].adImage)
            
            if !start {
                start = true
                DispatchQueue.global().async {
                    while true{
                        
                        var i : Int = 0
                        
                        while i < Ads.count {
                            DispatchQueue.main.async {
                                headerView!.adImageView.image = UIImage(data: Ads[i].adImage)
                                headerView!.adPageView.currentPage = i
                                i = (headerView?.adPageView.currentPage)!
                                i += 1
                            }
                            sleep(10)
                        }
                        
                    }
                }
            }
            
            return headerView!
        default:
            assert(false, "ERROR")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        performSegue(withIdentifier: "goCircleInfoVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCircleInfoVC" {
            if let destinationVC = segue.destination as? CircleInfoViewController,
               let indexpathRow = sender as? Int{
                destinationVC.circleId = viewingCircles[indexpathRow].id
                destinationVC.circleName = viewingCircles[indexpathRow].name
                destinationVC.circleLogoData = viewingCircles[indexpathRow].logo
                destinationVC.circleBackgroundData = viewingCircles[indexpathRow].background
            }
        }
    }
    
    @IBAction func goMenu(_ sender: Any) {
        performSegue(withIdentifier: "goMenuVC", sender: nil)
    }
    
    
    func setNavigationBarLogo(){
        let imageView = UIImageView(image: UIImage(named: "icon"))
            imageView.contentMode = .scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)

            self.navigationItem.titleView = titleView
    }
    

    
    // 여백
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets{
        let inset = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
        return inset
    }
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellWithd = collectionView.frame.width / 3 - 30
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
    }

    //위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func now() -> String{
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "ss"
        let current_time_string = formatter_time.string(from: Date())
        return current_time_string
    }

}

struct ad {
    let circleId : Int
    let adImage : Data
}

struct circle {
    let name : String
    let Tags : [String]
    let logo : Data
    let background : Data
    let id : Int
}

var Ads  = [ad]()
class reusableView : UICollectionReusableView {
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adPageView: UIPageControl!
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        self.adImageView.image = UIImage(data: Ads[adPageView.currentPage].adImage)
        }
}

class circleCell : UICollectionViewCell {
    @IBOutlet weak var circleLogo: UIImageView!
    @IBOutlet weak var circleName: UILabel!
}
