//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Simon Elhoej Steinmejer on 07/09/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContacsTableViewController: UITableViewController
{
    let cellId = "cellId"
    let personController = PersonController()
    let cache = Cache<String, Data>()
    var fetchOperationDictionary: [String: FetchPhotoOperation] = [:]
    let photoFetchQueue = OperationQueue()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Contacts"
        personController.fetchPersons { (error) in
            
            if let error = error
            {
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let person = personController.persons[indexPath.row]
        
        cell.textLabel?.text = "\(person.name.title) \(person.name.first) \(person.name.last)"
        
        downloadImage(for: cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return personController.persons.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let person = personController.persons[indexPath.row]
        let contactDetailViewController = ContactDetailViewController()
        contactDetailViewController.person = person
        navigationController?.pushViewController(contactDetailViewController, animated: true)
    }
    
    func downloadImage(for cell: UITableViewCell, indexPath: IndexPath)
    {
        let person = personController.persons[indexPath.item]
        let id = person.id.value
        fetchOperationDictionary[id] = FetchPhotoOperation(person: person)
        
        if cache.imageIsCached(id: id)
        {
            cell.imageView?.image = UIImage(data: cache.thumbnail(for: id)!)
        }
        else
        {
            let fetchOperation = FetchPhotoOperation(person: person)
            let cacheOperation = BlockOperation {
                
                if let data = fetchOperation.thumbnailImageData
                {
                    self.cache.addToCache(thumbnail: data, key: id)
                }
            }
            
            let completionOperation = BlockOperation {
                
                defer { self.fetchOperationDictionary.removeValue(forKey: id) }
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath
                {
                    return
                }
                
                if let data = fetchOperation.thumbnailImageData
                {
                    cell.imageView?.image = UIImage(data: data)
                }
            }
            
            cacheOperation.addDependency(fetchOperation)
            completionOperation.addDependency(fetchOperation)
            
            photoFetchQueue.addOperation(fetchOperation)
            photoFetchQueue.addOperation(cacheOperation)
            OperationQueue.main.addOperation(completionOperation)
            
            fetchOperationDictionary[id] = fetchOperation
        }
        
        // TODO: Implement image loading here
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let person = personController.persons[indexPath.item]
        fetchOperationDictionary[person.id.value]?.cancel()
    }
    
    
}









