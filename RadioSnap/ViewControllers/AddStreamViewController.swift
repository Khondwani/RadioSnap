//
//  AddStreamViewController.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/17.
//

import UIKit

//Observerable Information // Makes it universably accessible

//let mergedStreamObsverable: MergedStreams = MergedStreams()

// MARK: OUTLETS
class AddStreamViewController: UIViewController {

    @IBOutlet weak var startDateTimePicker: UIDatePicker!
    @IBOutlet weak var endDateTimePicker: UIDatePicker!
    
    let HOURS_24_IN_SECONDS = 86400
    var submissionCount = 0 // Will be used to name the streams
    
}

// MARK: LIFECYCLE

extension AddStreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

//MARK: ACTIONS
extension AddStreamViewController {
    @IBAction func submitSession(_ sender: Any) {
        
        //TODO: Functionality to check if submission is more than 24hrs if so Alert them.
        if !isStreamDurationZero() { // Tells me they are the same
            
            submissionCount += 1 // update the submission count
            // Struct passes by copy Class passes by reference (Thus your bug earlier)
            let newStream = StreamSession(startDateTime: startDateTimePicker.date, endDateTime: endDateTimePicker.date, duration: RadioStreamingFunctions.getDurationBetweenDates(from: startDateTimePicker.date, and: endDateTimePicker.date), streamName: "Stream \(submissionCount)")
            
            // get the key
            let keyForDict = RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStream.startDateTime)
            
            // Add to stream & to mergedStreams
            
            Streams.sharedInstance.addNewStreamSession(key: keyForDict, value: newStream)
            
            Streams.sharedInstance.addToMergedStreamSessions(key: keyForDict, value: newStream)
            
            // Add the array of keys
            if !Streams.sharedInstance.arrayOfKeys.contains(keyForDict) {
                Streams.sharedInstance.arrayOfKeys.append(keyForDict)
            }
          
            showToast(message: "💃🏽 You have successfully submitted a session! 🕺🏾")
            
        } else {
            showAlertDialog(title: "Oops!", message: "Sorry but you need to atleast have 1 minute of streaming time to submit.")
        }
        
//
//        streamObsverable.addToMergedStreamSessions(key: <#T##String#>, value: <#T##StreamSession#>)
        //TODO: Perfrom addition to dictionaries
        
        //TODO: Perform Merges if any exist and update the existingStreams dictionary which will contain the merged times
        
        //TODO: Must update the singleton: Have a flag that shows it is still going through the algorithm.
    }
}

//MARK: HELPER FUNCTIONS
extension AddStreamViewController {
    
    func isStreamDurationMoreThan24hrs() -> Bool {
        if RadioStreamingFunctions.getDurationBetweenDates(from: startDateTimePicker.date, and: endDateTimePicker.date) >= HOURS_24_IN_SECONDS { //Makes sure I get a time less than 24hrs so basically 23:59:59 will be fine
            return true;
            
        } else {
            return false;
        }
    }
    
    func isStreamDurationZero() -> Bool {
        if RadioStreamingFunctions.getDurationBetweenDates(from: startDateTimePicker.date, and: endDateTimePicker.date) <= 0 {
            return true
        } else {
            return false
        }
    }
    
    func showAlertDialog(title:String, message:String) {
        let alertDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertDialog.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alertDialog, animated: true)
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 16)) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width * 0.10 , y: self.view.frame.size.height * 0.7, width: self.view.frame.size.width * 0.8, height: 55))
      
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.numberOfLines = 2
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
