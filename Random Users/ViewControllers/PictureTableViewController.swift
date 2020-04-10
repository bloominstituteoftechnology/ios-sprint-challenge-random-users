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
    
    private var cache = Cache<Int, Data>()
    private var photoFetchQueue = OperationQueue()
    private var operations = [Int : Operation]()
    
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        faceController.getYourFace { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = faceController.results?.results.count else {return 0}
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PictureTableViewCell else {return UITableViewCell()}

        let face = faceController.results?.results[indexPath.row]
        faceController.results?.results[indexPath.row].id = indexPath.row
        
        cell.nameLabel.text = face?.name
        loadImage(forCell: cell, forItemAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operation = operations[indexPath.row] {
            operation.cancel()
        }
    }
    
     private func loadImage(forCell cell: PictureTableViewCell, forItemAt indexPath: IndexPath) {
        guard let face = faceController.results?.results[indexPath.row] else {return}
        
        // Check for image in cache
        if let cachedImageData = cache.value(for: indexPath.row),
            let image = UIImage(data: cachedImageData) {
            cell.facePic.image = image
            return
        }
        
        // Start an operation to fetch image data
        let fetchOp = FetchPhotoOperation(face: face)
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, for: indexPath.row)
            }
        }
        let completionOp = BlockOperation {
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            }
            
            if let data = fetchOp.imageData {
                cell.facePic.image = UIImage(data: data)
            }
            self.operations.removeValue(forKey: indexPath.row)
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[face.id] = fetchOp
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
            guard let vc = segue.destination as? DetailViewController, let theRow = tableView.indexPathForSelectedRow?.row else { return }
            
            cache.clearData()
            
            let newFace = faceController.results?.results[theRow]
            vc.face = newFace
            
        }
    }


}
