//
//  FavoriteEmojiTableViewController.swift
//  myFavoriteEmoji
//
//  Created by Steve Lederer on 12/12/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class FavoriteEmojiTableViewController: UITableViewController {
    
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
    }
    
    func refreshView() {
        PersonController.getPerson { (people) in
            DispatchQueue.main.async {
                self.people = people ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func presentAddEmojiAlert() {
        let alertController = UIAlertController(title: "🤜Add Your Favorite Emoji🤛", message: nil, preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Your name..."
            nameTextField.autocapitalizationType = .words
        }
        alertController.addTextField { (emojiTextField) in
            emojiTextField.placeholder = "🤯Your favorite emoji...🥳"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addNewPersonAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text, !name.isEmpty, let emoji = alertController.textFields?[1].text, !emoji.isEmpty else { self.presentMissingInfoAlert() ; return }
            PersonController.postPerson(name: name, favoriteEmoji: emoji, completion: { (success) in
                if success {
                    self.refreshView()
                } else {
                    DispatchQueue.main.async {
                        self.presentFailedToPostAlert()
                    }
                }
            })
        }
        alertController.addAction(cancelAction) ; alertController.addAction(addNewPersonAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentFailedToPostAlert() {
        let alertController = UIAlertController(title: "Whoops!", message: "Smething went wrong saving your post to the cloud.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func presentMissingInfoAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "You forgot to enter something. Please try agan.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (_) in
            self.presentAddEmojiAlert()
        }))
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteEmojiCell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.favoriteEmoji
        cell.detailTextLabel?.text = person.name
        return cell
    }
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshView()
    }
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAddEmojiAlert()
    }
    
    
}
