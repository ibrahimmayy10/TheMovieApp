//
//  DetailsVC.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 20.07.2023.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
        
    var selectedMediaItem: MediaItem?
        
    var chosenTitle = ""
    var chosenTitleID : UUID?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        if !chosenTitle.isEmpty {
            
            likeBtn.setImage(UIImage(named: "favoridolu"), for: .normal)
            likeBtn.tag = 1
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
            let idString = chosenTitleID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String {
                            titleLabel.text = title
                        }
                        if let imdb = result.value(forKey: "imdb") as? Double {
                            imdbLabel.text = String(imdb)
                        }
                        if let overview = result.value(forKey: "overview") as? String {
                            overviewLabel.text = overview
                        }
                        if let imageURL = result.value(forKey: "image") as? URL {
                            Webservices().downloadImage(from: imageURL) { image in
                                self.movieImageView.image = image
                            }
                        }
                    }
                }
            } catch {
                print("Error")
            }
            
        }
        
        write()
        
    }
    
    func write() {
        guard let title = selectedMediaItem?.title else { return }
        titleLabel.text = title
        
        guard let imdb = selectedMediaItem?.imdb else { return }
        imdbLabel.text = String(imdb)
        
        guard let overview = selectedMediaItem?.description else { return }
        overviewLabel.text = overview
        
        guard let imageURL = selectedMediaItem?.imageURL else { return }
        Webservices().downloadImage(from: imageURL) { image in
            self.movieImageView.image = image
        }
    }

    @IBAction func likeButton(_ sender: Any) {
        
        if likeBtn.tag == 0 {
            likeBtn.setImage(UIImage(named: "favoridolu"), for: .normal)
            likeBtn.tag = 1
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newFavori = NSEntityDescription.insertNewObject(forEntityName: "Favori", into: context)
            newFavori.setValue(selectedMediaItem?.title, forKey: "title")
            newFavori.setValue(UUID(), forKey: "id")
            newFavori.setValue(selectedMediaItem?.description, forKey: "overview")
            newFavori.setValue(selectedMediaItem?.imdb, forKey: "imdb")
            newFavori.setValue(selectedMediaItem?.imageURL, forKey: "image")
            
            do {
                try context.save()
            } catch {
                print("error")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            
        } else {
            likeBtn.setImage(UIImage(named: "favoribos"), for: .normal)
            likeBtn.tag = 0

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<Favori> = Favori.fetchRequest()
            if let selectedId = chosenTitleID {
                fetchRequest.predicate = NSPredicate(format: "id == %@", selectedId as CVarArg)
            }
            
            do {
                let results = try context.fetch(fetchRequest)
                if let objectToDelete = results.first {
                    context.delete(objectToDelete)
                    try context.save()
                }
            } catch {
                print("error")
            }
            
            performSegue(withIdentifier: "toViewController", sender: nil)

        }
        
    }
    
}
