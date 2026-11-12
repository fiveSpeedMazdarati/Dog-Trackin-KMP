package com.softwareofnote.dogtrackin.designsystem

/**
 * Platform-neutral glyph tokens. Each platform renders the named system symbol:
 * SF Symbols on Apple platforms, Material Symbols on Android.
 *
 * Every name is a PROPOSAL and must be verified in Apple's SF Symbols app / Google's Material
 * Symbols catalogue against the chosen minimum OS versions — entries marked `verify = true`
 * are known-uncertain (see docs/design-system/design-system.md §3).
 */
enum class Glyph(
    val sfSymbol: String,
    val materialSymbol: String,
    /** Default accessibility label (to be moved to localized resources). */
    val label: String,
    val verify: Boolean = false,
) {
    Animal("pawprint.fill", "pets", "Dog"),
    Pee("drop.fill", "water_drop", "Pee"),
    Poop("leaf.fill", "compost", "Poop", verify = true),
    Meal("fork.knife", "restaurant", "Meal"),
    Water("cup.and.saucer.fill", "local_drink", "Water", verify = true),
    Medication("pills.fill", "medication", "Medication"),
    Walk("figure.walk", "directions_walk", "Walk"),
    Outside("door.left.hand.open", "door_open", "Outside", verify = true),
    Treat("gift.fill", "cookie", "Treat", verify = true),
    Grooming("scissors", "content_cut", "Grooming"),
    Vet("cross.case.fill", "medical_services", "Vet visit"),
    Note("note.text", "sticky_note_2", "Note"),
    NamedPlace("mappin.and.ellipse", "location_on", "Place"),
    DroppedPin("mappin", "pin_drop", "Dropped pin"),
    Home("house.fill", "home", "Home"),
    Caretakers("person.2.fill", "group", "Caretakers"),
    TemporaryAccess("clock.badge", "schedule", "Temporary access", verify = true),
    Inbox("bell.fill", "notifications", "Notifications"),
    Archive("archivebox.fill", "archive", "Archive"),
    Delete("trash", "delete", "Delete"),
    Offline("wifi.slash", "wifi_off", "Offline"),
    SyncPending("arrow.triangle.2.circlepath", "sync", "Not yet synced"),
    Info("info.circle.fill", "info", "Info"),
    Warning("exclamationmark.triangle.fill", "warning", "Heads up"),
    Critical("exclamationmark.octagon.fill", "report", "Service issue"),
}
