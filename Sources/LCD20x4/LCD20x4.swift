import Foundation
import SwiftyGPIO

public class LCD_20x4{

    let lcd_device: I2CDevice
    public var backLightOn: Bool

    // commands
    let LCD_CLEARDISPLAY: UInt8 = 0x01
    let LCD_RETURNHOME: UInt8 = 0x02
    let LCD_ENTRYMODESET: UInt8 = 0x04
    let LCD_DISPLAYCONTROL: UInt8 = 0x08
    let LCD_CURSORSHIFT: UInt8 = 0x10
    let LCD_FUNCTIONSET: UInt8 = 0x20
    let LCD_SETCGRAMADDR: UInt8 = 0x40
    let LCD_SETDDRAMADDR: UInt8 = 0x80

    // flags for display entry mode
    let LCD_ENTRYRIGHT: UInt8 = 0x00
    let LCD_ENTRYLEFT: UInt8 = 0x02
    let LCD_ENTRYSHIFTINCREMENT: UInt8 = 0x01
    let LCD_ENTRYSHIFTDECREMENT: UInt8 = 0x00

    // flags for display on/off control
    let LCD_DISPLAYON: UInt8 = 0x04
    let LCD_DISPLAYOFF: UInt8 = 0x00
    let LCD_CURSORON: UInt8 = 0x02
    let LCD_CURSOROFF: UInt8 = 0x00
    let LCD_BLINKON: UInt8 = 0x01
    let LCD_BLINKOFF: UInt8 = 0x00

    // flags for display/cursor shift
    let LCD_DISPLAYMOVE: UInt8 = 0x08
    let LCD_CURSORMOVE: UInt8 = 0x00
    let LCD_MOVERIGHT: UInt8 = 0x04
    let LCD_MOVELEFT: UInt8 = 0x00

    // flags for function set
    let LCD_8BITMODE: UInt8 = 0x10
    let LCD_4BITMODE: UInt8 = 0x00
    let LCD_2LINE: UInt8 = 0x08
    let LCD_1LINE: UInt8 = 0x00
    let LCD_5x10DOTS: UInt8 = 0x04
    let LCD_5x8DOTS: UInt8 = 0x00

    // flags for backlight control
    let LCD_BACKLIGHT: UInt8 = 0x08
    let LCD_NOBACKLIGHT: UInt8 = 0x00

    let En: UInt8 = 0b00000100 // Enable bit
    let Rw: UInt8 = 0b00000010 // Read/Write bit
    let Rs: UInt8 = 0b00000001 // Register select bit

    public init?(board: SupportedBoard, bus: Int = 1, LCDAddress: UInt8 = 0x27, blackLightOn: Bool = false){
        guard let lcd_device = I2CDevice(board: board, bus: bus, address: LCDAddress) else { return nil }
        self.lcd_device = lcd_device
        self.backLightOn = blackLightOn
        self.lcd_write(0x03)
        self.lcd_write(0x03)
        self.lcd_write(0x03)
        self.lcd_write(0x02)

        self.lcd_write(LCD_FUNCTIONSET | LCD_2LINE | LCD_5x8DOTS | LCD_4BITMODE)
        self.lcd_write(LCD_DISPLAYCONTROL | LCD_DISPLAYON)
        self.lcd_write(LCD_CLEARDISPLAY)
        self.lcd_write(LCD_ENTRYMODESET | LCD_ENTRYLEFT)
        // usleep(1000000) // for one second
        usleep(100000)
    }
    
    public func backLightState() -> UInt8 {
        return backLightOn ? LCD_BACKLIGHT : LCD_NOBACKLIGHT
    }
    
    // clocks EN to latch command
    public func lcd_strobe(data: UInt8){
//        self.lcd_device.write_cmd(cmd: data | En | LCD_BACKLIGHT)
        self.lcd_device.write_cmd(cmd: data | En | backLightState())
        usleep(500)
//        self.lcd_device.write_cmd(cmd: (data & ~En) | LCD_BACKLIGHT)
        self.lcd_device.write_cmd(cmd: (data & ~En) | backLightState())
        usleep(100)
    }

    public func lcd_write_four_bits(data: UInt8){
//        self.lcd_device.write_cmd(cmd: data | LCD_BACKLIGHT)
        self.lcd_device.write_cmd(cmd: data | backLightState())
        self.lcd_strobe(data: data)
    }

    public func lcd_write(_ cmd: UInt8, mode: UInt8 = 0){
        self.lcd_write_four_bits(data: mode | (cmd & 0xF0))
        self.lcd_write_four_bits(data: mode | ((cmd << 4) & 0xF0))
    }

    // write a character to lcd (or character rom) 0x09: backlight | RS=DR<
    // works!
    public func lcd_write_char(charValue: UInt8, mode: UInt8 = 1){
        self.lcd_write_four_bits(data: mode | (charValue & 0xF0))
        self.lcd_write_four_bits(data: mode | ((charValue << 4) & 0xF0))
    }

    // put string function
    public func lcd_display_string(string: String, line: Int){
        switch line {
        case 1:
            self.lcd_write(0x80)
        case 2:
            self.lcd_write(0xC0)
        case 3:
            self.lcd_write(0x94)
        case 4:
            self.lcd_write(0xD4)
        default:
            return
        }

        // may overflow here.
        for charValue in string.unicodeScalars{
            self.lcd_write(UInt8(charValue.value), mode: Rs)
        }
    }

    // define backlight on/off
    public func backlight(state: Bool){
        backLightOn = state
        if backLightOn == true {
            self.lcd_device.write_cmd(cmd: LCD_BACKLIGHT)
        } else {
            self.lcd_device.write_cmd(cmd: LCD_NOBACKLIGHT)
        }
    }

    // add custom characters (0 - 7)
    public func lcd_load_custom_chars(fontdata: [[UInt8]]){
        self.lcd_write(0x40)
        for char in fontdata{
            for line in char{
                self.lcd_write_char(charValue: line)
            }
        }
    }

    // define precise positioning ( addition from the forum)
    public func lcd_display_string_pos(string: String, line: UInt8, pos: UInt8){
        let pos_new: UInt8
        switch line {
        case 1:
            pos_new = pos
        case 2:
            pos_new = 0x40 + pos
        case 3:
            pos_new = 0x14 + pos
        case 4:
            pos_new = 0x54 + pos
        default:
            return
        }

        self.lcd_write(0x80 + pos_new)

        for charValue in string.unicodeScalars{
            self.lcd_write(UInt8(charValue.value), mode: Rs)
        }
    }

    // clear lcd and set to home
    public func lcd_clear(){
        self.lcd_write(LCD_CLEARDISPLAY)
        self.lcd_write(LCD_RETURNHOME)
    }
}
