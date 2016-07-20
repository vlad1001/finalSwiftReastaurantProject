import UIKit



class SnacksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var snackCollectionView: UICollectionView!
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //num of rows
        return FirebaseReference.allDessert.count
    }
    
    //menu cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dessertCell", forIndexPath: indexPath) as! MenuCollectionViewCell

        cell.imageView?.kf_setImageWithURL(NSURL(string: FirebaseReference.allDessert[indexPath.row].imageUrl )!)
        cell.DesctiptionLabel?.text = FirebaseReference.allDessert[indexPath.row].name
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier( "dessertShowImageSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier ==  "dessertShowImageSegue"
        {
            let indexPaths = self.snackCollectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let vc = segue.destinationViewController as! EatViewController
            
            vc.imageName = FirebaseReference.allDessert[indexPath.row].imageUrl
            vc.nameLabel = FirebaseReference.allDessert[indexPath.row].name
            vc.priceLabel = FirebaseReference.allDessert[indexPath.row].price
            vc.itemDescription = FirebaseReference.allDessert[indexPath.row].description

        }
    }
    

}
