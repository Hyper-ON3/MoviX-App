//
//  DetailsViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/01/2023.
//

import UIKit
import SDWebImage
import RxSwift
import youtube_ios_player_helper
import Lottie

class DetailsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var filmInfoLabel: UILabel!
    @IBOutlet weak var filmRatingLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var trailerPlayerView: YTPlayerView!
    @IBOutlet weak var successAnimationView: LottieAnimationView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var offlineImageView: UIImageView!
    
    weak var coordinator: DetailsCoordinator?
    var detailsViewModel: DetailsViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        detailsViewModel?.checkNetworkStatus(completion: { status in
            
            if status == false {
                offlineImageView.isHidden = false
                addToFavoriteButton.isHidden = true
                animationView(animated: false)
            } else {
                offlineImageView.isHidden = true
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        coordinator?.didFinishDetails()
    }
    
    //MARK: - UI Configuration functions
    
    private func configureUI() {
        
        title = K.Titles.filmDetails
        
        genresLabel.text = ""
        activityIndicator.isHidden = true
        ratingView.layer.cornerRadius = 30
        successAnimationView.isHidden = true
        
        detailsViewModel?.getDetails()
        bindTableView()
        loadTrailer()
    }
    
    private func configureDetails(with model: DetailsModel) {
        
        detailsViewModel?.isMovieInList(with: model.id, completion: { status in
           
            if status == true {
                self.animationView(animated: false)
            }
        })
        
        if model.backdropPath == "" {
            self.posterImageView.image = UIImage(named: K.ImagesName.noImage)
        } else {
            self.posterImageView.sd_setImage(with: URL(string: K.API.getPosterImage + model.backdropPath))
        }
        
        if self.genresLabel.text == "" {
            for i in model.genres.map({ $0.name }).joined(separator: ", ") {
                self.genresLabel.text = (self.genresLabel.text ?? "") + String(i)
            }
        }
        
        self.filmNameLabel.text = model.filmName
        self.statusLabel.text = "Status: " + model.status
        self.filmInfoLabel.text = model.filmInfo.joined(separator: " || ") + " min"
        self.filmRatingLabel.text = model.filmRating
        self.aboutLabel.text = model.about
        
    }
    
    //MARK: - Animation functions
    
    private func animationView(animated: Bool) {
        
        addToFavoriteButton.isHidden = true
        successAnimationView.isHidden = false
        successAnimationView.contentMode = .scaleAspectFit
        successAnimationView.loopMode = .playOnce
        
        if animated == true {
            successAnimationView.play() { [weak self] _ in
                guard let self else { return }
                
                self.successAnimationView.isHidden = true
                self.addToFavoriteButton.isHidden = false
            }
        } else {
            successAnimationView.play() { [weak self] _ in
                guard let self else { return }
                
                self.successAnimationView.isHidden = false
                self.addToFavoriteButton.isHidden = true
            }
        }
    }
    
    private func activityIndicator(animated: Bool) {
        
        if animated == true {
            self.detailsScrollView.isHidden = true
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        } else {
            self.detailsScrollView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    //MARK: - UI Bindings
    
    private func bindTableView() {
        
        let object = detailsViewModel?.details
        guard let object else { return }
        
        object
            .asDriver()
            .drive(onNext: { [weak self] data in
                guard let self else { return }
                
                // Сhecks whether data of the type exists
                if data.status.isEmpty {
                    self.activityIndicator(animated: true)
                } else {
                    self.activityIndicator(animated: false)
                    self.configureDetails(with: data)
                }
            }).disposed(by: disposeBag)
    }
    
    private func loadTrailer() {
        
        let trailerObject = detailsViewModel?.trailerInfo
        guard let trailerObject else { return }
        
        trailerObject
            .asDriver()
            .drive(onNext: { [weak self] info in
                guard let self else { return }
                
                self.trailerPlayerView.load(withVideoId: info.trailerID)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - IBActions
    
    @IBAction func addToFavoriteButtonTapped(_ sender: UIButton) {
        animationView(animated: true)
        
        detailsViewModel?.addFimlToList(with: detailsViewModel?.details.value.id ?? 0)
    }
}
