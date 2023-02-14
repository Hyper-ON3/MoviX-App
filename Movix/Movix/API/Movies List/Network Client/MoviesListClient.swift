//
//  MoviesListClient.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Alamofire
import RxSwift

class MoviesListClient {

    private static func performRequest<T: Codable>(route: MoviesListEndpoint,
                                                   model: T.Type,
                                                   completion: @escaping (T) -> Void) -> DataRequest {
        
        return AF.request(route).responseDecodable(of: model.self) { response in
            
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func checkItemStatus(with movieId: Int, completion: @escaping ((Bool) -> Void)) {
        
        let _ = performRequest(route: .checkItemStatus(moviewId: movieId),
                       model: ItemListStatusModel.self) { data in
            
            completion(data.itemPresent ?? false)
        }
    }
    
    static func addFilmToList(id: Int) {
        
        checkItemStatus(with: id) { value in
            
            if value == false {
                
                let _ = performRequest(route: .addFilmToList(id: id), model: ValidationModel.self, completion: { data in
                    
                    print(data.success ?? "")
                })
                
            } else {
                return
            }
        }
    }
    
    static func getMoviesListDetails() -> Observable<MoviesListDetailsModel?> {
        
        return Observable.create { observer in
            
            let request = performRequest(route: .getMoviesListDetails,
                           model: MoviesListDetailsModel.self) { data in
                
                observer.onNext(data)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func removeMovie(with id: Int) {
        
        let _ = performRequest(route: .removeMovie(id: id), model: ItemListStatusModel.self) { data in
            
            print(data.success ?? "")
        }
    }
}
