import SwiftyGPIO
import Foundation
import XCTest
@testable import LCD20x4

final class LCD20x4Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // XCTAssertEqual(LCD20x4().text, "Hello, World!")
        let bus = 1
        let address:UInt8 = 0x27
        guard let mylcd = LCD_20x4(board: SupportedBoard.RaspberryPiPlusZero, bus: bus, LCDAddress: address) else {
            print("failed to unwrap lcd")
            return
        }

        print("is it reachable? \(mylcd.lcd_device.bus.isReachable(Int(address)) ? "yes" : "no")")
        mylcd.lcd_display_string(string: "RPi I2c test", line: 1)
        mylcd.lcd_display_string(string: " Custom chars", line: 2)
        sleep(2)

        mylcd.lcd_clear()
        mylcd.backlight(state: true)
        sleep(2)

        let fontdata1: [[UInt8]] = [
            // Char 0 - Upper-left
            [ 0x00, 0x00, 0x03, 0x04, 0x08, 0x19, 0x11, 0x10 ],
            // Char 1 - Upper-middle
            [ 0x00, 0x1F, 0x00, 0x00, 0x00, 0x11, 0x11, 0x00 ],
           // Char 2 - Upper-right
            [ 0x00, 0x00, 0x18, 0x04, 0x02, 0x13, 0x11, 0x01 ],
           // Char 3 - Lower-left
            [ 0x12, 0x13, 0x1b, 0x09, 0x04, 0x03, 0x00, 0x00 ],
            // Char 4 - Lower-middle
            [ 0x00, 0x11, 0x1f, 0x1f, 0x0e, 0x00, 0x1F, 0x00 ],
            // Char 5 - Lower-right
            [ 0x09, 0x19, 0x1b, 0x12, 0x04, 0x18, 0x00, 0x00 ],
            // Char 6 - my test
	        [ 0x1f,0x0,0x4,0xe,0x0,0x1f,0x1f,0x1f],
        ]

        // Load logo chars (fontdata1)
        mylcd.lcd_load_custom_chars(fontdata: fontdata1)
        sleep(2)
//        mylcd.backlight(state: false)
        
        mylcd.lcd_write(0x80)
        mylcd.lcd_write_char(charValue: 0)
        mylcd.lcd_write_char(charValue: 1)
        mylcd.lcd_write_char(charValue: 2)

        mylcd.lcd_write(0xC0)
        mylcd.lcd_write_char(charValue: 3)
        mylcd.lcd_write_char(charValue: 4)
        mylcd.lcd_write_char(charValue: 5)
        sleep(2)
        mylcd.backlight(state: false)
        mylcd.lcd_clear()

        mylcd.lcd_display_string_pos(string: "Testing", line: 1, pos: 1)
        sleep(1)
        mylcd.lcd_display_string_pos(string: "Testing", line: 2, pos: 3)
        sleep(1)
        mylcd.lcd_clear()

        let fontdata2:[[UInt8]] = [
        // Char 0 - left arrow
        [ 0x1,0x3,0x7,0xf,0xf,0x7,0x3,0x1 ],
        // Char 1 - left one bar 
        [ 0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10 ],
        // Char 2 - left two bars
        [ 0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18 ],
        // Char 3 - left 3 bars
        [ 0x1c,0x1c,0x1c,0x1c,0x1c,0x1c,0x1c,0x1c ],
        // Char 4 - left 4 bars
        [ 0x1e,0x1e,0x1e,0x1e,0x1e,0x1e,0x1e,0x1e ],
        // Char 5 - left start
        [ 0x0,0x1,0x3,0x7,0xf,0x1f,0x1f,0x1f ],
        // Char 6 - 
         [ ],
        ]

        mylcd.lcd_load_custom_chars(fontdata: fontdata2)

        let block: [UInt8] = [255, 255]
        
        let str: String = String(bytes: block, encoding: .ascii)!

        mylcd.lcd_display_string_pos(string: str, line: 1, pos: 4)

        // usleep(1000000) // for one second
        let pauza: UInt32 = 200000
        
        usleep(pauza)

        var pos: UInt8 = 6
        mylcd.lcd_display_string_pos(string: String(bytes: [1], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [2], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [3], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [4], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [255], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        pos = pos + 1
        mylcd.lcd_display_string_pos(string: String(bytes: [1], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [2], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [3], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [4], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_display_string_pos(string: String(bytes: [255], encoding: .ascii)!, line: 1, pos: pos)
        usleep(pauza)

        mylcd.lcd_load_custom_chars(fontdata: fontdata1)
        mylcd.lcd_display_string_pos(string: String(bytes: [0], encoding: .ascii)!, line: 1, pos: 9)
        mylcd.lcd_display_string_pos(string: String(bytes: [1], encoding: .ascii)!, line: 1, pos: 10)
        mylcd.lcd_display_string_pos(string: String(bytes: [2], encoding: .ascii)!, line: 1, pos: 11)
        mylcd.lcd_display_string_pos(string: String(bytes: [3], encoding: .ascii)!, line: 2, pos: 9)
        mylcd.lcd_display_string_pos(string: String(bytes: [4], encoding: .ascii)!, line: 2, pos: 10)
        mylcd.lcd_display_string_pos(string: String(bytes: [5], encoding: .ascii)!, line: 2, pos: 11)

        sleep(2)
        mylcd.lcd_clear()
        sleep(1)
        mylcd.backlight(state: false)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
