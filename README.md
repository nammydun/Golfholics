# Golfholics (For Users)
This is an application for golfers to share and store their golf scores online. It allows users to create and edit scores as they play their rounds, and other users can track their live scores. 

### Quickstart
##### Sign Up
Users can sign up with their email address or quick log in with gmail.

##### Log In
Users can log in with their email address or quick log in with gmail.

##### Create Game
Users can press Add Game to create score cards, user then need to select a golf course and game from the list, and the players' names, press create to complete creating a game. 

##### Edit Game
Users can edit scores by clicking the scorecard from the Live Golf tab. 
_Note: As soon as the users edit the score, other users will see the live update of the edited scores from the Live Golf tab._

##### Complete Game
Users can press finish to mark the score card as completed, so the other users will know the score is final. 

##### Profile
User can view their user id and email from the Profile tab.

# Golfholics (For Developers)
This is project stores users' authentication information and golf score cards details into real time firebase, allowing authenticated users to view live scores, create and edit golf scores in real time. 

![IMG_4054.PNG](https://www.dropbox.com/s/x06jsmtinno3gjq/IMG_4054.PNG?dl=0&raw=1)
![IMG_4057.PNG](https://www.dropbox.com/s/2q1rsw2p6t9jp7k/IMG_4057.PNG?dl=0&raw=1)
![IMG_4061.PNG](https://www.dropbox.com/s/03uop9g1wcp62vs/IMG_4061.PNG?dl=0&raw=1)
![IMG_4058.PNG](https://www.dropbox.com/s/hb6wrp1gtg85lhh/IMG_4058.PNG?dl=0&raw=1)
![IMG_4060.PNG](https://www.dropbox.com/s/b4rmjvyfop04xpy/IMG_4060.PNG?dl=0&raw=1)

### Libraries used in this project
- UIKit
- Firebase
- FirebaseAuthUI
- FirebaseGoogleAuthUI
- GoogleSignIn

### Implementation
##### LoginViewController
Set up functions to allow users to sign up and log in through their email address and gmail.


##### LiveGolfViewController
Display all the score cards from firebase created by the authenticated users, each row shows the date created of the score card, golf course, the name and scores of the players, as well as the status of the score card, indicating whether it is Round in Progress or completed. 
_Note: Data will be observed and listened from firebase as the users edit it from EditViewController._


##### AddGameViewController
When Add Game button is pressed in LiveGolfViewController, users will be directed to this view controller to get the basic infomation for a score card to be created, which includes the golf course, game, and the names of the players. Press Create button to add a new node to the firebase and push back to the LiveGolfViewController and display it there.


##### EditScoreCardViewController
The information of the score card selected by the user from LiveGolfViewController will be displayed in details in this view controller. Scores will be observed to listen to any updates made to the scores by clicking the Add or Subtract from each table cell. All updates will then be real time update to the LiveGolfViewController. Finish button can be clicked to mark the round as *Completed*, clicking the Back button will remain the status of the score card as *Round in Progress*

##### ProfileViewController
User ID and User's email will be displayed in this tab / view controller.

### Requirements
###### a. The iOS version
iOS 13.1
###### b. XCode version
Version 11.1
###### c. Swift version
Swift 5

### Firebase Functions for retrieving data
###### `func getAutoIds(completion: @escaping([String]?, Error?) -> Void)`
To get all the keys from scoreCards node

###### `func getScoreCard(autoId: String, completion: @escaping(ScoreCard?, Error?) -> Void)`
To get all the score cards created from Firebase and return a Score Card object

###### `func deleteScoreCards(autoId: String, completion: @escaping(Bool, Error?) -> Void)`
To delete a score card from Firebase

###### `func setCompleteRound(autoId: String, completion: @escaping(Bool, Error?) -> Void)`
To set the score card as completed in Firebase

###### `func getGolfCourses(completion: @escaping([GolfCourse]?, Error?) -> Void)`
To get all the golf courses information from Firebase and return result in an array

###### `func getGolfGames(completion: @escaping([GolfGame]?, Error?) -> Void)`
To get all the golf games information from Firebase and return result in an array

###### `func updateScore(autoId: String, tag: Int, targetScores: String, op: String)`
To update scores from an autoId in Firebase

###### `func addScoreCard(golfCourseTextfield: String, p1Name: String, p2Name: String, p3Name: String, p4Name: String, completion: @escaping(Bool, Error?) -> Void)`
To add a score card to Firebase
