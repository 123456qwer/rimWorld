//
//  GameViewController.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import UIKit
import SpriteKit
import GameplayKit
import SnapKit


class GameViewController: UIViewController {
    
    var gameScene:BaseScene!
    
    var bottomActionBar:BottomActionBar = BottomActionBar()
    var bottomActionBarVM:BottomActionBarVM = BottomActionBarVM()
    var bottomOperationView:OperationView = OperationView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
        
    }
    
    func start (){
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let name = "GameScene"
            //            let name = "TestScene"
            if let scene = GameScene(fileNamed: name) {
                // Set the scale mode to scale to fit the window
                
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                gameScene = scene
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            /// 捏合手势
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            view.addGestureRecognizer(pinch)
        }
        
        
        setupUI()
        setupLayout()
        bindAction()
    }
    
    /// 捏合手势
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        gameScene?.handlePinch(gesture)
    }
    
    /// 保存
    @objc func saveAction() {
        gameScene.ecsManager.saveEntity()
    }
    
    
    func setupUI(){
        
        view.addSubview(bottomActionBar)
        view.addSubview(bottomOperationView)
        view.addSubview(saveButton)
//        bottomActionBar.backgroundColor = .orange
//        bottomOperationView.backgroundColor = .cyan
        
    }
    
   
    
    func setupLayout(){
        
        bottomActionBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.trailing.equalToSuperview().offset(kSafeLeft)
            make.height.equalTo(kBottomActionBarHeight)
        }
        
        bottomOperationView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomActionBar.snp.top)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(150)
            make.width.equalTo(UIScreen.screenWidth / 5.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.trailing.equalToSuperview().offset(-12.0)
            make.width.equalTo(50.0)
            make.height.equalTo(44.0)
        }
    }
    
    
    func bindAction(){
        bottomActionBarVM.bindAction(bottomActionBar,
                                     gameContext: gameScene.gameContext)
    }
    
    
    
    lazy var saveButton:UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        btn.setTitle(textAction("保存"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .green
        return btn
    }()
    
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
