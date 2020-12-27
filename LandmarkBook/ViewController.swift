
import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    var ArticelNames = [String]()
    var CustomerNames = [String]()
    var ArticelIds = [Int]()
    var chosenLandmarkName = ""
    var  param = ""

    var  chosenArtName = ""
    var  chosenCustName =  ""
    var FilteredArticelNames = [String]()
    var FilteredCustomerNames = [String]()
    
    var isSearching = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ara: UISearchBar!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URL(string: "\(serviceurl)Articels")!
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let ResultData = try? JSONDecoder().decode([Articel].self, from: data) {
                    
                    DispatchQueue.main.async {
                        for articel in  ResultData {
                            
                            if(articel.ArticelName.capitalized==""){
                                
                                 self.ArticelNames.append("AT-\(articel.id) Sipariş Adı Yok")
                                
                            }  else{
                                
                                 self.ArticelNames.append("AT - \(articel.id) \(articel.ArticelName.capitalized)")
                                
                            }
                            
                           
                            self.CustomerNames.append(articel.CustomerName.capitalized)
                            self.ArticelIds.append(articel.id)
                            
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                            
                            self.FilteredArticelNames = self.ArticelNames
                            
                        }
                    }
                }
            }
        }.resume()   
        navigationItem.title = "Siparişler"
        ara.scopeButtonTitles = ["Firma", "Artikel", ]
        ara.showsScopeBar=true
        ara.enablesReturnKeyAutomatically = false
        ara.delegate = self
        
         
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("New scope index is now \(selectedScope)")
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            param = String(ArticelIds[indexPath.row]);
            print(param)
            deletedata()
            ArticelNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    }
    
    func deletedata(){
        print(param)
        let requests = URL(string: "\(serviceurl)ArticelDelete.ashx?platform=ios&id=\(param)")!
        var request = URLRequest(url: requests)
        request.httpMethod = "POST"
        let postString = "postDataKey=value"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
       
                self.ArticelNames = FilteredArticelNames.filter({$0.contains(searchBar.text ?? "")})
                
           
            tableView.reloadData()
        }
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        if isSearching {
            cell.textLabel?.text = ArticelNames[indexPath.row]
            cell.detailTextLabel?.text = CustomerNames[indexPath.row]

        }
        else {
          
 
            cell.textLabel?.text = self.ArticelNames[indexPath.row]
            cell.detailTextLabel?.text = CustomerNames[indexPath.row]

 
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticelNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenLandmarkName = String(ArticelIds[indexPath.row])
        chosenArtName = self.ArticelNames[indexPath.row]
        chosenCustName = self.CustomerNames[indexPath.row]
        performSegue(withIdentifier: "toImageViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageViewController" {
            let destinationVC = segue.destination as! imageViewController
            destinationVC.TappedArticelId = chosenLandmarkName
            destinationVC.ArtName = chosenArtName
            destinationVC.CustName = chosenCustName
            
        }
    }
    
    
    
    
    
    
}

