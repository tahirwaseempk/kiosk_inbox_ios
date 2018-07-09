import UIKit

class SplashViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        switch environment {
        case .texting_Line:
            splashImageView.image = UIImage(named: "splashImage")
        case .sms_Factory:
            splashImageView.image = UIImage(named: "sms_splash")
        }
        
        loadLoginView()
    }

    @IBOutlet weak var splashImageView: UIImageView!
    
    func loadLoginView()
    {
        let dispatchTime = DispatchTime.now() + .seconds(1)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime)
        {
            let homeStoryboard = UIStoryboard(name:"Login", bundle: nil)
            
            let homeViewController: UIViewController = homeStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.setViewControllers([homeViewController], animated: true)
        }
    }
}
