//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Vince Chan on 5/14/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var currentState:RecorderState = RecorderState.Stop
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        currentState = RecorderState.Stop
        
        stopButton.hidden = true
        statusLabel.text = "Tap to Record"
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        
        switch (currentState) {
        case RecorderState.Stop:
            record()
        case RecorderState.Record:
            pause()
        case RecorderState.Pause:
           resume()
        }
    }
    
    func record() {
        currentState = RecorderState.Record
        statusLabel.text = "Recording. Tap to Pause"
        stopButton.hidden = false
        
        // Determine file path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func pause() {
        currentState = RecorderState.Pause
        statusLabel.text = "Pause. Tap to Resume"
        stopButton.hidden = false
        
        audioRecorder.pause()
    }
    
    func resume() {
        currentState = RecorderState.Record
        statusLabel.text = "Recording. Tap to Pause"
        stopButton.hidden = false
        
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}
