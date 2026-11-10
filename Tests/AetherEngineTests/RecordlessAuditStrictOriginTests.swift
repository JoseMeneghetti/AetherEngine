import Testing
import Foundation
@testable import AetherEngine

/// The recordless Dolby Vision audit opens the source a second time. On an origin the host limited to
/// one request, that second open is a second connection the provider counts: on a single-connection
/// IPTV account it answered every later pump range with 509 until the session was torn down.
@Suite("Recordless DV audit stays off on a strict single-request origin")
struct RecordlessAuditStrictOriginTests {
    private let url = URL(string: "http://cdn.example.com:80/movie/u/p/1.mkv")!

    @Test("a host limit of one skips the second open")
    func strictOriginSkipsAudit() {
        let budget = OriginRequestBudget()
        budget.setHostLimit(1, for: url)
        #expect(!DolbyVisionRecordAudit.runsRecordlessAudit(for: url, budget: budget))
    }

    @Test("an origin without a limit of one keeps the audit")
    func otherOriginsKeepAudit() {
        let budget = OriginRequestBudget()
        #expect(DolbyVisionRecordAudit.runsRecordlessAudit(for: url, budget: budget))
        budget.setHostLimit(2, for: url)
        #expect(DolbyVisionRecordAudit.runsRecordlessAudit(for: url, budget: budget))
    }
}
