//
//  ViewController.swift
//  NewsApp
//
//  Created by Zeba on 9/13/19.
//  Copyright © 2019 Trivial Works. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {
    
    //mark: variable's
    var selected_tab = "0"
    var refreshControl = UIRefreshControl()
    var newsArticleArray = [BitcoinArticles]()
    var currentDate = ""
    var yesterday = ""

    //mark: ooutlet's
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tabCollectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        currentDate = formatter.string(from: date)
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        formatter.dateFormat = "yyyy-mm-dd"
        self.yesterday = formatter.string(from: yesterday)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        webServcieCall(selected_tab: selected_tab)
    }
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        self.refreshControl.endRefreshing()
        webServcieCall(selected_tab: selected_tab)
    }
    
    
    //mark: web servcie call---
    func webServcieCall(selected_tab: String){
        
        var url = ""
        let params = NSMutableDictionary()
        
        if selected_tab == "0"{
            
            url = "everything?q=bitcoin&from=\(currentDate)&sortBy=publishedAt&apiKey=0498b8b67f8b4dc69d8fb40fc0041df3"
        }else if selected_tab == "1"{
            
            url = "top-headlines?country=us&category=business&apiKey=0498b8b67f8b4dc69d8fb40fc0041df3"
        }else if selected_tab == "2"{
            
            url = "everything?q=apple&from=\(self.yesterday)&to=\(self.yesterday)&sortBy=popularity&apiKey=0498b8b67f8b4dc69d8fb40fc0041df3"
        }else if selected_tab == "3"{
            
            url = "top-headlines?sources=techcrunch&apiKey=0498b8b67f8b4dc69d8fb40fc0041df3"
        }else{
            
            url = "everything?domains=wsj.com&apiKey=0498b8b67f8b4dc69d8fb40fc0041df3"
        }
        
        NetworkRequest.sharedInstance.getDataFromWebAPIWithGet(showProgressHud: true, url, params, { (session, data) in
            
            SVProgressHUD.dismiss()
            
            if data is NSDictionary{
              
                print("------\(data)------")
                if let x = (data as! NSDictionary).object(forKey: "articles") as? NSArray, x.count > 0{
                    
                    self.newsArticleArray = x.map{
                        BitcoinArticles.init(JSON: $0 as! [String : Any])
                    }
                    
                    print(self.newsArticleArray)
                }
                
                self.tableView.reloadData()
                
                //self.tableView.scrollToRow(at: 0, at: UITableView.ScrollPosition, animated: true)
            }
        }) { (requestResponce, error) in
            
            NetworkRequest.sharedInstance.errorResponseForApi(error: error)
        }
        
    }
}


//mark: tableView extention------

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArticleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.selectionStyle = .none
        cell.titleLbl.text = self.newsArticleArray[indexPath.row].title
        cell.autherName.text = self.newsArticleArray[indexPath.row].author
        cell.publishedDate.text = self.newsArticleArray[indexPath.row].publishedAt
        
        let url = URL(string: self.newsArticleArray[indexPath.row].urlToImage)
        
        if url != nil{
            
            cell.imgView.setImageWith(url!, placeholderImage: UIImage(named: "img"))
        }else{
            
            cell.imgView.image = UIImage(named: "img")
        }
        
        cell.descriptionLbl.text = self.newsArticleArray[indexPath.row].description
        cell.content.text = self.newsArticleArray[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.url = self.newsArticleArray[indexPath.row].url
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//mark: collectionview extention-------

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        if indexPath.item == 0{
             cell.tabName.text = "Article About Bitcoin "
        }else if indexPath.item == 1{
             cell.tabName.text = "Business Headlines"
        }else if indexPath.item == 2{
             cell.tabName.text = "Articles by Apple"
        }else if indexPath.item == 3{
             cell.tabName.text = "TechCrunch Headlines"
        }else{
             cell.tabName.text = "Wall Street Articles"
        }
        
        if self.selected_tab == "\(indexPath.item)"{
            
            cell.backView.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
            cell.tabName.textColor = UIColor.white
        }else{
            cell.backView.backgroundColor = UIColor.lightGray
            cell.tabName.textColor = UIColor.white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 130, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selected_tab = "\(indexPath.item)"
        self.tabCollectionView.reloadData()
        self.webServcieCall(selected_tab: self.selected_tab)
    }

}
