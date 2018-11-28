//
//  ArticleListViewController.swift
//  QiitaViewer
//
//  Created by ユーザー１ on 2018/11/27.
//  Copyright © 2018 Masaya Ujihara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource {
  
  var articles: [[String: String?]] = [] // 記事を入れるプロパティを定義
  
  let table = UITableView() // プロパティにtableを追加
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "新着記事" // Navigation Barのタイトルを設定
    
    table.frame = view.frame // tableの大きさをviewの大きさに合わせる
    view.addSubview(table) // viewにtableを乗せる
    table.dataSource = self // dataSouceプロパティに自身を代入
    
    getArticles()
  }
  
  func getArticles() {
    let urlString: String = "https://qiita.com/api/v2/items"
    Alamofire.request(urlString)
      .responseJSON { response in
        guard let object = response.result.value else {
          return
        }
        //print(response.result.value)
        
        let json = JSON(object)
        
        json.forEach { (_, json) in
          let article: [String: String?] = [
            "title": json["title"].string,
            "userId": json["user"]["id"].string
          ] // 1つの記事を表す辞書型を作る
          self.articles.append(article) // 配列に入れる
        }
      self.table.reloadData() // TableViewを更新
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") // Subtitleのあるセルを生成
    let article = articles[indexPath.row] // 行数番目の記事を取得
    cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
    cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
    return cell // cellを返す
  }
  
}
