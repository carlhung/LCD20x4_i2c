import Foundation
import SwiftyGPIO

class I2CDevice{
    let addr: UInt8
    let bus: I2CInterface

    init?(board: SupportedBoard, bus: Int = 1, address: UInt8){
        let i2cs = SwiftyGPIO.hardwareI2Cs(for: board)
        guard let bus = i2cs?[bus] else { return nil}
        self.addr = address
        self.bus = bus
    }

    // write a single command
    func write_cmd(cmd: UInt8){
        self.bus.writeByte(Int(addr), value: cmd)
        // usleep(1000000) // for one second
        usleep(100)
    }

    // write a command and argument
    func write_cmd_arg(cmd: UInt8, data: UInt8){
        self.bus.writeByte(Int(addr), command: cmd, value: data)
        usleep(100)
    }

    // write a block of Data
    func write_block_data(cmd: UInt8, data: [UInt8]){
        self.bus.writeData(Int(addr), command: cmd, values: data)
        usleep(100)
    }

    // read a single byte
    func read() -> UInt8{
        return self.bus.readByte(Int(addr))
    }

    // Read
    func read_data(cmd: UInt8) -> UInt8 {
        return self.bus.readByte(Int(addr), command: cmd)
    }

    // Read a block of data
    func read_block_data(cmd: UInt8) -> [UInt8]{
        return self.bus.readData(Int(addr), command: cmd)
    }
}
