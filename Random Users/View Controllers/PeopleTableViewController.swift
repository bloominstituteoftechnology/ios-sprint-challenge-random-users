//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    let client = PersonController()
    
    private var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.fetch { (people, error) in
            guard let people = people else {return}
            self.people = people
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }
    
   
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else {return UITableViewCell()}
     
        
     
     
     return cell
     }
 
   
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
     }
     
     private func loadImage(forCell cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        
        
        
    }
    
}
