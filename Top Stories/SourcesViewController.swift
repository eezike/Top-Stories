//
//  ViewController.swift
//  Top Stories
//
//  Created by Emeka Ezike on 7/10/18.
//  Copyright © 2018 Emeka Ezike. All rights reserved.
//

import UIKit

 class SourcesViewController: UITableViewController
{
    var sources = [[String: String]]()
    let apiKey = "5d892509a49046a087917c466fa80d09"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "News Sources"
        let query = "https://newsapi.org/v1/sources?language=en&country=us&apiKey=\(apiKey)"
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
        for result in json["sources"].arrayValue
        {
            let id = result["id"].stringValue
            let name = result["name"].stringValue
            let description = result["description"].stringValue
            let source = ["id": id, "name": name, "description": description]
            sources.append(source)
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
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let source = sources[indexPath.row]
        cell.textLabel?.text = source["name"]
        cell.detailTextLabel?.text = source["description"]
        return cell
    }

}

