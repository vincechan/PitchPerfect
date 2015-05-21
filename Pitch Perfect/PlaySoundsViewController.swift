//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Vince Chan on 5/15/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.enabled = false
    }

    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(sender: AnyObject) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeRoom)
        reverbEffect.wetDryMix = 80
        playAudioWithEffect(reverbEffect)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        var delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = 0.5
        playAudioWithEffect(delayEffect)
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        audioEngine.reset()
        audioEngine.stop()
        
        audioPlayer.stop()
        // reset the audio to start
        // this is consistent with the chipmunk and darthvarder effect
        audioPlayer.currentTime = 0
        
        stopButton.enabled = false
    }
    
    func playAudioWithVariableRate(rate: Float) {
        stopPlaying(self)
        
        audioPlayer.rate = rate
        audioPlayer.play()
        
        stopButton.enabled = true
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        
        playAudioWithEffect(pitchEffect)
    }
    
    func playAudioWithEffect(effect: AVAudioNode) {
        stopPlaying(self)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        stopButton.enabled = true
    }
    
}
