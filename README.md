MoviX App
MoviX is a mobile application created using Swift that utilizes the MVVM + Coordinator architecture pattern. It uses various third-party libraries such as Alamofire, SDWebImage, Realm, RxSwift, and Lottie to provide users with a seamless and intuitive movie browsing experience.

Features
Movie search: Users can search for movies by title or keywords, and the app will display the relevant results.
Top-rated and newly released movies: Users can browse through a list of top-rated and newly released movies.
Movie details: The app displays movie details such as a brief description, release date, rating, and cast. Users can also watch trailers of the movie.
Favorites: Users can save movies to their favorites list and access them easily.
Technology Stack
The following technologies were used to build the MoviX App:

MVVM + Coordinator architecture: This architecture pattern helps separate the presentation logic from the business logic, making the code more modular and easier to maintain.
Alamofire: This library simplifies network requests, making it easy to fetch data from remote APIs.
SDWebImage: This library provides asynchronous image downloading and caching, making it easy to load images into the app.
Realm: This library provides a fast, lightweight, and easy-to-use database to store movie data, including favorites.
RxSwift: This reactive programming library provides an elegant and powerful way to handle data flow between different components of the app.
Lottie: This library provides high-quality animations for the app, enhancing the user experience.
Installation
Clone or download the repository to your local machine.
Open the MoviX.xcodeproj file in Xcode.
Install the third-party libraries using CocoaPods.
Build and run the app on a simulator or a physical device.
Usage
After launching the application, users are presented with the main screen, which includes a horizontal list of genres, a list of now playing movies, popular, top rating, upcoming movies. Tab bar with buttons for quick access to the search screen and the screen of favorite movies. Users can search for movies by entering the title or keywords in the search bar. The application will display the relevant results. Users can click on a movie to view its details, including description, status, rating, and trailer. They can also add a movie to their favorites list by clicking on the appropriate button.

Credits
The app uses the The Movie Database (TMDb) API to fetch movie data. The app also uses various third-party libraries such as Alamofire, SDWebImage, Realm, RxSwift, and Lottie.

License
MoviX is licensed under the MIT License.
