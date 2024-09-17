//
//  AddStreamViewController.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/17.
//

import UIKit

//Observerable Information // Makes it universably accessible
let streamObsverable: Streams = Streams()

// MARK: OUTLETS
class AddStreamViewController: UIViewController {

    @IBOutlet weak var startDateTimePicker: UIDatePicker!
    @IBOutlet weak var endDateTimePicker: UIDatePicker!
    
    let HOURS_24_IN_SECONDS = 86400
    
    
}

// MARK: LIFECYCLE

extension AddStreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("We create our Singleton here! Since it only loads once!")
    }
}

//MARK: ACTIONS
extension AddStreamViewController {
    @IBAction func submitSession(_ sender: Any) {
        
        //TODO: Functionality to check if submission is more than 24hrs if so Alert them.
        
//        let keyForDict = RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: <#T##Date#>)
//        streamObsverable.addNewStreamSession(key: <#T##String#>, value: <#T##StreamSession#>)
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
        if RadioStreamingFunctions.getDurationBetweenDates(from: startDateTimePicker.date, and: endDateTimePicker.date) == 0 {
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
}
