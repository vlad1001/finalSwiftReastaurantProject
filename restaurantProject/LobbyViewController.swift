import UIKit
import Firebase

class LobbyViewController: UIViewController {

    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var lobbydishesView: UIImageView!
    @IBOutlet weak var lobbyTextLabel: UILabel!


    var lobbyImage = UIImage()
    var imageName:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        menuBar()
        animation()

        lobbyTextLabel.center.x = self.view.frame.width + 30
        
        UIView.animateWithDuration(5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 30.0, options: .CurveEaseOut , animations: ({
            self.lobbyTextLabel.center.x = self.view.frame.width/2
        
        }), completion: nil)
    }
    
    
    func animation() //show changing images of the restaurant
    {
        lobbydishesView.animationImages =
            [
                UIImage(named: "luisko.jpg")!,
                UIImage(named: "luisko2.jpg")!,
                UIImage(named: "luisko3.jpg")!,
                UIImage(named: "luisko4.jpg")!,
                UIImage(named: "luisko5.jpg")!
                
        ]
        lobbydishesView.animationDuration = 14
        lobbydishesView.startAnimating()
    }
    //return to the main screen (register\log in\log out\skip options
    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func menuBar(){ //3rd party library
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    }

}
