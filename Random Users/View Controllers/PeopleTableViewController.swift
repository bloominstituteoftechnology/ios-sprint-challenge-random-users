//
//  PeopleTableViewController.swift
//  Random Users
//
//  Created by Dillon P on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    private var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PeopleController.shared.fetchPeople { (_) in
            
            for results in PeopleController.shared.results {
                let peopleResults = results.results
                for person in peopleResults {
                    self.people.append(person)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        
        let person = people[indexPath.row]
        cell.nameLabel.text = person.name

        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadPersonImage(forCell: UITableViewCell, forItemAt indexPath: IndexPath) {
    
    }

}
