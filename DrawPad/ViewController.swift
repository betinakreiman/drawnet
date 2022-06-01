/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.



import UIKit

var models = [nil, nil, nil] as [TorchModule?] // torchmodule for specific model
var wordTXT = [[String](), [String](), [String]()] // array of words TXT
var numbOutputs = [10, 10, 9] //number of outputs
var seconds: [Double] = [7, 15, 20] //number of seconds per game

class ViewController: UIViewController {
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 20.0
  var opacity: CGFloat = 1.0
  var swiped = false

  var lowestY: CGFloat = 0
  var highestY: CGFloat = 0


  var randomIndex = Int.random(in: 0..<(numbOutputs[ViewController.modelIndex]))
  var word = "testing"
  
  var counter:Double = 0
  var timer:Timer = Timer()
  
  var gameActive = true
  
  

  @IBOutlet weak var brushSlider: UISlider!
  @IBOutlet weak var brushText: UILabel!
  @IBOutlet weak var brushName: UILabel!
  
  @IBOutlet weak var opacitySlider: UISlider!
  @IBOutlet weak var opacityLabel: UILabel!
  @IBOutlet weak var opacityText: UILabel!
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  static var settingsImageView = UIImageView()
  
  @IBOutlet weak var wordGuess: UILabel!
  
  @IBOutlet weak var resetOutlet: UIButton!
  
  @IBOutlet weak var topLine: UIImageView!
  @IBOutlet weak var bottomLine: UIImageView!
  
  
  @IBOutlet weak var predictionLabel: UILabel!
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var guessedImage: UIImageView!
  
  @IBOutlet weak var playAgainOutlet: UIButton!
  
  @IBOutlet weak var settingOutlet: UIButton!
  
  
  static var screenWidth: CGFloat = 0
  static var screenHeight: CGFloat = 0

  static var modelIndex = 1
  
  
  // MARK: - Actions
  override func viewDidLoad() {
    super.viewDidLoad()

    loadFiles()
    
    let screenSize: CGRect = UIScreen.main.bounds
    ViewController.screenWidth = screenSize.width
    ViewController.screenHeight = screenSize.height
    var sliderWidth = brushSlider.frame.width / 2
    sliderWidth = sliderWidth * 1.6
    
    
    //mainImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    //tempImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    //print(screenHeight)
    brushSlider.center.x = ViewController.screenWidth / 2
    opacitySlider.center.x = ViewController.screenWidth / 2
    opacitySlider.center.y = ViewController.screenHeight * 0.94
    brushSlider.center.y = ViewController.screenHeight  * 0.88
    
    brushText.center.y = brushSlider.center.y
    brushText.center.x = brushSlider.center.x + sliderWidth
    brushName.center.y = brushSlider.center.y
    brushName.center.x = brushSlider.center.x - sliderWidth
    
    opacityLabel.center.y = opacitySlider.center.y
    opacityLabel.center.x = opacitySlider.center.x + sliderWidth
    opacityText.center.y = opacitySlider.center.y
    opacityText.center.x = opacitySlider.center.x - sliderWidth
    
    // dealing with square part only, meaning not outside certain points
    highestY = ViewController.screenHeight / 2
    highestY = highestY + ViewController.screenWidth / 2
    lowestY = ViewController.screenHeight / 2
    lowestY = lowestY - ViewController.screenWidth / 2
    
    // dealing with the guessing word
    wordGuess.center.x = ViewController.screenWidth / 2
    wordGuess.center.y = ViewController.screenHeight * 0.08
    //wordGuess.frame = CGRect(x: wordGuess.center.x, y: wordGuess.center.y, width: brushSlider.frame.width, height: wordGuess.frame.height)
    
    topLine.frame = CGRect(x: 0, y: lowestY - 10, width: ViewController.screenWidth, height: 10)
    topLine.backgroundColor = UIColor.black
    bottomLine.frame = CGRect(x: 0, y: highestY, width: ViewController.screenWidth, height: 10)
    bottomLine.backgroundColor = UIColor.black
    
    mainImageView.frame = CGRect(x: 0, y: lowestY, width: ViewController.screenWidth, height: ViewController.screenWidth)
    tempImageView.frame = CGRect(x: 0, y: lowestY, width: ViewController.screenWidth, height: ViewController.screenWidth)
    ViewController.settingsImageView.frame = CGRect(x: 0, y: lowestY, width: ViewController.screenWidth, height: ViewController.screenWidth)
    ViewController.settingsImageView.isHidden = true
    
    predictionLabel.center.x = ViewController.screenWidth / 2
    //predictionLabel.center.y = ViewController.screenHeight * 0.78
    predictionLabel.center.y = (bottomLine.center.y + brushSlider.center.y) / 2
    predictionLabel.text = ""
    
    timerLabel.center.y = ViewController.screenHeight * 0.16
    timerLabel.center.x = ViewController.screenWidth * 0.25
    
    
    //var sizeGuessedImage = screenWidth * 0.1
    guessedImage.frame = CGRect(x: 0, y: 0, width: ViewController.screenWidth * 0.09, height: ViewController.screenWidth * 0.09)
    guessedImage.center.y = ViewController.screenHeight * 0.16
    guessedImage.center.x = ViewController.screenWidth * 0.75
    
    // working with the labelss

    randomIndex = Int.random(in: 0..<(numbOutputs[ViewController.modelIndex]))
    word = wordTXT[ViewController.modelIndex][randomIndex]

    wordGuess.text = word
    
    
    // timer!
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    timerLabel.text = "0.00"
    
    playAgainOutlet.isHidden = true
    playAgainOutlet.center.x = ViewController.screenWidth / 2
    playAgainOutlet.center.y = ViewController.screenHeight * 0.16
    
    //settingOutlet.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.05, height: screenWidth * 0.05)
    
  }
  
  
  @IBAction func settingsPressed(_ sender: Any) {
  }
  
  
  
  @objc func startTimer() {
    //print(counter)
    counter = counter + 0.1
    //timerLabel.text = String(counter)
    timerLabel.text = String(format: "%.01f", (seconds[ViewController.modelIndex]) - counter)
    
    if abs((seconds[ViewController.modelIndex]) - counter) < 0.01 {
      timer.invalidate()
      guessedImage.image = UIImage(named: "x.jpg")
      gameActive = false
      playAgainOutlet.isHidden = false
    }
  }
  
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = nil
    ViewController.settingsImageView.image = nil
  }
  
  @IBAction func pencilPressed(_ sender: UIButton) {
    guard let pencil = Pencil(tag: sender.tag) else {
      return
    }

    color = pencil.color

    if pencil == .eraser {
      opacity = 1.0
    }
  }
  
  func inBox(location: CGPoint) -> Bool {
    let y = location.y
    if highestY >= y {
      if lowestY <= y {
        return true
      }
    }
    return false
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    if gameActive == true {
      swiped = false
      let temp = touch.location(in: view)
      if inBox(location: temp) == true {
        lastPoint = temp
      }
    }
  }

  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
      
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    context.strokePath()
    
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }

    if gameActive == true {
      swiped = true
      
      let currentPoint = touch.location(in: view)
      if inBox(location: currentPoint) == true {
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      // draw a single point
      drawLine(from: lastPoint, to: lastPoint)
    }
      
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    ViewController.settingsImageView.image = mainImageView.image
      
    tempImageView.image = nil
    if gameActive == true {
      test()
    }
  }
  
  @IBAction func brushChanged(_ sender: UISlider) {
    brushWidth = CGFloat(sender.value)
    brushText.text = String(format: "%.1f", brushWidth)
  }
  
  @IBAction func opacityChanged(_ sender: UISlider) {
    opacity = CGFloat(sender.value)
    opacityLabel.text = String(format: "%.1f", opacity)
  }

  
  func test() {
    if mainImageView.image == nil {
      return
    }
    
    mainImageView.frame = CGRect(x: 0, y: 0, width: ViewController.screenWidth, height: ViewController.screenWidth) // maybe get rid of this line
    
    let image: UIImage = mainImageView.image!
    let imageWidth = image.size.width
    let imageHeight = image.size.height
    //print(imageWidth/4, imageWidth/2, imageWidth)

    var croppedImage = cropImage(image, toRect: CGRect(x: 0, y: imageWidth/4, width: imageWidth, height: imageWidth/2), viewWidth: imageWidth, viewHeight: imageHeight/2)
    //croppedImage = UIImage(named: "betiski.jpg")!

    croppedImage = croppedImage?.resized(to: CGSize(width: 28, height: 28))
    saveJpg(croppedImage!)
    
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    var betina = UIImage()
    if let dirPath = paths.first {
      let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("exampleJpg.jpg")
      betina = (UIImage(contentsOfFile: imageURL.path))!
       // Do whatever you want with the image
    }
    
    
    
    
    //guard var pixelBuffer = resizedImage.normalized() else {
    //    return
    //}
    
    let outputs = PredictionService.predict(img: betina, module: models[ViewController.modelIndex]!)
    /* guard let outputs = module.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
        return
    } */
    
    //print(outputs)
    
    let zippedResults = zip(wordTXT[ViewController.modelIndex].indices, outputs)
    let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(10)
    var text = ""
    var topTenPrediction = [String]()
    for result in sortedResults {
      let temp = wordTXT[ViewController.modelIndex][result.0]
      text += "\u{2022} \(temp) \n\n"
      topTenPrediction.append(temp)
      
    }
    
    let predictedWord = topTenPrediction[0]
    
    predictionLabel.text = "The computer thinks it is a " + predictedWord
    
    if predictedWord == word {
      timer.invalidate()
      gameActive = false
      guessedImage.image = UIImage(named: "check.jpg")
      playAgainOutlet.isHidden = false
    }
  }
  
  
  @IBAction func playAgainPressed(_ sender: Any) {
    counter = 0
    playAgainOutlet.isHidden = true
    randomIndex = Int.random(in: 0..<(numbOutputs[ViewController.modelIndex]))
    word = wordTXT[ViewController.modelIndex][randomIndex]
    wordGuess.text = word
    guessedImage.image = nil
    mainImageView.image = nil
    ViewController.settingsImageView.image = nil
    predictionLabel.text = ""
    gameActive = true
    
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
  }
  
  func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
      let imageViewScale = max(inputImage.size.width / viewWidth,
                               inputImage.size.height / viewHeight)

      // Scale cropRect to handle images larger than shown-on-screen size
      let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                            y:cropRect.origin.y * imageViewScale,
                            width:cropRect.size.width * imageViewScale,
                            height:cropRect.size.height * imageViewScale)

      // Perform cropping in Core Graphics
      guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
      else {
          return nil
      }

      // Return image to UIImage
      let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
      return croppedImage
  }
  
  func documentDirectoryPath() -> URL? {
      let path = FileManager.default.urls(for: .documentDirectory,
                                          in: .userDomainMask)
      return path.first
  }
  
  func saveJpg(_ image: UIImage) {
    if let jpgData = image.jpegData(compressionQuality: 0.5), var path = documentDirectoryPath()?.appendingPathComponent("exampleJpg.jpg") {
        try? jpgData.write(to: path)
    }
  }
}






func loadFiles() {
  var mnistTXT = [String]()
  var fashionTXT = [String]()
  var googleTXT = [String]()
  
  lazy var mnistModule: TorchModule = {
      if let filePath = Bundle.main.path(forResource: "mnistModel", ofType: "pt"),
          let module = TorchModule(fileAtPath: filePath) {
          return module
      } else {
          fatalError("Can't find the model file!")
      }
  }()

  lazy var fashionModule: TorchModule = {
      if let filePath = Bundle.main.path(forResource: "fashionModel", ofType: "pt"),
          let module = TorchModule(fileAtPath: filePath) {
          return module
      } else {
          fatalError("Can't find the model file!")
      }
  }()
  
  lazy var googleModule: TorchModule = {
      if let filePath = Bundle.main.path(forResource: "googleModel", ofType: "pt"),
          let module = TorchModule(fileAtPath: filePath) {
          return module
      } else {
          fatalError("Can't find the model file!")
      }
  }()
  
  models[0] = mnistModule
  models[1] = fashionModule
  models[2] = googleModule
  
    
  if let filePath = Bundle.main.path(forResource: "mnistDigits", ofType: "txt"),
      let labels = try? String(contentsOfFile: filePath) {
      mnistTXT = labels.components(separatedBy: .newlines)
  } else {
      fatalError("Can't find the text file!")
  }
  
  if let filePath = Bundle.main.path(forResource: "fashionMNISTwords", ofType: "txt"),
      let labels = try? String(contentsOfFile: filePath) {
      fashionTXT = labels.components(separatedBy: .newlines)
  } else {
      fatalError("Can't find the text file!")
  }
  
  if let filePath = Bundle.main.path(forResource: "googleWords", ofType: "txt"),
      let labels = try? String(contentsOfFile: filePath) {
   googleTXT = labels.components(separatedBy: .newlines)
  } else {
      fatalError("Can't find the text file!")
  }
  
  wordTXT[0] = mnistTXT
  wordTXT[1] = fashionTXT
  wordTXT[2] = googleTXT
}
