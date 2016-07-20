import UIKit



class DrinksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var drinkCollectionView: UICollectionView!

    
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
        return FirebaseReference.allDrinks.count
    
    }
    
    //menu cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("drinkCell", forIndexPath: indexPath) as! MenuCollectionViewCell

        cell.imageView?.kf_setImageWithURL(NSURL(string: FirebaseReference.allDrinks[indexPath.row].imageUrl )!)
        cell.DesctiptionLabel?.text = FirebaseReference.allDrinks[indexPath.row].name
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier( "drinkShowImageSegue", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier ==  "drinkShowImageSegue"
        {
            let indexPaths = self.drinkCollectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let vc = segue.destinationViewController as! EatViewController
      
            vc.imageName = FirebaseReference.allDrinks[indexPath.row].imageUrl
            vc.nameLabel = FirebaseReference.allDrinks[indexPath.row].name
            vc.priceLabel = FirebaseReference.allDrinks[indexPath.row].price
            vc.itemDescription = FirebaseReference.allDrinks[indexPath.row].description 

        }
    }

}



