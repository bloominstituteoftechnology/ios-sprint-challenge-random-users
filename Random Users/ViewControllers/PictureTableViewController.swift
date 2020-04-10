//
//  PictureTableViewController.swift
//  Random Users
//
//  Created by Bradley Diroff on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PictureTableViewController: UITableViewController {

    let faceController = FaceController()
    
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        faceController.getYourFace { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faceController.faces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PictureTableViewCell else {return UITableViewCell()}

        let face = faceController.faces[indexPath.row]
        
        cell.nameLabel.text = face.name

        return cell
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
            guard let vc = segue.destination as? DetailViewController, let theRow = tableView.indexPathForSelectedRow?.row else { return }
            
            let newFace = faceController.faces[theRow]
            vc.face = newFace
            
        }
    }


}
