//
//  FavoriteVC.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 20.07.2023.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var anasayfaBtn: UIImageView!
    
    var selectedTitle = ""
    var selectedTitleID = UUID()
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var data: [Favori] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        anasayfaBtn.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(anasayfa))
        anasayfaBtn.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        getData()

    }
    
    @objc func anasayfa() {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func didDeleteFavorite(withId id: UUID) {
        if let index = idArray.firstIndex(of: id) {
            titleArray.remove(at: index)
            idArray.remove(at: index)
            favoriteTableView.reloadData()
        }
    }
    
    @objc func getData() {
        titleArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    favoriteTableView.reloadData()
                }
            }
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = titleArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenTitle = selectedTitle
            destinationVC.chosenTitleID = selectedTitleID
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titleArray[indexPath.row]
        selectedTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
            fetchRequest.returnsObjectsAsFaults = false
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                titleArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.favoriteTableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
}
