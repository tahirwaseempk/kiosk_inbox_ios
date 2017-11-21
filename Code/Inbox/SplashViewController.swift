import UIKit

class SplashViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        loadLoginView()
    }

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
