//
//  ViewController.swift
//  Planty
//
//  Created by Gunapandian on 29/03/18.
//  Copyright © 2018 Gunapandian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Outlets With Intial Setup
    @IBOutlet var plantsOverviewBottomConstriant: NSLayoutConstraint!{
        didSet{
            plantsOverviewBottomConstriant.constant = UIScreen.main.bounds.height * 0.20;
        }
    }
    
    @IBOutlet var plantsOverviewHeightConstriant: NSLayoutConstraint!{
        didSet{
            plantsOverviewHeightConstriant.constant = UIScreen.main.bounds.height * 0.25;
            
        }
    }
    
    @IBOutlet var plantsOverview: UIVisualEffectView!{
        didSet{
            plantsOverview.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            plantsOverview.layer.cornerRadius = 8
            plantsOverview.addGestureRecognizer(plantsOverviewPanGesuture)
        }
    }
    
    @IBOutlet var plantDetailView: UIView!{
        didSet{
            plantDetailView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            plantDetailView.layer.cornerRadius = 8
            plantDetailView.layer.shadowOpacity = 5
            plantDetailView.layer.shadowRadius = 20
            plantDetailView.addGestureRecognizer(plantDetailGesture)
        }
    }
    
    @IBOutlet var containerViewHeightConstriant: NSLayoutConstraint!{
        didSet{
            containerViewHeightConstriant.constant = self.screenHeight * 0.25;
        }
    }
    
    @IBOutlet var statusViewHeightConstriant: NSLayoutConstraint!{
        didSet{
            statusViewHeightConstriant.constant = self.screenHeight * 0.25;
        }
    }
    
    @IBOutlet var backgroundScrollView: UIScrollView!{
        didSet{
            backgroundScrollView.contentSize = CGSize(width: 300, height: 500)
            backgroundScrollView.contentOffset = CGPoint(x: 0, y: self.screenHeight * 0.05)
        }
    }
    
    //MARK:- PlantDetail View Outlets
    @IBOutlet var infoLbl: UILabel!
    @IBOutlet var dropletAnimation: UIButton!
    @IBOutlet var dayCounterLbl: UILabel!
    @IBOutlet var dayCounterDetailLbl: UILabel!
    @IBOutlet var wateringInfoLbl: UILabel!
    @IBOutlet var wateringDetailLbl: UILabel!
    @IBOutlet var plantsInfoLbl: UILabel!
    @IBOutlet var temperatureHeaderLbl: UILabel!
    @IBOutlet var humidityHeaderlbl: UILabel!
    @IBOutlet var lightHeaderLbl: UILabel!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var plantsReadyWatering: UILabel!
    @IBOutlet var weeklyLoad: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var monthLbl: UILabel!
    @IBOutlet var graphImageView: UIImageView!
    
    //MARK:- Local properties
    private let screenHeight = UIScreen.main.bounds.height
    private var plantDetailSliderState:SliderState = .Collapse
    private var plantDetailAnimationStack = [UIViewPropertyAnimator]()
//    private var plantsOverviewanimationStack = [UIViewPropertyAnimator]()
    private var plantsOverviewState: SliderState = .Collapse
    private var plantsOverviewanimation:UIViewPropertyAnimator?

    //The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    private var plantsOverviewAnimationProgress = CGFloat()
    private let collectionViewDatasource = [#imageLiteral(resourceName: "image1"),#imageLiteral(resourceName: "image2"),#imageLiteral(resourceName: "image3"),#imageLiteral(resourceName: "image4"),#imageLiteral(resourceName: "green-plant")]
    
    //Pan and tap gesture for Both views
    private lazy var plantDetailGesture: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.cancelsTouchesInView = true
        recognizer.delaysTouchesBegan = true
        recognizer.addTarget(self, action: #selector(plantDetailGestureHandler(recognizer:)))
        return recognizer
    }()
    
    private lazy var plantsOverviewPanGesuture: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.cancelsTouchesInView = true
        recognizer.delaysTouchesBegan = true
        recognizer.addTarget(self, action: #selector(plantsOveriewGestureAction(recognizer:)))
        return recognizer
    }()
    
    override func viewDidLoad() {
        plantsDetailViewChanges(alphaValue: 0)
        PlantOverviewUIChanges(alphaValue: 0)

    }
    
}

//MARK:- CollectionView DataSource
extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return collectionViewDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DummyCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PlantCell", for: indexPath) as! DummyCell
        cell.layer.cornerRadius = 8
        cell.setImage(image: collectionViewDatasource[indexPath.row])
        return cell
        
    }
    
}

//MARK:PlantsOverview Logics and Animations
extension ViewController {
    
    //Change ui elements alpha value for slide up/down
    private func plantsDetailViewChanges(alphaValue:CGFloat)->Void{
        wateringInfoLbl.alpha = alphaValue
        wateringDetailLbl.alpha = alphaValue
        plantsInfoLbl.alpha = alphaValue
        temperatureHeaderLbl.alpha = alphaValue
        humidityHeaderlbl.alpha = alphaValue
        lightHeaderLbl.alpha = alphaValue
        segmentControl.alpha = alphaValue
    }
    
    //Animation functionality logics
    private func animatePlanDetailView(performState:SliderState) -> Void {
        //if collection is empty animation is happning so return
        guard plantDetailAnimationStack.isEmpty else {
            return
        }
        
        //primary animation object
        let primaryAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
            if(performState == .Expand){
                self.statusViewHeightConstriant.constant = self.screenHeight * 0.50;
                self.backgroundScrollView.contentOffset = CGPoint(x: 0, y: self.screenHeight * 0.15)
               self.plantsDetailViewChanges(alphaValue: 1)
            }
            else{
                self.statusViewHeightConstriant.constant = self.screenHeight * 0.25;
                self.backgroundScrollView.contentOffset = CGPoint(x: 0, y: self.screenHeight * 0.10)
                self.containerViewHeightConstriant.constant = self.screenHeight * 0.25;
                self.plantsDetailViewChanges(alphaValue: 0)
            }
            self.view.layoutIfNeeded()
        }
        
        //secondary animation object for jagging motion
        let secondaryAnimation = UIViewPropertyAnimator(duration: 0.5 , curve: .easeIn){
            if(performState == .Expand){
                self.containerViewHeightConstriant.constant = self.screenHeight * 0.50;
            }
            self.view.layoutIfNeeded()
        }
        //for linear animation while panning
        secondaryAnimation.scrubsLinearly = false
        primaryAnimation.scrubsLinearly = false
        
        primaryAnimation.startAnimation()
        secondaryAnimation.startAnimation()
        
        self.plantDetailAnimationStack.append(primaryAnimation)
        self.plantDetailAnimationStack.append(secondaryAnimation)
        
        //Animation completion callback to clean up collection
        primaryAnimation.addCompletion { (pos) in
            if pos == .end{
                self.plantDetailSliderState = self.plantDetailSliderState.opposite
                self.plantDetailAnimationStack.removeAll()
            }
        }
    }
    
    //PlandetailView pan and tap gesture handler
    @objc private func plantDetailGestureHandler(recognizer: UIPanGestureRecognizer) {
        
        switch  recognizer.state {
        case .began:
              //Resign plants overview
              plantsOverviewanimation?.isReversed = (plantsOverviewanimation?.isReversed)!
              if plantDetailSliderState == .Collapse{
                animatePlantsOverviewLayout(performState:.Collapse)
              }
            
            animatePlanDetailView(performState: plantDetailSliderState.opposite)
            plantDetailAnimationStack.forEach{$0.pauseAnimation()}
            
            // keep track of each animator's progress
            animationProgress = plantDetailAnimationStack.map { $0.fractionComplete }
            break
        case .changed:
            // variable setup
            let translation = recognizer.translation(in: plantDetailView)
            var fraction = -translation.y / (self.screenHeight * 50);
            
            // adjust the fraction for the current state and reversed state
            if plantDetailSliderState == .Expand {
                fraction *= -1
            }
            
            if plantDetailAnimationStack[0].isReversed {
                fraction *= -1
            }
            
            // apply the new fraction
            for (index, animator) in plantDetailAnimationStack.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: self.plantDetailView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                plantDetailAnimationStack.forEach{$0.continueAnimation(withTimingParameters: nil, durationFactor: 0)}
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch plantDetailSliderState {
            case .Expand:
                if !shouldClose && !plantDetailAnimationStack[0].isReversed { plantDetailAnimationStack.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && plantDetailAnimationStack[0].isReversed { plantDetailAnimationStack.forEach { $0.isReversed = !$0.isReversed } }
            case .Collapse:
                if shouldClose && !plantDetailAnimationStack[0].isReversed { plantDetailAnimationStack.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && plantDetailAnimationStack[0].isReversed { plantDetailAnimationStack.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            plantDetailAnimationStack.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            ()
        }
    }
    
   
}

//MARK:PlantDetailView Logics and Animations
extension ViewController{
    
    //Hide or show Views
    private func PlantOverviewUIChanges(alphaValue:CGFloat)->Void{
        weeklyLoad.alpha = alphaValue
        dateLbl.alpha = alphaValue
        monthLbl.alpha = alphaValue
        graphImageView.alpha = alphaValue
    }
    
    //Create slide up/down animation for plandetail
    private func animatePlantsOverviewLayout(performState:SliderState) -> Void {
        

        //Create Animation object
         self.plantsOverviewanimation  = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut){
            if(performState == .Expand){
                self.plantsOverviewHeightConstriant.constant = self.screenHeight * 0.60;
                self.PlantOverviewUIChanges(alphaValue: 1)
                self.backgroundScrollView.contentOffset = CGPoint(x: 0, y: self.screenHeight * 0.05)

            }
            else{
                self.plantsOverviewHeightConstriant.constant = self.screenHeight * 0.25;
                self.PlantOverviewUIChanges(alphaValue: 0)
                self.backgroundScrollView.contentOffset = CGPoint(x: 0, y: self.screenHeight * 0.10)

            }
            self.view.layoutIfNeeded()
        }
        
        //for linear animation during panning the view
        self.plantsOverviewanimation?.scrubsLinearly = false

        self.plantsOverviewanimation?.startAnimation()
        
        self.plantsOverviewanimation?.addCompletion { (pos) in
            //Change slider state
            if(pos == .end) {
                self.plantsOverviewState = self.plantsOverviewState.opposite
            }
        }
    }
    
    //Handel Pan or Tap gesture action
    @objc private func plantsOveriewGestureAction(recognizer: UIPanGestureRecognizer){
        
        switch  recognizer.state {
        case .began:
            animatePlantsOverviewLayout(performState:plantsOverviewState.opposite)
            plantsOverviewanimation?.pauseAnimation()
            
            // keep track of each animator's progress
            plantsOverviewAnimationProgress =  (plantsOverviewanimation?.fractionComplete)!
            break
        case .changed:
            // variable setup
            let translation = recognizer.translation(in: plantsOverview)
            var fraction =  -translation.y / (self.screenHeight * 0.60);
            
            // adjust the fraction for the current state and reversed state
            if plantsOverviewState == .Expand
            {
                fraction = fraction * -1
            }
            if  (plantsOverviewanimation?.isReversed)! {
                fraction = fraction * -1
            }
            
            // apply the new fraction
            plantsOverviewanimation?.fractionComplete = fraction + plantsOverviewAnimationProgress
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: self.plantsOverview).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                plantsOverviewanimation!.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch plantsOverviewState {
            case .Expand:
                if !shouldClose && !plantsOverviewanimation!.isReversed { plantsOverviewanimation!.isReversed = !plantsOverviewanimation!.isReversed }
                if shouldClose && plantsOverviewanimation!.isReversed { plantsOverviewanimation!.isReversed = !plantsOverviewanimation!.isReversed }
            case .Collapse:
                if shouldClose && !plantsOverviewanimation!.isReversed { plantsOverviewanimation!.isReversed = !plantsOverviewanimation!.isReversed }
                if !shouldClose && plantsOverviewanimation!.isReversed { plantsOverviewanimation!.isReversed = !plantsOverviewanimation!.isReversed }
            }
            
            // continue all animations
          plantsOverviewanimation!.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
}
