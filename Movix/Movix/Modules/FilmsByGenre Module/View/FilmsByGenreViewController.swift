//
//  FilmsByGenreViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

class FilmsByGenreViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var filmsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinator: FilmsByGenreCoordinator?
    var filmsViewModel: FilmsByGenreProtocol?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinator?.didFinishFilms()
    }

    //MARK: - UI Configuration functions
    
    private func configureUI() {
        
        title = filmsViewModel?.genreInfo?.genreName
        
        bindTableView()
        filmsViewModel?.getFilms()
    }
    
    // Checks whether the data has been uploaded
    private func isData(loaded: Bool) {
        
        if loaded == true {
            self.filmsTableView.isHidden = true
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
        } else {
            self.filmsTableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    private func createActivityIndicator() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
    
        spinner.startAnimating()
        
        return footerView
    }
    
    //MARK: - UI Bindings
    
    private func bindTableView() {
        
        let object = filmsViewModel?.filmsArray
        guard let object else { return }
        
        object
            .asDriver()
            .drive(onNext: { [weak self] value in
            guard let self else { return }
            
            self.isData(loaded: value.isEmpty)
        }).disposed(by: disposeBag)
        
        object
            .asDriver()
            .drive(filmsTableView
                .rx
                .items(cellIdentifier: K.Identifiers.filmsByGenreCell,
                       cellType: FilmsByGenreTableViewCell.self)) { _, films, cell in
                
                cell.selectionStyle = .none
                cell.configureCell(with: films)
            }.disposed(by: disposeBag)
        
        // Notifies which object in has been selected in the TableView
        filmsTableView.rx.modelSelected(FilmsListModel.self)
            .asDriver()
            .drive(onNext:  { [weak self] value in
            guard let self else { return }
            
            self.coordinator?.parentCoordinator?.goToDetails(with: value.id)
        }).disposed(by: disposeBag)
    }
}

extension FilmsByGenreViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // Pagination function
        filmsViewModel?.fetchMoreFilms(index: indexPath.row, tableView: tableView, activityInticator: createActivityIndicator())
    }
}
