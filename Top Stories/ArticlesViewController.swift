//
//  ViewController.swift
//  Top Stories
//
//  Created by Emeka Ezike on 7/10/18.
//  Copyright © 2018 Emeka Ezike. All rights reserved.
//

import UIKit

 class ArticlesViewController: UITableViewController
{
    var articles = [[String: String]]()
    var apiKey = ""
    var source = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Top Stories"
         let query = "https://newsapi.org/v1/articles?" + "source=\(source["id"]!)&apiKey=\(apiKey)"
        DispatchQueue.global(qos: .userInitiated).async
            {
                [unowned self] in
                if let url = URL(string: query)
                {
                    if let data = try? Data(contentsOf: url)
                    {
                        let json = try! JSON(data: data)
                        if json["status"] == "ok"
                        {
                            self.parse(json: json)
                            return
                        }
                    }
                }
                self.loadError()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func parse(json: JSON)
    {
        for result in json["articles"].arrayValue
        {
            let title = result["title"].stringValue
            let description = result["description"].stringValue
            let url = result["url"].stringValue
            let article = ["title": title, "description": description, "url": url]
            articles.append(article)
        }
        
        DispatchQueue.main.async
            {
                [unowned self] in
                self.tableView.reloadData()
        }
    }
    
    func loadError()
    {
        DispatchQueue.main.async
            {
                [unowned self] in
                let alert = UIAlertController(title: "Loading Error",
                                              message: "There was a problem loading the news feed",
                                              preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["title"]
        cell.detailTextLabel?.text = article["description"]
        return cell
    }
    
}

