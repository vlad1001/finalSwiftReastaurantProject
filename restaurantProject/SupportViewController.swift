import UIKit

class SupportViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBar()
    }

    func menuBar(){ //3rd party library
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    //phone call function
    func makeCall(phone: String) {
        let formatedNumber = phone.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        let phoneUrl = "tel://\(formatedNumber)"
        let url:NSURL = NSURL(string: phoneUrl)!
        UIApplication.sharedApplication().openURL(url)
    }
    

    @IBAction func callBtn(sender: UIButton) {
        makeCall("123456789")
    }


}
