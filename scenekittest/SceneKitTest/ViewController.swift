//
//  ViewController.swift
//  MacCatalystSceneKit
//
//  Created by Dat vu on 18/10/2021.
//

import UIKit
import SceneKit
import AEXML

class ViewController: UIViewController {
    
    // MARK: - IBoutlets
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var configureTableView: UITableView!
    @IBOutlet weak var configureView: UIView!
    @IBOutlet weak var configureButton: UIButton!
    
    // MARK: - Constraints
    @IBOutlet weak var containerViewBottomCS: NSLayoutConstraint!
    @IBOutlet weak var sceneViewLeadingCS: NSLayoutConstraint!
    @IBOutlet weak var Trailing_CS_ConfigureButton: NSLayoutConstraint!
    @IBOutlet weak var Bottom_CS_ConfigureView: NSLayoutConstraint!
    @IBOutlet weak var Bottom_CS_ConfigureButton: NSLayoutConstraint!
    
    var listButton: [SCNNode] = []
    var cameraNode = SCNNode()
    var buttonConfigure: SCNNode!
    var box: (min: SCNVector3, max: SCNVector3)!
    
    let geometryButtonList: [(Float, Float, Float, CGFloat, CGFloat, CGFloat)] = [
        (0.13, 0.4, 0.6, 20, 13, 0.5),
        (-0.3, 0.1, 0.45, 16, 12, 0.5),
        (0.13, 0.12, 0.45, 16, 12, 0.5),
        (-0.17, 0.4, 0.45, 3, 13, 0.5),
        (-0.55, 0.11, 0.0, 0.5, 12, 14)
    ]
    
    let sceneFileName = "Ecopark-1.obj"
    private var keyboardHeight: CGFloat = 0.0
    var stateConfigure = StateConfigure.hide
    let listHeaderTitle = ["Position", "Size"]
    let listCellType: [[CellType]] = [[.picker, .picker, .picker], [.select, .picker, .picker, .picker]]
    var listCellTitle: [[String]] = [["x", "y", "z"], ["Side", "Width", "Height", ""]]
    let listAxisOfSideDescription: [String] = ["x", "y", "z"]
    var tagTextFieldChanging = 10
    
    // Matrix render
//    [[1, 1, 0]
//    [0, 1, 1]
//    [-1, 1, 0]
//    [0, -1, 1]
//    [-1, 0, -1]]
    let listAxisParameterForSide = [
        [1, 1, 0],
        [0, 1, 1],
        [-1, 1, 0],
        [0, 1, -1],
        [1, 0, -1]
    ]
    
    var side = 1
    var outputDataOfConfigureFrom = [[CGFloat(1), CGFloat(0), CGFloat(0)], [CGFloat(1), CGFloat(50), CGFloat(50)]] {
        willSet {
        }
        didSet {
            updateScene()
        }
    }
    
    

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureKeyboard()
        
        // MARK: - Set up Scene
        // 1: Load .obj file
        guard let scene = SCNScene(named: sceneFileName) else {
            print("Cannot load scene: \(sceneFileName)")
            return
        }
        
        // MARK: - Configure Scene
        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true
        
        // Restrict scroll of axis
//        sceneView.defaultCameraController.interactionMode = .orbitTurntable
//        sceneView.defaultCameraController.inertiaEnabled = true
//        sceneView.defaultCameraController.maximumVerticalAngle = 20
//        sceneView.defaultCameraController.minimumVerticalAngle = 20
        
        // Show FPS logs and timming
//        sceneView.showsStatistics = true
        
        // Set background color
        if #available(iOS 13.0, *) {
            sceneView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            sceneView.backgroundColor = .white
        }
        
        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = true
        
        // MARK: - Set up properties
        box = scene.rootNode.boundingBox
        
        
        
        // MARK: - Set up Camera
        // 2: Add camera node
        cameraNode.camera = SCNCamera()
        
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 2, y: 0, z: 200)
        cameraNode.camera?.zFar += 200
        
        // 4: Set camera on scene
        scene.rootNode.addChildNode(cameraNode)
        
        // MARK: - Set up Light
        // 5: Adding light to scene
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light?.type = .omni
        lightNode1.position = SCNVector3(x: 0, y: 10, z: 35)
        scene.rootNode.addChildNode(lightNode1)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light?.type = .omni
        lightNode2.position = SCNVector3(x: -50, y: 10, z: 0)
        scene.rootNode.addChildNode(lightNode2)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
//        sceneView.autoenablesDefaultLi.ghting = true
        
        // MARK: - Sample code create Button 1 with UITapGestureRecognizer - Sample code
        // 7: Add button to scene and add tap regcognizer to scene
//        scene?.rootNode.addChildNode(button)
//        let tapRecognizer = UITapGestureRecognizer()
//            tapRecognizer.numberOfTapsRequired = 1
//            tapRecognizer.numberOfTouches Required = 1
//        tapRecognizer.addTarget(self, action: #selector(sceneTapped))
//            sceneView.gestureRecognizers = [tapRecognizer]
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.numberOfTapsRequired = 1
//        tapRecognizer.numberOfTouchesRequired = 1
//        tapRecognizer.addTarget(self, action: #selector(sceneTapped))
//        sceneView.gestureRecognizers = [tapRecognizer]
        
        
        // MARK: - Gesture handler
        // Place these two lines of code where your sceneView is initialize or its properties are set.
//        var pinchRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinchGesture))
//        pinchRecognizer.numberOfTapsRequired = 2
//        sceneView.addGestureRecognizer(pinchRecognizer)
        
        
        
        // MARK: - Sample code create Button 2
//        let buttonGeometry2 = SCNBox(width: 16, height: 16, length: 1, chamferRadius: 0)
//        let buttonMaterial2 = SCNMaterial()
//        buttonMaterial2.diffuse.contents = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
//        buttonGeometry2.materials = [buttonMaterial2]
//
//        var buttonx: SCNNode!
//        buttonx = SCNNode(geometry: buttonGeometry2)
//        buttonx.position = SCNVector3(x: -0.3 * Float((box.max.x - box.min.x)) / 2, y: Float(box.max.y - box.min.y) * 0.1, z: 0.53 * Float(box.max.z - box.min.z) / 2)
//        scene.rootNode.addChildNode(buttonx)
//        listButton.append(buttonx)
        
//        let buttonGeometry2 = SCNBox(width: 1, height: CGFloat(box.max.y - box.min.y), length: CGFloat(box.max.z - box.min.z), chamferRadius: 0)
//        let buttonMaterial2 = SCNMaterial()
//        buttonMaterial2.diffuse.contents = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
//        buttonGeometry2.materials = [buttonMaterial2]
//
//        for i in 0...1 {
//            var buttonx: SCNNode!
//            buttonx = SCNNode(geometry: buttonGeometry2)
//            buttonx.position = SCNVector3(x: Float(i) * Float((box.max.x - box.min.x)) - Float((box.max.x - box.min.x) / 2), y: Float(box.max.y - box.min.y) / 2, z: 0)
//            scene.rootNode.addChildNode(buttonx)
//            listButton.append(buttonx)
//        }
        
//        button = SCNNode(geometry: buttonGeometry)
//        button.position = SCNVector3(x: 0, y: 0.5, z: 15)
//        scene?.rootNode.addChildNode(button)
        
        
        // MARK: - Render Button
        let buttonGeometry = SCNBox(width: CGFloat(box.max.x - box.min.x), height: CGFloat(box.max.y - box.min.y), length: CGFloat(box.max.z - box.min.z), chamferRadius: 0)
        let buttonMaterial = SCNMaterial()
        buttonMaterial.diffuse.contents = UIColor(displayP3Red: 1, green: 0.5, blue: 0.5, alpha: 0.7)
        buttonGeometry.materials = [buttonMaterial]
        
        for element in geometryButtonList {
            let buttonGeometry3 = SCNBox(width: element.3, height: element.4, length: element.5, chamferRadius: 0)
            let buttonMaterial3 = SCNMaterial()
            buttonMaterial3.diffuse.contents = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
            buttonGeometry3.materials = [buttonMaterial3]
            var buttonx2: SCNNode!
            buttonx2 = SCNNode(geometry: buttonGeometry3)
            buttonx2.position = SCNVector3(x: element.0 * Float(box.max.x - box.min.x) / 2, y: Float(box.max.y - box.min.y) * element.1, z: element.2 * Float(box.max.z - box.min.z) / 2)
            scene.rootNode.addChildNode(buttonx2)
            listButton.append(buttonx2)
        }
        
        
        // MARK: - Last calls
        // Set scene settings
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - Set Default State UI
        hideConfigureViewState()
        
        // MARK: - Set Default UI
        configureView.dropShadow()
        configureButton.border()
    }
    
    /// Deprecated
    @objc func pinchGesture(_ sender: UITapGestureRecognizer) {
        print(sender.numberOfTouches)
        
        if sender.numberOfTouches == 2 {
            // Disable zoom
            print("zoom attempted")
        }
    }
        
    
    // MARK: - Handle tap - refer to step 7
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        feedback(type: 6)
        // 1
        let touch = touches.first!
        
        // 2
        let location = touch.location(in: sceneView)
        // 3
        let hitResults = sceneView.hitTest(location, options: nil)
        // 4
        if hitResults.count > 0 {
            // 5
            let result = hitResults.first!
            // 6
            handleTouchFor(node: result.node)
        }
    }
    
    var i = true
    func handleTouchFor(node: SCNNode) {
        if listButton.contains(node) {
//            if node == button {
            
            feedback(type: 6)
            
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.0
//            let materials = node.geometry?.materials
//            let material = materials![0]
////            if i {
////                material.diffuse.contents = UIColor(displayP3Red: 1, green: 0.5, blue: 0.5, alpha: 0.7)
////            } else {
//                material.diffuse.contents = UIColor(displayP3Red: 0.5, green: 0.5, blue: 1, alpha: 0.7)
////            }
//            i = !i
//            SCNTransaction.commit()
            
            let a = node.geometry?.materials[0].diffuse.contents as! UIColor
            var red:CGFloat = 0
            var green:CGFloat = 0
            var blue:CGFloat = 0
            var alpha:CGFloat = 0

            a.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            if red <= 0.5 {
                node.geometry?.materials[0].diffuse.contents = UIColor(displayP3Red: 0.9, green: 0.5, blue: 0.5, alpha: 0.7)
            } else {
                node.geometry?.materials[0].diffuse.contents = UIColor(displayP3Red: 0.2, green: 0.5, blue: 1, alpha: 0.7)
            }
//            let action = SCNAction.moveBy(x: 0, y: -5, z: 0, duration: 0.3)
//            node.runAction(action)
        }
    }
    
    /// Deprecated
    @objc func sceneTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            if listButton.contains(node) {
//            if node == button {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.0
                let materials = node.geometry?.materials
                let material = materials![0]
                material.diffuse.contents = UIColor(displayP3Red: 1, green: 0.5, blue: 0.5, alpha: 1)
                SCNTransaction.commit()
                     
                let action = SCNAction.moveBy(x: 0, y: -100, z: 0, duration: 0)
                node.runAction(action)
            }
        }
    }
    
    // MARK: - UI States
    func showConfigureViewState() {
        stateConfigure = StateConfigure.show
        prepareSceneForState()
        UIView
            .animate(withDuration: 0.3, delay: 0.0,
                     options: [.curveEaseInOut],
                     animations: {[weak self] in
                
                self?.Bottom_CS_ConfigureView.constant = 30
                self?.Trailing_CS_ConfigureButton.constant = 0
                self?.Bottom_CS_ConfigureButton.constant = 8
                self?.view.layoutIfNeeded()
            },
                     completion: nil
            )
        
        
        configureButton.tintColor = .systemPink
        configureButton.setTitle("Hide", for: .normal)
        self.view.layoutIfNeeded()
    }
    
    func hideConfigureViewState() {
        stateConfigure = StateConfigure.hide
        prepareSceneForState()
        UIView
            .animate(withDuration: 0.3, delay: 0.0,
                     options: [.curveEaseInOut],
                     animations: {[weak self] in
                
                self?.Bottom_CS_ConfigureView.constant = -(self?.configureView.frame.size.height)!
                self?.Trailing_CS_ConfigureButton.constant = -(self?.configureView.frame.size.width)! + (self?.configureButton.frame.size.width)!
                self?.Bottom_CS_ConfigureButton.constant = 32
                self?.view.layoutIfNeeded()
            },
                     completion: nil
            )
        
        if #available(iOS 13.0, *) {
            configureButton.tintColor = .link
        } else {
            // Fallback on earlier versions
            configureButton.tintColor = .blue
        }
        
        self.view.endEditing(true)
        configureButton.setTitle("Configure", for: .normal)
        self.view.layoutIfNeeded()
    }
    
    
    // MARK: - IBACtions
    @IBAction func configureAction(_ sender: UIButton) {
        feedback(type: 1)
        switch stateConfigure {
        case .show:
            hideConfigureViewState()
            
            let filepath = getDocumentsDirectory().appendingPathComponent("configure.xml")
            print("Read file .xml: \(filepath)")
            do {
                let contents = try String(contentsOf: filepath, encoding: .utf8)
                print(contents)
            } catch {
                // contents could not be loaded
                print("Fail to read file .xml")
            }
        case .hide:
            showConfigureViewState()
        }
    }
    
    // MARK: - @objc function
    @objc func doneButtonAction(_ sender: UIButton) {
        print("doneButtonAction")
        feedback(type: 4)
        
        combineXMLDocument(data: outputDataOfConfigureFrom)
        SoundFeedBack.success()
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                sender.tintColor = .link
                sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
                sender.tintColor = .systemBlue
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.tintColor = .systemGreen
            sender.setImage(nil, for: .normal)
            sender.setTitle("Save", for: .normal)
        }
    }
    
    @objc func stepperChangedValue(_ sender: UIStepper) {
        print("stepperChangedValue")
        feedback(type: 4)
        tagTextFieldChanging = 11
        
        changeSideOnScene(to: Int(sender.value))
        
        outputDataOfConfigureFrom[1][0] = CGFloat(sender.value)
        print(outputDataOfConfigureFrom[1][0])
    }
    
    @objc func editingChangedValue(_ sender: UITextField) {
        print("editingChangedValue")
        var plain = ""
        if sender.text == nil || sender.text == "" {
            plain = "0"
        } else {
            plain = sender.text!
        }
        let value = (plain as NSString).floatValue
        tagTextFieldChanging = sender.tag
        outputDataOfConfigureFrom[tagTextFieldChanging / 10][tagTextFieldChanging % 10] = CGFloat(value)
        print(outputDataOfConfigureFrom)
    }
    
    @objc func editingDidEnd(_ sender: UITextField) {
        print("editingDidEnd")
        tagTextFieldChanging = sender.tag
        var plain = ""
        if sender.text == nil || sender.text == "" {
            plain = "0"
        } else {
            plain = sender.text!
        }
        let value = (plain as NSString).floatValue
        tagTextFieldChanging = sender.tag
        outputDataOfConfigureFrom[tagTextFieldChanging / 10][tagTextFieldChanging % 10] = CGFloat(value)
        print(outputDataOfConfigureFrom)
    }
    
    
    // MARK: - Methods
    func changeSideOnScene(to side: Int = 0) {
        print("changeSideOnScene to \(side)")
        self.side = side
    }
    
    func prepareSceneForState() {
        switch stateConfigure {
        case .hide:
            if  buttonConfigure != nil && listButton.contains(buttonConfigure) {
                listButton.removeLast()
            }
            if buttonConfigure != nil {
                buttonConfigure.removeFromParentNode()
            }
        case .show:
            updateScene()
        }
    }
    
    func renderButton(position: [Float], sizeBox: [CGFloat]) {
        if (tagTextFieldChanging / 10 == 0) {
            SCNTransaction.animationDuration = 0.2
            buttonConfigure.position = SCNVector3(
                x: position[0],
                y: position[1],
                z: position[2]
            )
        } else {
            if buttonConfigure != nil {
                buttonConfigure.removeFromParentNode()
            }
            let buttonGeometry = SCNBox(width: sizeBox[0], height: sizeBox[1], length: sizeBox[2], chamferRadius: 0)
            let buttonMaterial = SCNMaterial()
            buttonMaterial.diffuse.contents = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
            buttonGeometry.materials = [buttonMaterial]
            buttonConfigure = SCNNode(geometry: buttonGeometry)
            buttonConfigure.position = SCNVector3(x: position[0], y: position[1], z: position[2])
            sceneView.scene!.rootNode.addChildNode(buttonConfigure)
            if !listButton.contains(buttonConfigure) {
                listButton.append(buttonConfigure)
            }
        }
    }
    
    func updateScene() {
        updateButtonConfigure()
    }
    
    func getEdgeLengthOfBoxObject(direction: Int) -> Float {
        switch direction {
        case 0:
            return Float(box.max.x - box.min.x)
        case 1:
            return Float(box.max.y - box.min.y)
        case 2:
            return Float(box.max.z - box.min.z)
        default:
            return Float(box.max.x - box.min.x)
        }
    }
    
    func updateButtonConfigure() {
        let currentAxisParameterForSide = listAxisParameterForSide[side - 1]
        var vector3: [Float] = [0, 0, 0]
        var caculatvedBox: [CGFloat] = [0, 0, 0]
        var value1StAxis: CGFloat!
        var value1StEdge = outputDataOfConfigureFrom[1][1]
        for (index, parameter) in currentAxisParameterForSide.enumerated() {
            value1StAxis = outputDataOfConfigureFrom[0][index]
            vector3[index] = (Float(value1StAxis) / 100) * (getEdgeLengthOfBoxObject(direction: index) / 2)
            if parameter != 0 {
                caculatvedBox[index] = value1StEdge
                value1StEdge = outputDataOfConfigureFrom[1][2]
            } else {
                caculatvedBox[index] = 0.5
            }
        }
        renderButton(position: vector3, sizeBox: sort(caculatvedBox))
    }
    
    func sort(_ sizeBox: [CGFloat]) -> [CGFloat] {
        switch side {
        case 2, 4:
            var cloneBox = sizeBox
            cloneBox[1] = sizeBox[2]
            cloneBox[2] = sizeBox[1]
            return cloneBox
        default:
            return sizeBox
        }
    }
    
    
    
    // MARK: - Source code render 3D
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    private func configureHierarchy() {
        configureTableView.dataSource = self
        configureTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        cell.headerTitle.text = listHeaderTitle[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listCellTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCellTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row == 3 {
                let cell: DoneActionCell = tableView.dequeueReusableCell(withIdentifier: "DoneActionCell", for: indexPath) as! DoneActionCell
                cell.doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
                return cell
            }
        }
        
        switch listCellType[indexPath.section][indexPath.row] {
        case .picker:
            let cell: PickerCell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
            cell.constantTextField.tag = Int(indexPath.section.description + indexPath.row.description)!
            cell.titleLabel.text = listCellTitle[indexPath.section][indexPath.row]
            cell.constantTextField.text = outputDataOfConfigureFrom[indexPath.section][indexPath.row].description
            cell.constantTextField.addTarget(self, action: #selector(editingChangedValue), for: .editingChanged)
            cell.constantTextField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
            return cell
        case .select:
            let cell: SelectCell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
            cell.titleLabel.text = listCellTitle[indexPath.section][indexPath.row]
            cell.side.text = Int(outputDataOfConfigureFrom[indexPath.section][indexPath.row]).description
            cell.stepper.value = Double(outputDataOfConfigureFrom[indexPath.section][indexPath.row])
            cell.stepper.addTarget(self, action: #selector(stepperChangedValue), for: .valueChanged)
            return cell
        }
        
    }
}

//MARK: Keyboard.
extension ViewController: UITextFieldDelegate {
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
            
            self.containerViewBottomCS.constant = keyboardHeight
            self.sceneViewLeadingCS.constant = configureView.center.x + configureView.frame.size.width / 2 + 8
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
            
            self.containerViewBottomCS.constant -= keyboardRect.height
            self.sceneViewLeadingCS.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Tap Engine
import Foundation
func feedback(type: Int) {
    switch type {
    case 1:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)

    case 2:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

    case 3:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)

    case 4:
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

    case 5:
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

    case 6:
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

    default:
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - XML handler
func parseXMLModel () {
    guard
        let xmlPath = Bundle.main.path(forResource: "example", ofType: "xml"),
        let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
    else { return }

    do {
        let xmlDoc = try AEXMLDocument(xml: data)
            
        // prints the same XML structure as original
        print(xmlDoc.xml)
        
        // prints cats, dogs
        for child in xmlDoc.root.children {
            print(child.name)
        }
        
        // prints Optional("Tinna") (first element)
        print(xmlDoc.root["cats"]["cat"].value)
        
        // prints Tinna (first element)
        print(xmlDoc.root["cats"]["cat"].string)
        
        // prints Optional("Kika") (last element)
        print(xmlDoc.root["dogs"]["dog"].last?.value)
        
        // prints Betty (3rd element)
        print(xmlDoc.root["dogs"].children[2].string)
        
        // prints Tinna, Rose, Caesar
        if let cats = xmlDoc.root["cats"]["cat"].all {
            for cat in cats {
                if let name = cat.value {
                    print(name)
                }
            }
        }
        
        // prints Villy, Spot
        for dog in xmlDoc.root["dogs"]["dog"].all! {
            if let color = dog.attributes["color"] {
                if color == "white" {
                    print(dog.string)
                }
            }
        }
        
        // prints Tinna
        if let cats = xmlDoc.root["cats"]["cat"].all(withValue: "Tinna") {
            for cat in cats {
                print(cat.string)
            }
        }
        
        // prints Caesar
        if let cats = xmlDoc.root["cats"]["cat"].all(withAttributes: ["breed" : "Domestic", "color" : "yellow"]) {
            for cat in cats {
                print(cat.string)
            }
        }
        
        // prints 4
        print(xmlDoc.root["cats"]["cat"].count)
        
        // prints Siberian
        print(xmlDoc.root["cats"]["cat"].attributes["breed"]!)
        
        // prints <cat breed="Siberian" color="lightgray">Tinna</cat>
        print(xmlDoc.root["cats"]["cat"].xmlCompact)
        
        // prints Optional(AEXML.AEXMLError.elementNotFound)
        print(xmlDoc["NotExistingElement"].error)
    }
    catch {
        print("\(error)")
    }

}

func combineXMLDocument(data: [[CGFloat]]) {
    let combineRequest = AEXMLDocument()
    let homeAttributes = ["path": "/house.obj"]
    let home = combineRequest.addChild(name: "home", attributes: homeAttributes)
        let itemAttributes = [
//            "id": "0",
            "type": "button",
//            "name": "Chuông cửa",
            "x": "\(data[0][0])",
            "y": "\(data[0][1])",
            "z": "\(data[0][2])",
            "side": "\(data[1][0])",
            "width": "\(data[1][1])",
            "height": "\(data[1][2])"
        ]
        home.addChild(name: "item", attributes: itemAttributes)
    
    print("Log data before write to file \(data)")
    let str = combineRequest.xml
    let filename = getDocumentsDirectory().appendingPathComponent("configure.xml")

    do {
        try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        print("Fail write to file!")
    }
    
    /*
    <?xml version="1.0" encoding="utf-8"?>
    <home path="/house.obj">
        <item id="0" type="button" name="Chuông cửa" x="0" y="0" z="0" width="10" height="10" side="0" ></item>
        <item id="1" type="button" name="Đèn sân vườn" x="0" y="0" z="0" width="20" height="20" side="2" ></item>
        <item id="2" type="button" name="Đèn hắt" x="0" y="0" z="0" width="30" height="30" side="1" ></item>
    </home>
     
     <?xml version="1.0" encoding="utf-8" standalone="no"?>
     <home path="/house.obj">
         <home height="10" id="0" name="Chuông cửa" side="0" type="button" width="10" x="0" y="0" z="0" />
     </home>
     */
    
    
    
    // create XML Document
    let soapRequest = AEXMLDocument()
    let attributes = ["xmlns:xsi" : "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" : "http://www.w3.org/2001/XMLSchema"]
    
    let envelope = soapRequest.addChild(name: "soap:Envelope", attributes: attributes)
        let header = envelope.addChild(name: "soap:Header")
            header.addChild(name: "m:Trans", value: "234", attributes: ["xmlns:m" : "http://www.w3schools.com/transaction/", "soap:mustUnderstand" : "1"])
        let body = envelope.addChild(name: "soap:Body")
            let getStockPrice = body.addChild(name: "m:GetStockPrice")
                getStockPrice.addChild(name: "m:StockName", value: "AAPL")

    // prints the same XML structure as original
    print(combineRequest.xml)
/*
    <?xml version="1.0" encoding="utf-8" standalone="no"?>
    <soap:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <soap:Header>
            <m:Trans soap:mustUnderstand="1" xmlns:m="http://www.w3schools.com/transaction/">234</m:Trans>
        </soap:Header>
        <soap:Body>
            <m:GetStockPrice>
                <m:StockName>AAPL</m:StockName>
            </m:GetStockPrice>
        </soap:Body>
    </soap:Envelope>
 */
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// MARK: - Data Structure
enum StateConfigure {
    case hide
    case show
}

enum CellType {
    case picker
    case select
}
