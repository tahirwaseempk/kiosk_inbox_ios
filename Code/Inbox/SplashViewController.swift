import UIKit

class SplashViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch environment {
        case .texting_Line:
            splashImageView.image = UIImage(named: "splashImage")
            self.view.backgroundColor = AppBlueColor
        case .sms_Factory:
            splashImageView.image = UIImage(named: "sms_splash")
            self.view.backgroundColor = AppBlueColor
        case .fan_Connect:
            splashImageView.image = UIImage(named: "Fan_Login")
            self.view.backgroundColor = UIColor.white
        case .photo_Texting:
            splashImageView.image = UIImage(named: "Photo_Splash_Logo")
            self.view.backgroundColor = UIColor.white
        case .text_Attendant:
            splashImageView.image = UIImage(named: "text_attendant_splash")
            self.view.backgroundColor = TextAttendantColor
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
