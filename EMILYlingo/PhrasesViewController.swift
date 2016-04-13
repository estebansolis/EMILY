//
//  PhrasesViewController.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 4/4/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class PhrasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var phrases = [Phrases]()
    
    @IBOutlet weak var recordPageButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var dictionary: [String:String]!
    var phrase: Phrases!
    var audioPlayer: AVAudioPlayer?
    let realm = try! Realm()
<<<<<<< HEAD
    
=======
    var soundFileURL: NSURL!
    var count = 1
    var sound: AVAudioPlayer?
    
    var searchActive : Bool = false
    var filtered:[Phrases] = []
    
    @IBOutlet weak var searchPhraseBar: UISearchBar!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var currentTimer: UILabel!
>>>>>>> 72576503f59447f2dd14143f243f7453ee4c1ec6
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        searchPhraseBar.delegate = self
//        dictionary["phraseName"] = "Sit Down"
//        dictionary["language"] = "Arabic"
//        dictionary["time"] = "5"
//        dictionary["flag"] = "usflag"
//        dictionary["gender"] = "male"
//        phrases.append(Phrases(dictionary: dictionary)!)
        loadPhrases()
        tableView.reloadData()
        // Do any additional setup after loading the view.
        
        // slide bar menu
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhrases(){
        // query realm and add it to our phrase array to view 
        let ph = realm.objects(Phrases)
        
        phrases = Array(ph)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return phrases.count
 
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhrasesCell", forIndexPath: indexPath) as! PhrasesCell
        if(searchActive){
            cell.phrase = filtered[indexPath.row]
        }else {
            cell.phrase = phrases[indexPath.row]
        }
        //cell.phrase = phrases[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row;
        let cell = phrases[row]
        let toAppendString = cell.url!
        let label = cell.phraseName!
        let duration = cell.time!
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        soundFileURL = documentsDirectory.URLByAppendingPathComponent(toAppendString)
        do {
            phraseLabel.text = label
            if Int(duration) < 10 {
                totalDuration.text = "0:0"+duration
            }else{
                totalDuration.text = "0:"+duration
            }
            //totalDuration.text = duration
            sound = try AVAudioPlayer(contentsOfURL: soundFileURL)
            audioPlayer = sound
            sound!.play()
            NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(PhrasesViewController.updateAudioProgressView), userInfo: nil, repeats: true)
            // sound.pause()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        filtered = phrases.filter({ (text) -> Bool in
            let tmp: NSString = String(text)
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false
        }else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    @IBAction func playButtonAction(sender: AnyObject) {
        if(count == 1){
            count = 2
            sound!.pause()
        }
        else{
            count = 1
            sound!.play()
        }
    }

<<<<<<< HEAD
/*
=======
    func updateAudioProgressView(){
        if ((audioPlayer?.playing) != nil) {
            if (Int((sound?.currentTime)!)) < 10 {
                currentTimer.text = "0:0"+String(Int((sound?.currentTime)!))
            }else {
                currentTimer.text = "0:"+String(Int((sound?.currentTime)!))
            }
            progress.setProgress(Float((sound?.currentTime)!/(sound?.duration)!), animated: true)
        }
    }
    /*
>>>>>>> 72576503f59447f2dd14143f243f7453ee4c1ec6
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    
}
