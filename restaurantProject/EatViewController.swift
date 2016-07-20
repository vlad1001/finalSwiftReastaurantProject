import UIKit

class EatViewController: UIViewController {

    @IBOutlet weak var eatImageView: UIImageView!
    @IBOutlet weak var eatNameLabel: UILabel!
    @IBOutlet weak var eatPriceLabel: UILabel!
    @IBOutlet weak var eatDescriptionLabel: UILabel!

    
    var nameLabel:String = ""
    var price:Int = 0
    var itemDescription:String = ""
    var priceLabel: Int = 0
    var imageName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eatImageView.kf_setImageWithURL(NSURL(string: imageName )!)
        self.eatNameLabel.text = self.nameLabel
        self.eatPriceLabel.text = (String)(self.priceLabel)
        self.eatDescriptionLabel.text = self.itemDescription
            
    }

    @IBAction func backBtn(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
