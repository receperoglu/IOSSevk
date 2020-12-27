 
import Foundation

 
 struct Order: Decodable, Identifiable {
    let Dimensions: String
    let ProductTypeName:String
    let Piece:Int
    let id:Int
    let CorpId:Int
    let Color:String
    let Metrics:String
    let SaleTypeId:String
    let CreatedDate:String
    let SaleTypeName:String
}
 
 
 
 
