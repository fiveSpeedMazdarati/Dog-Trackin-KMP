import SwiftUI

/// Glyph tokens backed by SF Symbols (design-system.md §3).
///
/// Every symbol name is a PROPOSAL to be checked in Apple's SF Symbols app against iOS/tvOS 17.
/// Cases where `needsReview` is true are known-uncertain stand-ins.
public enum Glyph: String, CaseIterable, Sendable {
    case animal, pee, poop, meal, water, medication, walk, outside, treat, grooming, vet, note
    case namedPlace, droppedPin, home, caretakers, temporaryAccess, inbox, archive, delete
    case offline, syncPending, info, warning, critical

    public var symbolName: String {
        switch self {
        case .animal: "pawprint.fill"
        case .pee: "drop.fill"
        case .poop: "leaf.fill"
        case .meal: "fork.knife"
        case .water: "cup.and.saucer.fill"
        case .medication: "pills.fill"
        case .walk: "figure.walk"
        case .outside: "door.left.hand.open"
        case .treat: "gift.fill"
        case .grooming: "scissors"
        case .vet: "cross.case.fill"
        case .note: "note.text"
        case .namedPlace: "mappin.and.ellipse"
        case .droppedPin: "mappin"
        case .home: "house.fill"
        case .caretakers: "person.2.fill"
        case .temporaryAccess: "clock.badge"
        case .inbox: "bell.fill"
        case .archive: "archivebox.fill"
        case .delete: "trash"
        case .offline: "wifi.slash"
        case .syncPending: "arrow.triangle.2.circlepath"
        case .info: "info.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .critical: "exclamationmark.octagon.fill"
        }
    }

    /// Default accessibility label (to be moved into a String Catalog).
    public var label: String {
        switch self {
        case .animal: "Dog"
        case .pee: "Pee"
        case .poop: "Poop"
        case .meal: "Meal"
        case .water: "Water"
        case .medication: "Medication"
        case .walk: "Walk"
        case .outside: "Outside"
        case .treat: "Treat"
        case .grooming: "Grooming"
        case .vet: "Vet visit"
        case .note: "Note"
        case .namedPlace: "Place"
        case .droppedPin: "Dropped pin"
        case .home: "Home"
        case .caretakers: "Caretakers"
        case .temporaryAccess: "Temporary access"
        case .inbox: "Notifications"
        case .archive: "Archive"
        case .delete: "Delete"
        case .offline: "Offline"
        case .syncPending: "Not yet synced"
        case .info: "Info"
        case .warning: "Heads up"
        case .critical: "Service issue"
        }
    }

    public var needsReview: Bool {
        switch self {
        case .poop, .water, .outside, .treat, .temporaryAccess: true
        default: false
        }
    }

    /// The glyph as an accessible image.
    public var image: some View {
        Image(systemName: symbolName).accessibilityLabel(Text(label))
    }
}
