//
//  ViewController.swift
//  ApiPullApp
//
//  Created by Akdag on 20.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allPetitions = [Petition]()
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(showDataSource))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetition))
        
        loadPetition()
        
    }
    @objc func searchPetition(){
        let ac = UIAlertController(title: "Search petitions", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            if let item = ac?.textFields?[0].text {
                self?.petitionFilter(item)
            }
        }
        
        ac.addAction(searchAction)
        ac.addAction(UIAlertAction(title: "Clear current search", style: .default) { [weak self] _ in
            self?.petitions = self!.allPetitions
            self?.tableView.reloadData()
        })
        
        ac.preferredAction = searchAction
        present(ac, animated: true)
        }
    @objc func showDataSource(){
        let ac = UIAlertController(title: "Data source",
                                   message: "Data is recovered from We The People API of the Whitehouse",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func loadPetition(){
        let urlString : String
        switch navigationController?.tabBarItem.tag {
        case 1 :
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        default  :
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json : data)
                return
            }
        }
    }
    func parse(json : Data ){
        let decoder = JSONDecoder()
        do {
            let jsonPetition = try decoder.decode(Petitions.self, from: json)
            allPetitions = jsonPetition.results
            petitions = allPetitions
            tableView.reloadData()
           
        }catch{
            print(error)
        }
    }
    
    func petitionFilter( _ word :String){
        petitions = petitions.filter({
            $0.title.localizedCaseInsensitiveContains(word) ||
                $0.body.localizedCaseInsensitiveContains(word)
            
        })
        tableView.reloadData()
    }


}
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
}
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        let petition = petitions[indexPath.row]
        vc.detailPetition = petition
        navigationController?.pushViewController(vc, animated: true)
    }
}

