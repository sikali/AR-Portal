//
//  ViewController.swift
//  realm
//
//  Created by Alex Ali on 8/31/17.
//  Copyright © 2017 Alex Ali. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        

}
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        //Set plane detection to Horizontal to detect horizontal planes
        configuration.planeDetection = .horizontal
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    //THIS METHOD GETS CALLED WHEN TOUCHES ARE DETECTED ON SCREEN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //First touch on the screen
        
        if let touch =  touches.first {
            
            //Touch has to be on grid so you have to also checks
            
            //gives exact location of where we touched on 2d screen
            let touchLocation = touch.location(in: sceneView)
            
            //Need to convert 2D coords to 3D coords
            //hitTest is performed to get the 3D coordinates corresponding to the
            // 2D coordinates that we got from touching the screen
            
            //The 3D location will only be considered when it is on the existing plane that we created
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            //Check if results contain a value from hitTest
            //SETS BOX TO WHERE TOUCHED ON SCREEN
            if let hitResult = results.first {
                
                //ACCESSES THE FILE AND THEN ACCESSES BOX
                
                let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
                
                
                // 1 ) MAKES BOX
                if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true){
                    
                    
                    //2 ) SETS BOX TO THE HITRESULTS WHICH IS WHERE IT WAS TOUCHED ON SCREEN
                    //SETS POSITION
                    boxNode.position = SCNVector3(x:
                        hitResult.worldTransform.columns.3.x, y://ADD HALF OF Y-COORD OF BOX TO SHIFT IT UP
                        hitResult.worldTransform.columns.3.y - 0.5, z:
                        hitResult.worldTransform.columns.3.z)
                    
                    //3 ) FINALLY ADD BOX TO THE SCENE
                    sceneView.scene.rootNode.addChildNode(boxNode)
                    
                    
                    
                    
                    
                   
                    
                    
                    
                    
                }
                
            }
            
        }
    }
    
    
    
    
    
    
    
    // This is a delegate method which comes from ARSCNViewDelegate, and this method is called when
    // a horizontal plane is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            //anchors can be of many types, as we are dealing with horizontal plane detection
            // we need to downcast anchor to ARPlaneAnchor
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            //Creating a plane geometry with the help of dimensions we get using plane anchor
            //CREATES THE PLANES
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            
            //1 POSITION
            // a Node is a position. ( A 3-D object in space)
            let planeNode = SCNNode()
            
            //2 SETTING POSITION OF THE PLANE
            //setting the position of the plane geometry to the position we got using plane anchor
            
                                            //X coord = to plane detected  //y = 0  so sticks ground
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
                                                                        //Z coord = to plane detected
            //3 ROTATE PLANE TO X-AXIS
            //When plane is created its created in xy plane instead of xz plane, so we need to rotate
            // along the X-Axis
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2,1,0,0)
            
            
            //create material object
            let gridMaterial = SCNMaterial()
            
            
            //Setting the material to image. A material can also be set to a color as well
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            //Assigning the material to the plane
            plane.materials = [gridMaterial]
            
            //Assigns the position to the plane
            planeNode.geometry = plane
            
            //adding the plane node to the scene
            node.addChildNode(planeNode)
            
            
            
            
            
            
        }
        else {
            
            
            
                return
        }
        
        
    }
    
  
}
