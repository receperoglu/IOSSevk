 

import UIKit

class imageViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var Pieces = [Int]()
    var ProductTypeNames = [String]()
    var Color = [String]()
    var Metrics = [String]()
    var Products = [String]()
    var OrderIds = [Int]()  
    
    var TappedArticelId = ""
    var ArtName=""
    var CustName=""
    @IBOutlet weak var ordertableview: UITableView!
    
    @IBOutlet weak var lblCustName: UILabel!
    
    
    @IBOutlet weak var lblArtName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblArtName.text=ArtName
        lblCustName.text=CustName
        
        
        let request = URL(string: "\(serviceurl)Orders&ArticelId=\(TappedArticelId)" )!
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let ResultData = try? JSONDecoder().decode([Order].self, from: data) {
                    
                    DispatchQueue.main.async {
                        for order in  ResultData {
                            
                            self.OrderIds.append(order.id)
                            self.Products.append( "\(order.Piece) \(order.Metrics) \(order.Dimensions) \(order.Color) \(order.ProductTypeName) ")
                            
                        }
                        
                        self.ordertableview.delegate = self
                        self.ordertableview.dataSource = self
                        self.ordertableview.reloadData()
                    }
                    
                }
            }
        }.resume()
    }
    
    
    
    
    
    func tableView(_ ordertableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Pieces.remove(at: indexPath.row)
            ordertableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func tableView(_ ordertableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "toDetailViewController", sender: nil)

        
 
    }
    
  
    
    func tableView(_ ordertableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = ordertableview.dequeueReusableCell(withIdentifier: "LabelCell2", for: indexPath)
        
        let headline = self.OrderIds[indexPath.row]
        
        
        cell.textLabel?.text = self.Products[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ ordertableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Products.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toDetailViewController" {
                let destinationVC2 = segue.destination as! DetailViewController
                destinationVC2.TappedArticelId = TappedArticelId
               
                
            }
        }
    
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
