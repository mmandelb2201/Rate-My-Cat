//
//  VideoViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 11/27/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import UserNotifications

class VideoViewController: UIViewController {
    
    @IBOutlet weak var petsButton: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var numberOfLikes: UILabel!
    
    @IBOutlet weak var videoPlayer: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var tapController: UITapGestureRecognizer!
    
    let db = Firestore.firestore()
    var currentVideo : video = video(Title: "", Url: "google.com", OwnerID: "", Likes: 0, Dislikes: 0, IsAlreadyRated: 0)
    var isVideoPlayerSetUp : Bool = false
    var player : AVPlayer = AVPlayer(playerItem: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideoData()
        // Do any additional setup after loading the view.
    }
    //collect video metadata from firebase
    func loadVideoData(){
        db.collection("videos").getDocuments { (snapshot, err) in
            //check to see if errors
            if err != nil {
                print("error: \(err?.localizedDescription)")
                self.showError(error: "There was an error collecting video data: \(err?.localizedDescription ?? "")")
            }else{
                //collect video metadata and place it into the videos array
                for document in snapshot!.documents{
                    let title = document.get("title")
                    let url = document.get("url")
                    let ownerID = document.get("ownerID")
                    let likes = document.get("likes")
                    let dislikes = document.get("dislikes")
                    if title == nil || url == nil || ownerID == nil || likes == nil || dislikes == nil {
                    }else{
                        let tempVideo : video = video(Title: title as! String, Url: url as! String, OwnerID: ownerID as! String, Likes: likes as! Int, Dislikes: dislikes as! Int, IsAlreadyRated: 0)
                        Utilities.globalVariables.videos.append(tempVideo)
                        if Utilities.globalVariables.videos.count > 0 {
                            self.showVideo()
                        }
                    }
                }
            }
        }
        
    }
    //show current video
    func showVideo(){
        if Utilities.globalVariables.videoIndex < Utilities.globalVariables.videos.count{
            self.currentVideo = Utilities.globalVariables.videos[Utilities.globalVariables.videoIndex]
            guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/rate-my-cat-1c93c.appspot.com/o/videos%2FFF8C49AF-C904-4823-9C14-C2E6DBCFD118.mov?alt=media&token=866973e7-0439-4109-bc7d-1863349751e7") else {
                return
            }
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
            let controller = AVPlayerViewController()
            let playerLayer = AVPlayerLayer(player: self.player)
            self.videoPlayer.layer.addSublayer(playerLayer)
            playerLayer.frame = self.videoPlayer.layer.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resize
            player.play()
        }else{
            //change to next video if possible
        }
        
    }
    //show user there is an error
    func showError(error: String){
        var alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAct) in
            self.transitionToCatScreen()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func accountButtonTap(_ sender: Any) {
        let temp = Auth.auth().currentUser
        if temp == nil{
            transitionToSignInSecond()
        }else{
            transitionToAccountScreen()
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
    }
    
    func transitionToSignInSecond(){
        let secondSignInViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInSecondViewController) as? secondSignInViewController
        
        view.window?.rootViewController = secondSignInViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToAccountScreen(){
        let accountViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.accountViewController) as? AccountViewController
        
        view.window?.rootViewController = accountViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToCatScreen(){
        let catViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.catViewController) as? CatViewController
        
        view.window?.rootViewController = catViewController
        view.window?.makeKeyAndVisible()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class video {
    
    var title : String
    var url : URL
    var ownerID : String
    var likes : Int
    var dislikes : Int
    var isAlreadyRated : Int
    
    init(Title : String, Url : String, OwnerID : String, Likes : Int, Dislikes : Int, IsAlreadyRated : Int) {
        title = Title
        url = URL(string: Url)!
        ownerID = OwnerID
        likes = Likes
        dislikes = Dislikes
        //0 - not rated yet
        //1 - user liked the video
        //2 - user disliked the video
        isAlreadyRated = IsAlreadyRated
        
        return
    }
    
    @IBAction func videoTapped(_ sender: Any) {
    }
}
