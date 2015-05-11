//
//  LoginViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/6/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire
import EZAudio

class LoginViewController: UIViewController, EZMicrophoneDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var audioAnimationView: UIView!
    var alertView = UIAlertView(title: "Please try again", message: "", delegate: nil, cancelButtonTitle: "OK")
//    let audioPlot = EZAudioPlot(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 30.0))

    
    // MARK: - UIViewContorlle Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Direct user to usernameTextField imidietly */
        usernameTextField.becomeFirstResponder()
        
//        /* Cusotmize audio plot */
//        audioPlot.backgroundColor = UIColor(red: 0.984, green: 0.71, blue: 0.365, alpha: 1.0)
//        audioPlot.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        audioPlot.plotType = .Rolling
//        audioPlot.shouldFill = true
//        audioPlot.shouldMirror = true
        
//        /* Creating and configuring microfon */
//        let microphone = EZMicrophone()
//        microphone.microphoneDelegate = self
//        
//        /* Start fetching audio */
//        microphone.startFetchingAudio()
//        
//        /* Add audio animation */
//        self.audioAnimationView.addSubview(audioPlot)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonAction(sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let url = "https://api.metalmind.rocks/v1/authenticate"
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON).responseJSON { (_, response, jsonObject, error) in
//            println(response!)
            println(jsonObject!)
            
            if error == nil {
                if let token = jsonObject!.objectForKey("token") as? String {
                    let keychainError = Locksmith.saveData(["token": token], forUserAccount: "MetalMindUserAccount")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.alertView.message = jsonObject!.objectForKey("message") as? String
                    self.alertView.show()
                }
            }
        }
    }
    
//    // MARK: - EZMicrophoneDelegate
//    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
//        dispatch_async(dispatch_get_main_queue()) {
//            self.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
//        }
//    }
}