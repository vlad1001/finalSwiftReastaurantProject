import Foundation

class FoodItem{

    var name: String
    var description: String
    var imageUrl: String
    var price: Int
    
    
    init(name: String, description: String, imageUrl: String, price: Int){
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.price = price
    }

    init(firebaseDictionary:[String:AnyObject]) { //for init from Firebase Database
        if let name = firebaseDictionary["name"] as? String,
            description = firebaseDictionary["description"] as? String,
            imageUrl = firebaseDictionary["imageUrl"] as? String,
            price = firebaseDictionary["price"] as? Int {

            self.name = name
            self.description = description
            self.imageUrl = imageUrl
            self.price = price
        } else {
            self.name = "unassinged"
            self.description = "unassinged"
            self.imageUrl = "unassinged"
            self.price = -1
        }
    }
    
}