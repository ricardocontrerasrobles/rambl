//
//  MainViewController.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/14/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController
{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var playingLabel: UILabel!
    let viewModel = MainViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @IBAction func startRecording(_ sender: Any)
    {
        viewModel.startRecording()
    }
    @IBAction func stopRecording(_ sender: Any)
    {
        viewModel.stopRecording()
    }
}

private extension MainViewController
{
    func setup()
    {
        playingView.isHidden = true
//        self.map.isUserInteractionEnabled = false
        self.map.delegate = self
        viewModel.updateMap = { [weak self] (region, rambls) in
            self?.map.region = region
            if let rambls = rambls
            {
                self?.addAnnotations(rambls: rambls)
            }
        }
        
        viewModel.statusBinding = { [weak self] (status) in
            switch status
            {
            case .Playing:
                self?.playingView.backgroundColor = .green
            case .Loading:
                self?.playingView.backgroundColor = .yellow
            case .Finished:
                self?.playingView.backgroundColor = .red
            }
        }
    }
    
    func addAnnotations(rambls:[Rambl])
    {
        for rambl in rambls
        {
            let annotation = RamblMKPointAnnotation()
            annotation.rambl = rambl
            annotation.coordinate = CLLocationCoordinate2D(latitude: rambl.latitude, longitude: rambl.longitude)
            annotation.title = rambl.status
            map.addAnnotation(annotation)
        }
    }
    
    func playing(rambl: Rambl)
    {
        if playingView.isHidden
        {
            playingView.isHidden = false
        }
        playingLabel.text = rambl.locationName + ": " + rambl.status
    }
}

extension MainViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let annotation = annotation as? RamblMKPointAnnotation else
        {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? RamblMKPinAnnotationView
        if pinView == nil {
            pinView = RamblMKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = false
            pinView?.pinTintColor = .red
            pinView?.rambl = annotation.rambl
        }
        else
        {
            pinView?.annotation = annotation
            pinView?.rambl = annotation.rambl
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard let ramblMapView = view as? RamblMKPinAnnotationView else
        {
            return
        }
        if let rambl = ramblMapView.rambl
        {
            viewModel.play(contribution: rambl)
            playing(rambl: rambl)
        }
    }
}
