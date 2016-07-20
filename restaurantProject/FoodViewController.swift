import UIKit




class FoodViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var eatItemCollectionView: UICollectionView!
    
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

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //num of rows
         return FirebaseReference.allFood.count
    }
    
    //menu cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MenuCollectionViewCell

        cell.imageView?.kf_setImageWithURL(NSURL(string: FirebaseReference.allFood[indexPath.row].imageUrl)!)
        cell.DesctiptionLabel?.text = FirebaseReference.allFood[indexPath.row].name

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier( "showImageSegue", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier ==  "showImageSegue"
        {
            let indexPaths = self.eatItemCollectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let vc = segue.destinationViewController as! EatViewController
            
            vc.imageName = FirebaseReference.allFood[indexPath.row].imageUrl
            vc.nameLabel = FirebaseReference.allFood[indexPath.row].name
            vc.priceLabel = FirebaseReference.allFood[indexPath.row].price
            vc.itemDescription = FirebaseReference.allFood[indexPath.row].description
 
        }
    }
    
}
