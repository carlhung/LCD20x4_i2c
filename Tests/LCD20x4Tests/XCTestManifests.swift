import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LCD20x4Tests.allTests),
    ]
}
#endif
