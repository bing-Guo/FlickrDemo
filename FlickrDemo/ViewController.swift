import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Featured", image: UIImage(systemName: "star.fill"), tag: 0)
        searchVC.tabBarItem.title = "Featured"
        
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        favoriteVC.tabBarItem.title = "Favorites"
        
        viewControllers = [searchVC, favoriteVC]
    }
    
}
