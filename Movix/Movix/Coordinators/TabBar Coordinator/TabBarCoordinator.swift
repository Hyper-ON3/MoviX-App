//
//  TabBarCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 15/02/2023.
//

import UIKit

enum TabBarPage {
    case home
    case search
    case favorites
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .search
        case 2:
            self = .favorites
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .favorites:
            return "Favorites"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .favorites:
            return 2
        }
    }
    
    func setPageImage() -> UIImage? {
        switch self {
        case .home:
            return UIImage(named: K.ImagesName.home)
        case .search:
            return UIImage(named: K.ImagesName.search)
        case .favorites:
            return UIImage(named: K.ImagesName.favorites)
        }
    }
    
    func setSelectedImage() -> UIImage? {
        switch self {
        case .home:
            return UIImage(named: K.ImagesName.homeSelected)
        case .search:
            return UIImage(named: K.ImagesName.searchSelected)
        case .favorites:
            return UIImage(named: K.ImagesName.favoritesSelected)
        }
    }
    // Add tab icon value
    
    // Add tab icon selected / deselected color
    
    // etc
}

protocol TabBarCoordinatorProtocol {
    
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: TabBarCoordinatorProtocol, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var parentCoordinator: MainCoordinator?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .search, .favorites]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        //tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        /// Styling
        tabBarController.tabBar.isTranslucent = false
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.setPageImage()?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
                                                     tag: page.pageOrderNumber())
        
        navController.tabBarItem.selectedImage = page.setSelectedImage()?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        switch page {
        case .home:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let home = HomeCoordinator(navigationController: navController)
            home.parentCoordinator = parentCoordinator
            home.start()
    
        case .search:
            
            let search = SearchCoordinator(navigationController: navController)
            search.start()
        case .favorites:
            
            let favorites = FavoritesCoordinator(navigationController: navController)
            favorites.start()
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? {
        
        TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    
    
}


