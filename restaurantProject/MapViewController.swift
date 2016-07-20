import UIKit
import MapKit
import CoreLocation


class DetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var mapKit: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //Ben guryon 170 Ramat gan 32.075258, 34.818726
    let lat:CLLocationDegrees = 32.075258 // Coordinates
    let long:CLLocationDegrees = 34.818726
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBar()
        mapToLuisko()
        
    }
    
    func mapToLuisko()
    {
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        //span
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let Region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapKit.setRegion(Region, animated: true )
        
        let Annotation = MKPointAnnotation() //mark the restaurant on the map
        Annotation.title = "Luisko"
        Annotation.subtitle = "The best pizzeria in Israel!"
        Annotation.coordinate = coordinate
        
        mapKit.addAnnotation(Annotation)
        
    }

    
    
    func menuBar(){ //3rd party library
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    
    @IBAction func navigateBtn(sender: UIButton) {
        viewWaze(lat, longitude: long)
    }
    
    //function copied from the internet and modified.
    func viewWaze(latitude:Double, longitude:Double) {
    
        let urlStr = String(format: "waze://?ll=%f,%f&navigate=yes",latitude, longitude)
            if let url = NSURL(string: urlStr) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                    UIApplication.sharedApplication().idleTimerDisabled = true
                } else {
                    let appStoreLinkStr = "http://itunes.apple.com/us/app/id323229106"
                    if let url = NSURL(string: appStoreLinkStr) where UIApplication.sharedApplication().canOpenURL(url) {
                        UIApplication.sharedApplication().openURL(url)
                        UIApplication.sharedApplication().idleTimerDisabled = true
                }
            }
        }
    
    }

}
