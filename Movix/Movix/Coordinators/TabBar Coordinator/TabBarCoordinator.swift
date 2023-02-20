//
//  TabBarCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 15/02/2023.
//

import UIKit

protocol TabBarCoordinatorProtocol {
    
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var parentCoordinator: MainCoordinator?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = CustomTabBarViewController()
    }
    
    func start() {
        // Define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .search, .favorites]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        
        // Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        // Set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        // Styling
        self.navigationController.navigationBar.isHidden = true
        // Attaching tabBarController to navigation controller associated with this coordanator
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
        case .search:
            
            let search = SearchCoordinator(navigationController: navController)
            search.parentCoordinator = parentCoordinator
            search.navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: -7, bottom: -7, right: 0)
            search.navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
            search.start()
        case .home:
            
            let home = HomeCoordinator(navigationController: navController)
            home.navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
            home.parentCoordinator = parentCoordinator
            home.start()
        case .favorites:
            
            let favorites = FavoritesCoordinator(navigationController: navController)
            favorites.navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: -7, bottom: -7, right: 0)
            favorites.navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
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

