//
//  BookHomeVC.swift
//  FirebaseApp
//
//  Created by MAC on 19.04.2020.
//  Copyright © 2020 cagdaseksi. All rights reserved.
//

import UIKit
import Firebase

class BookHomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var items = [CategoryModel]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveItems()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let row = self.items[indexPath.row]
        
        cell.textLabel!.text = row.title
        cell.detailTextLabel!.text = row.desc
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = self.items[indexPath.row]
        print(row.key)
        performSegue(withIdentifier: "toBooks", sender: row.key)
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let des = segue.destination as? BookDetailViewController
    des?.category = sender as! String
    
    }
    
   func retrieveItems() {
    
        DataService.dataService.CATEGORY_REF.observe(.value, with: { (snapshot: DataSnapshot?) in
            
            if let snapshots = snapshot?.children.allObjects as? [DataSnapshot] {
                self.items.removeAll()
                
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let itemModel = CategoryModel(key: snap.key, dictionary: postDictionary)
                        self.items.insert(itemModel, at: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }

}
