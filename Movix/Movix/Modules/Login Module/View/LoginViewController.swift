//
//  LoginViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 10/01/2023.
//

import UIKit
import Lottie

class LoginViewController: UIViewController, Storyboarded {
 
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var emailBackgroundView: UIView!
    @IBOutlet weak var passwordBackgroundView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    weak var coordinator: LoginCoordinator?
    var loginViewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        coordinator?.didFinishLogin()
    }

    //MARK: - UI Configuration functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureUI() {
        
        errorLabel.alpha = 0
        
        animationView.isHidden = true
        animationView.backgroundColor = .clear
        
        emailBackgroundView.layer.cornerRadius = 15
        passwordBackgroundView.layer.cornerRadius = 15
        
        loginButton.layer.cornerRadius = 15
        
        loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let gradient = GradientText.getGradientLayer(bounds: appNameLabel.bounds)
        appNameLabel.textColor = GradientText.gradientColor(bounds: appNameLabel.bounds, gradientLayer: gradient)
        
    }
    
    @objc func textFieldDidChange( _ textField: UITextField) {
        self.loginViewModel?.getUserData(with: LoginModel(login: loginTextField.text ?? "", password: passwordTextField.text ?? ""))
    }
    
    // Loading animation for the Login Button
    private func loadingAnimation(animate: Bool) {
        
        animationView.loopMode = .playOnce
        
        if animate == true {
            animationView.isHidden = false
            loginButton.isHidden = true
            
            animationView.play() { [weak self] _ in
                guard let self else { return }
                
                self.displayWarningLabel()
            }
        } else {
            animationView.stop()
            loginButton.isHidden = false
            animationView.isHidden = true
        }
    }
    
    // Pop-up animation for WarningLabel
    private func displayWarningLabel() {
        
        UIView.animate(withDuration: 4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseOut],
                       animations: {
            
            self.errorLabel.text = ServiceManager.shared.errorMessage
            self.errorLabel.alpha = 1
        }) { _ in
            ServiceManager.shared.errorMessage = ""
            self.loadingAnimation(animate: false)
            self.errorLabel.alpha = 0
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        loadingAnimation(animate: true)
        loginViewModel?.logIn(coordinator: coordinator?.parentCoordinator)
    }
    
    // A function that saves user's password and login
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        loginViewModel?.saveUserData(sender)
    }
}

