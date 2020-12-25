import Foundation
import Capacitor

@objc(Stockfish)
public class Stockfish: CAPPlugin {
    
    let EVENT_OUTPUT = "stockfishOutput"

    var stockfish: StockfishBridge?
    var isInit = false

    @objc override public func load() {
        stockfish = StockfishBridge(plugin: self)
    }

    @objc func start(_ call: CAPPluginCall) {
        stockfish?.start()
        isInit = true
        call.success()
    }

    @objc func cmd(_ call: CAPPluginCall) {
        if (isInit) {
            guard let cmd = call.options["cmd"] as? String else {
                call.reject("Must provide a cmd")
                return
            }
            stockfish?.cmd(cmd)
            call.resolve()
        } else {
            call.reject("You must call start before anything else")
        }
    }
    
    @objc func exit(_ call: CAPPluginCall) {
        if (isInit) {
            stockfish?.cmd("quit")
            stockfish?.exit()
            isInit = false
        }
        call.success()
    }
}