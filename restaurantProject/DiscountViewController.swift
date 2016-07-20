import UIKit
import Firebase
import Kingfisher


class DiscountViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var dealImage: UIImageView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        getDailySaleImageUrl() //receives the image from the firebase Database
        menuBar()
    }

    func getDailySaleImageUrl() { //only call for this Firebase method so i left it here instead of moving to Firebase class
        FirebaseReference.getDataOfChild("DailySale").observeSingleEventOfType(.Value, withBlock: { (snapshot) in

            let urlPath = snapshot.value!
            
            self.dealImage.kf_setImageWithURL(NSURL(string: urlPath as! String)!)

        }) { (error) in
            print(error.localizedDescription)
        }

}

    
    func menuBar(){ //3rd party library
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
