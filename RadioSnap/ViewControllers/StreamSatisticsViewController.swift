//
//  StreamSatisticsViewController.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/17.
//

import UIKit
import SwiftUI

class StreamSatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let statisticsView = StreamStatisticsSwiftViewUI()
        let hostingViewController = UIHostingController(rootView: statisticsView)
        //add it as a childview so that I have it in my tabview
        
        self.addChild(hostingViewController)
//        hostingViewController.sizingOptions = .preferredContentSize
        // Can go the frame route
        hostingViewController.view.frame = self.view.frame
        self.view.addSubview(hostingViewController.view)
        // Use the UIViewController size!
        hostingViewController.didMove(toParent: self)
        
       // Or Go the NsConstraints route
        // Without the constraints the view was not showing
//        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false;
//        NSLayoutConstraint.activate([
//            hostingViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            hostingViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
//            hostingViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            hostingViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//               ])
    }
    

    
}
