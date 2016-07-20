import Foundation
import Firebase

class FirebaseReference {
    
    static var allDrinks = [FoodItem]()
    static var allFood = [FoodItem]()
    static var allDessert = [FoodItem]()
    static let FirebaseReferenceAddress = "https://restaurantproject-27368.firebaseio.com" //my Firebase Url
    

    static func getDataOfChild(child: String) -> FIRDatabaseReference {
        let ref = FIRDatabase.database().referenceFromURL(FirebaseReference.FirebaseReferenceAddress) //my Firebase database url

        return ref.child(child)
    }
    
    static func fetchDishes(dishType: String, completionBlock:(([FoodItem]?) -> Void)) {
        var arrayFromFirebase = [FoodItem]()
        getDataOfChild("MainDish").child(dishType).observeSingleEventOfType(.Value, withBlock: { (snapshot) in //mainDish is the root of the dishes
            if let dishes = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for dishSnapshot in dishes {
                    if let dishAsDictionary = dishSnapshot.value as? [String:AnyObject] {
                        let tempDish = FoodItem(firebaseDictionary: dishAsDictionary)
                        arrayFromFirebase.append(tempDish)
                    }
                }
                completionBlock(arrayFromFirebase)
            } else {
                completionBlock(nil)
            }
        })
    }
}