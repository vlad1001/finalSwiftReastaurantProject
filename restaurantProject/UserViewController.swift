import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var createAccBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mainSegmentControl: UISegmentedControl!
    @IBOutlet weak var skipBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.hidden = true
        self.createAccBtn.alpha = 0.0
        
        loadFireBase() //loads the menu FoodItems (from the Firebase class)
        
        if (FIRAuth.auth()?.currentUser) != nil //logged in
        {
            self.showHideFields(true)
            loadFireBase()
        }
        else //logged off
        {
            self.showHideFields(false)
            self.userNameLabel.text = "Welcome!"
            self.skipBtn.hidden = false
        }
    }
    
    //loads the menu FoodItems (from the Firebase class)
    func loadFireBase()
    {
        FirebaseReference.fetchDishes("Drink", completionBlock: { (foodItems) in
            if let foodItems = foodItems {
                FirebaseReference.allDrinks = foodItems
            } else {
                  print("Error fetching Drink")
            }
        })
        FirebaseReference.fetchDishes("Food", completionBlock: { (foodItems) in
            if let foodItems = foodItems {
                FirebaseReference.allFood = foodItems
            } else {
               print("Error fetching Food")
            }
        })
        FirebaseReference.fetchDishes("Dessert", completionBlock: { (foodItems) in
            if let foodItems = foodItems {
                FirebaseReference.allDessert = foodItems
            } else {
                  print("Error fetching Dessert")
            }
        })
    
    }
    //if user does not want to register (and just look at the menu for instance)
    @IBAction func skipBtn(sender: UIButton) {
        FIRAuth.auth()?.signInWithEmail("master@gmail.com", password: "zxcvbn") //account for guests (for firebase auth and data load)
        { (user, error) in
        self.loadFireBase()
        }
    }
    
    //sign in/register segmantController
    @IBAction func segmantChoise(sender: UISegmentedControl) {
        if mainSegmentControl.selectedSegmentIndex == 0 //log in
        {
            self.nameField.hidden = true
            self.createAccBtn.hidden = true
            self.loginBtn.hidden = false
            self.skipBtn.hidden = false
        }
        if mainSegmentControl.selectedSegmentIndex == 1 //register
        {
             self.createAccBtn.alpha = 1.0
             self.nameField.hidden = false
             self.createAccBtn.hidden = false
             self.loginBtn.hidden = true
             self.skipBtn.hidden = false
            
        }
        
    }
    
    
    func showHideFields(boolean: Bool)
    {
        
        if boolean == true                  //loged in
        {
            self.userNameLabel.hidden = false
            self.proceedBtn.hidden = false
            self.logoutBtn.hidden = false
            self.emailField.hidden = true
            self.passwordField.hidden = true
            self.loginBtn.hidden = true
            self.createAccBtn.hidden = true
            self.mainSegmentControl.hidden = true
            self.skipBtn.hidden = true
        }else{                              //logged out
            self.proceedBtn.hidden = true
            self.logoutBtn.hidden = true
            self.emailField.hidden = false
            self.passwordField.hidden = false
            self.loginBtn.hidden = false
            self.createAccBtn.hidden = false
            self.mainSegmentControl.hidden = false
            self.skipBtn.hidden = false
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //clear textFields when necessary
    func emptyFields(){
        self.emailField.text = ""
        self.passwordField.text = ""
        self.nameField.text = ""
        self.userNameLabel.text = "Welcome!"
    }

    
    @IBAction func createAccountBtn(sender: UIButton) {

        if self.emailField.text == "" || self.passwordField.text == "" || self.nameField.text == "" //if fields empty
        {
            alertUser();
        }else
        {    //create account in Firebase auth
            FIRAuth.auth()?.createUserWithEmail(self.emailField.text!, password: self.passwordField.text!) { (user: FIRUser?, error) in
                
                if error == nil
                {
                    guard let uid = user?.uid else{
                        return
                    }
                    //add the account to firebase Database at the right place (under users)
                    let ref = FIRDatabase.database().referenceFromURL("https://restaurantproject-27368.firebaseio.com/") //my Firebase database url
                    let userReference = ref.child("users").child(uid)
                    let values = ["name" : self.nameField.text!, "email": self.emailField.text!]
                    userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if error != nil
                        {
                            let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    })
                    // switches to log in mode -> only after resgistering
                    self.mainSegmentControl.selectedSegmentIndex = 0
                    self.nameField.hidden = true
                    self.createAccBtn.hidden = true
                    self.loginBtn.hidden = false
                    

                    self.showHideFields(false) // created account succesfuly
                    self.emptyFields();
                    self.createAccBtn.alpha = 0.0
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        //creates button delay for a better user ux, so if the internet connection is slow he\she will not be abble to press the button for 3 seconds
        self.createAccBtn.enabled = false
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(self.enableBtns), userInfo: nil, repeats: false)
    }
    


    
    @IBAction func loginBtn(sender: UIButton) {
        
        
        
        if self.emailField.text == "" || self.passwordField.text == ""  //if fields empty
        {
            alertUser();
        }
        else
        {   //sign in using Firebase auth
            FIRAuth.auth()?.signInWithEmail(self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                
                if error == nil
                {
                    self.showHideFields(true); //succesfuly signed in
                    self.emptyFields();
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
        
         //creates button delay for a better user ux, so if the internet connection is slow he\she will not be abble to press the button for 4 seconds
        self.loginBtn.enabled = false //for 4 seconds delay
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.enableBtns), userInfo: nil, repeats: false)
    }
    
    //after the delay of the login/create account buttons
    func enableBtns() {
           self.loginBtn.enabled = true
           self.createAccBtn.enabled = true
    }
    
    //tell user some field is empty
    func alertUser()
    {
        let alertController = UIAlertController(title: "Oops!",message: "Please enter email, password and name.",
                                                preferredStyle: .Alert)
    
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
    
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //log out user using firebase auth
    @IBAction func logoutBtn(sender: UIButton) {
        do{
            try FIRAuth.auth()!.signOut()
        } catch let logoutError{
            print(logoutError)
        }

        self.userNameLabel.text = "Welcome!"
        showHideFields(false); //logged off
        self.emptyFields();
    }
    //make keyboard disappear by pressing the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool { //for return key to lower the keyboard
        textField.resignFirstResponder()
        return false
    }

}


