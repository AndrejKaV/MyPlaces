//
//  MainViewController.swift
//  MyPlaces
//
//  Created by admin on 27.03.2022.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
 
    var places: Results<Place>!
   // var numberOfRows = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        places = realm.objects(Place.self)
       // numberOfRows = places.count
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
 
        return cell
    }
    
    // MARK: Table view delegate
    private func deleteRow(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let place = places[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else {return}
            let alert = UIAlertController(title: "Are you sure?", message: "Delete \(place.name)?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
                            //self.numberOfRows -= 1
                            StorageManager.deleteObject(place)
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                            //self.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                self.tableView.reloadData()
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        return action
    }
    
    private func editRow(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let place = places[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { [weak self](_, _, _) in
            let alert = UIAlertController(title: "Do you want to edit \(place.name)?", message: "You could make some editing of this stuff", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
                //setupEditScreen()
               
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                self?.tableView.reloadData()
            }
            alert.addAction(ok)
            alert.addAction(cancel)
             
            self?.present(alert, animated: true)
        }
        return action
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//       let edit = self.editRow(rowIndexPathAt: indexPath)
        let delete = self.deleteRow(rowIndexPathAt: indexPath)
//         let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
         let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let place = places[indexPath.row]
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
//
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//
//        return [deleteAction]
//    }
    
    
 
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
         
        newPlaceVC.savePlace()
        tableView.reloadData()
    }

}
