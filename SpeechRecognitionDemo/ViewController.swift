

import UIKit
import Speech
import AVFoundation
import ApiAI

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var flightTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    /*connecting AI **/
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    
    
    /* Text to speech */
    
    var synthesizer = AVSpeechSynthesizer()

    var totalUtterance: Int = 0
    
    /* end text to speech */
    
    
    let audioEngine = AVAudioEngine()
    //let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer() //cambiado por lo de abajo
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))!
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var preRecordedAudioURL: URL = {
        return Bundle.main.url(forResource: "LX40", withExtension: "m4a")!
    }()

    var status = SpeechStatus.ready {
        didSet {
            self.setUI(status: status)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized:
            self.status = .ready
        case .denied, .restricted:
            self.status = .unavailable
        }
        
        //first speech =)
        sleep(2)
        speakNowWelcome()
        
        AIResponse(question: "Hola")

    }
    
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.status = .ready
                default:
                    self.status = .unavailable
                }
            }
        }
    }
    
    func recognizeFile(url: URL) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request) { result, error in
            guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
                return self.status = .unavailable
            }
            if let result = result {
                self.flightTextView.text = result.bestTranscription.formattedString
                if result.isFinal {
                    //self.searchFlight(number: result.bestTranscription.formattedString)
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func startRecording() {
        // Setup audio engine and speech recognizer
        guard let node = audioEngine.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.status = .recognizing
        } catch {
            return print(error)
        }
        
        // Analyze the speech cambie el ? era speechRecognizer?
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                //self.flightTextView.text = result.bestTranscription.formattedString cambiado por la AI
                
                self.inputTextView.text = result.bestTranscription.formattedString
                
                //AI
                self.AIResponse(question: result.bestTranscription.formattedString)
                
                
                //self.searchFlight(number: result.bestTranscription.formattedString) cambiado por la AI
                
            } else if let error = error {
                print(error)
            }
        })
    }

    // TODO
    
    func cancelRecording() {
        audioEngine.stop()
        if let node = audioEngine.inputNode {
            node.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
        
        speakNow()
    }

    @IBAction func microphonePressed() {
        //recognizeFile(url: preRecordedAudioURL)
        switch status {
        case .ready:
            startRecording()
            status = .recognizing
        case .recognizing:
            cancelRecording()
            status = .ready
        default:
            break
        }
    
    }
    
    func speakNow(){
        //Para que hable
        
        if !self.synthesizer.isSpeaking{
            
            
            let textParagraphs = self.responseTextView.text.components(separatedBy: "\n")
            self.totalUtterance = textParagraphs.count
            
            for pieceOfText in textParagraphs{
                
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                
                let voice = AVSpeechSynthesisVoice(language: "es-MX")
                
                speechUtterance.voice = voice
                
                
                //speechUtterance.rate = 1.0 por validar
                
                //speechUtterance.pitchMultiplier = 1.0
                
                //speechUtterance.volume = 1.0
                
                self.synthesizer.speak(speechUtterance)
                
                
            }
            
        }else{
            
            self.synthesizer.continueSpeaking()
            
        }

    
    }
    
    func speakNowWelcome(){
        //Para que hable
        
        if !self.synthesizer.isSpeaking{
            
            
            let textParagraphs = "Hola Antonio, soy Talán y estoy feliz de ayudarte."
            
            let speechUtterance = AVSpeechUtterance(string: textParagraphs)
            
            let voice = AVSpeechSynthesisVoice(language: "es-MX")
            
            speechUtterance.voice = voice
            
            self.synthesizer.speak(speechUtterance)
            

            
        }else{
            
            self.synthesizer.continueSpeaking()
            
        }
        
        
    }
    
    func AIResponse(question: String){
    
        let request = ApiAI.shared().textRequest()
        /*if let text = self.flightTextView.text, text != "" {
            request?.query = text
        } else {
            return
        }*/
        
        request?.query = question
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            
            let textResponse = response.result.fulfillment.speech as! String
            
            self.responseTextView.text = textResponse
            
            
        },failure: { (request, error) in
                print("error")
        
        })
        
        ApiAI.shared().enqueue(request)
        
    }
}
