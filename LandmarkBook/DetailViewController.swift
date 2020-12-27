import UIKit

class DetailViewController:  UIViewController, UIWebViewDelegate{
    var TappedArticelId = ""
    var Pictures = [String]()
    @IBOutlet weak var loading: UIImageView!
     @IBOutlet weak var int: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    navigationItem.title = "Siparişler"
        
       let url = URL(string: "https://statu.space/StartApi.ashx?Platform=ios&ProcessType=Pictures&ArticelId=\(TappedArticelId)")
 
        let request = URLRequest(url: url!)
        int.loadRequest(request)
        
        
      int.delegate = self
}
    
    
    
 

func getImage(from string: String) -> UIImage? {
    guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
    }
    
    var image: UIImage? = nil
    do {
        let data = try Data(contentsOf: url, options: [])
        image = UIImage(data: data)
    }
    catch {
        print(error.localizedDescription)
    }
    return image
}



}
