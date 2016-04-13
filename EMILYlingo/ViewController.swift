//
//  ViewController.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 3/31/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import SlideMenuControllerSwift

class ViewController: UIViewController, AVAudioRecorderDelegate {//, EZMicrophoneDelegate {
    
    //------------------------------------------------------------------------------
    // MARK: Properties
    //------------------------------------------------------------------------------
    var phrases: Phrases!
    //@IBOutlet weak var plot: EZAudioPlotGL?;
    //var microphone: EZMicrophone!;
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var savePhraseButton: UIButton!
    @IBOutlet weak var cancelPhraseButton: UIButton!
    
    @IBOutlet weak var languageField: UITextField!

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var genderField: UISegmentedControl!
    
    let realm = try! Realm()
    
    var audioURL: NSURL!
    var recordingSession: AVAudioSession!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder!
    var tempTimer = 0
    var timer = 30
    var count = 2
    var check = false;
    var TimerControl = NSTimer()
    
    var dictionary: [String:String] = [
        "zero" : "zero"
    ]
    //------------------------------------------------------------------------------
    // MARK: Status Bar Style
    //------------------------------------------------------------------------------
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    //------------------------------------------------------------------------------
    // MARK: View Lifecycle
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.hidden = true
        saveButton.hidden = true
        saveView.hidden = true
        //microphone = EZMicrophone(delegate: self, startsImmediately: true);
        //plot?.backgroundColor = UIColor.blackColor()
        //let plotType: EZPlotType = EZPlotType.Buffer
        //plot?.plotType = plotType
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){[unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                    if allowed {
                        self.loadRecordingUI()
                    }else {
                        
                    }
                }
            }
        }catch {
            
        }
        
    }
    
    func loadRecordingUI(){
        if count == 1 {
            check = true
            if let image = UIImage(named: "RecordingOn.png") {
                //plot?.shouldFill = true
                //plot?.shouldMirror = true
                //plot?.resumeDrawing()
                
                TimerControl = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
                count = 2
                RecordButton.setImage(image, forState: .Normal)
                startRecording()
            }
        }else {
            if let image = UIImage(named: "RecordOff.png") {
                //plot?.pauseDrawing()
                count = 1
                tempTimer = timer
                timer = 30
                TimerLabel.text = String(timer)
                TimerControl.invalidate()
                RecordButton.setImage(image, forState: .Normal)
                if(check == true){
                    finishRecording()
                }
            }
        }
    }
    
    func finishRecording(){
        audioRecorder.stop()
        audioRecorder = nil
        RecordButton.hidden = true
        cancelButton.hidden = false
        saveButton.hidden = false
        TimerLabel.hidden = true
        check = false
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: audioURL)
            audioPlayer = sound
            sound.play()
            //RecordButton.enabled = false
            //plot?.resumeDrawing()
        }catch{
            
        }
        //plot?.shouldMirror = false
        //plot?.shouldFill = false
        //plot?.clear()
        
    }
    
    func startRecording(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        //let audioFilename = documentsDirectory.stringByAppendingString("recording.m4a")
        let randomURL = "/"+String.random()
        let audioFilename = documentsDirectory.stringByAppendingString(randomURL + ".m4a")
        audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            //let plotType: EZPlotType = EZPlotType.Buffer
            //plot?.plotType = plotType;
           // plot?.shouldFill = true
            //plot?.shouldMirror = true
            
        }catch {
            finishRecording()
        }
    }
    
    @IBAction func RecordAndStop(sender: AnyObject) {
        loadRecordingUI()
    }
    
    @IBAction func confirmButton(sender: AnyObject) {
        saveButton.hidden = true
        cancelButton.hidden = true
        saveView.hidden = false
        
    }
    @IBAction func discardButton(sender: AnyObject) {
        cancelButton.hidden = true
        saveButton.hidden = true
        RecordButton.hidden = false
        TimerLabel.hidden = false 
    }
    @IBAction func saveButton(sender: AnyObject) {
      
//        dictionary["phraseName"] = nameField.text
//        dictionary["language"] = languageField.text
//        dictionary["time"] = String(30 - timer)
//       
//        dictionary["flag"] = languageField.text
//        switch genderField.selectedSegmentIndex
//        {
//        case 0:
//            dictionary["gender"] = "male"
//        case 1:
//            dictionary["gender"] = "female"
//        default:
//            break;
//        }
//        let audioFileName = audioURL.absoluteString
//        dictionary["url"] = audioFileName
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        saveView.hidden = true
        RecordButton.hidden = false
        TimerLabel.hidden = false
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    func countdown(){
        if(timer >= 0){
            timer = timer - 1
            TimerLabel.text = String(timer)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueIdentifer"{
            saveView.hidden = true
            RecordButton.hidden = false
            TimerLabel.hidden = false
            if let destination = segue.destinationViewController as? PhrasesViewController {
                dictionary["phraseName"] = nameField.text
                dictionary["language"] = languageField.text
                if ((30-tempTimer) >= 10) {
                    dictionary["time"] = "0:"+String(30-tempTimer)
                }else{
                    dictionary["time"] = "0:0"+String(30 - tempTimer)
                }
                
                dictionary["flag"] = languageField.text
                switch genderField.selectedSegmentIndex
                {
                case 0:
                    dictionary["gender"] = "male"
                case 1:
                    dictionary["gender"] = "female"
                default:
                    break;
                }
                let audioFileName = audioURL.lastPathComponent
                dictionary["url"] = audioFileName
                var phrase: Phrases!
                phrase = Phrases(dictionary: dictionary)
                destination.phrase = phrase
                //destination.dictionary = dictionary
                try! realm.write {
                    realm.add(phrase)
                }
            }
           
        
        }
        
    }
    
    
    //------------------------------------------------------------------------------
    // MARK: Actions
    //------------------------------------------------------------------------------
    
    
    //------------------------------------------------------------------------------
    // MARK: EZMicrophoneDelegate
    //------------------------------------------------------------------------------
    
//    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.plot?.updateBuffer(buffer[0], withBufferSize: bufferSize);
//        });
//    }
    
}

extension String {
    
    static func random(length: Int = 8) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}