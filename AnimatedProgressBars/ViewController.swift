//
//  ViewController.swift
//  AnimatedProgressBars
//
//  Created by Ayman Zeine on 8/10/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    let shapeLayer = CAShapeLayer()
    
    var pulsatingLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.white
        
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func createShapeLayer(_ circularPath: UIBezierPath) {
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.lineWidth = 10
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        shapeLayer.position = view.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    fileprivate func createPulsatingLayer(_ circularPath: UIBezierPath) {
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = UIColor.pulsatingFillColor.cgColor
        
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
    }
    
    fileprivate func createTrackLayer(_ trackLayer: CAShapeLayer, _ circularPath: UIBezierPath) {
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.black.cgColor
        
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = UIColor.bgColor
        
        //progress bar layer
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        createPulsatingLayer(circularPath) //create pulsating layer
        view.layer.addSublayer(pulsatingLayer)
        
        //track layer
        let trackLayer = CAShapeLayer()
        createTrackLayer(trackLayer, circularPath) //create track layer
        
        view.layer.addSublayer(trackLayer)
        
        animatePulsatingLayer() //animate pulsating layer
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        createShapeLayer(circularPath) //create shape layer
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
        
        
    }
    
    @objc private func handleTap() {
        
        beginDownloadingFile()
        
        //animateCircle()
    }
    
    private func beginDownloadingFile() {
        print("attempting to download")
        
        shapeLayer.strokeEnd = 0
        
        //sample url
        let url = "https://cdn.zeplin.io/5a5f7e1b4f9f24b874e0f19f/screens/C850B103-B8C5-4518-8631-168BB42FFBBD.png"
        
        let config = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        
        
        guard let urlString = URL(string: url) else {
            print("could not retrieve url string")
            return
        }
        
        let downloadTask = urlSession.downloadTask(with: urlString)
        downloadTask.resume()
    
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage*100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished downloading file")
    }
    
    
    //not used
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards //required for animation persistence
        
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicStroke")
    }
}

