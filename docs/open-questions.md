# Dog Trackin' — Open Questions and Gaps

Answers to these shape the spec, the plan and the estimates. Questions are grouped and roughly ordered by impact, with the most important first.

## A. Platform and technology (blocking)
1. **Is Android still a goal?** The repo is a Kotlin Multiplatform project with an Android app, but the request says "native iOS app". This decides ADR-1 (options A, B or C in the implementation plan).
2. **Is moving the iOS UI from Compose Multiplatform to SwiftUI acceptable?** It's needed for a "native, modern iOS" feel, and tvOS can't use Compose (to my knowledge).
3. **Minimum iOS version?** Proposal: iOS 17, for `@Observable` and modern SwiftUI navigation. Each version you go back costs more work.
4. **Firebase Blaze plan:** server-side push fan-out needs Cloud Functions, which require pay-as-you-go billing. OK?
5. **Apple Developer Program:** do you have a paid account? It's needed for push (APNs key), Sign in with Apple, TestFlight and the App Store.

## B. People and permissions
6. **Can an animal have several owners?** If the only owner deletes their account, what happens to the dog and to everyone else's access?
7. **What can a regular caretaker do?** Invite others? Edit the dog's profile? Edit or delete other people's events?
8. **Temporary caretakers:** must they create a full account (your rule: everyone has their own), or would a guest link be acceptable for a one-day dog walker? After their access ends, should they keep seeing history from their window?
9. **"Current caretakers assigned":** does this mean a **schedule or shifts** ("Sam has the dogs this weekend")? That's a significant feature (calendar, hand-offs) and it changes the TV screen.
10. **Households:** should there be a "household" grouping so you invite people once for all your dogs, or is access always per animal?

## C. Events
11. **Medication:** just logging, or also **schedules and reminders** ("Apoquel 8 am and 8 pm, nudge if missed")? Missed-dose alerts are probably the most valuable feature of all, and also the most complex.
12. **Duplicate guard windows:** what should count as a duplicate for a meal versus a medication, and should it block or only warn?
13. **Walks:** a single tap, or start/stop with a timer? Distance or route?
14. **Custom event types:** allow them in v1? If so, chosen from a fixed glyph set?
15. **Editing and backdating:** should others be notified when someone edits or deletes an event?
16. **Photos:** "glyphs instead of graphics" rules out illustrations. Does it also rule out user photos of the dog, or of something worrying in the yard?
17. **Species:** dogs only, or cats and others too? The model handles any, but copy and glyphs say "dog".

## D. Notifications
18. **Late-synced events:** if someone logs an event offline and it syncs 3 hours later, should others still get a **push**, or only an inbox item? Proposal: push only if under 2 h old.
19. **Quiet hours and per-type muting:** needed in v1? For example, mute pee and poop but always push medication.
20. **Notification text:** OK to show the dog's name and event on the lock screen ("Sam fed Biscuit")?

## E. Location and privacy
21. **Should GPS pins be visible to temporary caretakers?** Your home's coordinates would be visible to a sitter.
22. **Saved places:** per animal, per person, or per household?
23. **Precise or approximate location:** iOS lets users grant only approximate location. Is that good enough?

## F. Offline
24. **"Option to sync later":** automatic sync when the connection returns (the default), or also a user-controlled **pause sync** toggle (for cellular data or roaming)?
25. **Offline medication risk:** a dose logged offline is invisible to others until it syncs. Should the app warn the person who logged it? ("You're offline, others can't see this yet. Text them?")

## G. Announcements and banners
26. **Who publishes announcements, and how?** A command-line script is fine for you alone. A web admin page is needed if others do it.
27. **Targeting:** only "everyone" and "one user"? Or also by app version (e.g. "please update"), platform or country?
28. **Where to host the outage `status.json`** so it works when Firebase is down (GitHub Pages, a CDN bucket, or something else)?
29. **Forced update:** should a banner be able to block the app until the user updates (useful after a breaking backend change)?

## H. TV
30. **Apple TV only, or also Google TV / Android TV?**
31. **Is pairing the TV with a code from your phone OK** (a read-only, revocable TV login), or should the TV show everything the signed-in account can see?
32. **Would home-screen widgets, Lock Screen widgets or an Apple Watch app cover the "glance" need** more cheaply than a TV app? They could come first.

## I. Design
33. **Exact shades:** I proposed lavender `#D8CCFF` and sky `#C6E4FF`. Are those the light purple and light blue you had in mind?
34. **Grays:** is the four-colour palette allowed neutral grays (mixes of black and white) for secondary text and dividers?
35. **No red at all,** including for delete or error? The design uses an inverted black/white treatment for danger.
36. **Poop glyph:** as far as I know SF Symbols has no dedicated one. Options: a stand-in symbol (currently `leaf.fill`), a text label, or a custom SF Symbol (a vector glyph you design, which still counts as a glyph).
37. **SF Pro Rounded** for the big "time since" numbers? Rounded fits a pet app. It's still a system font.

## J. Business, legal, operations
38. **Free, paid or subscription?** This affects StoreKit work, whether the TV app is gated, and Firebase cost planning.
39. **Privacy policy and terms:** needed for the App Store and for location data. Who writes them?
40. **Data export and retention:** should owners be able to export an animal's history (CSV/PDF for the vet)? How long are deleted animals kept, and is there an undo window?
41. **Localization:** English only at launch?
42. **Analytics:** Firebase Analytics is already a dependency. Do you want product analytics, and how will consent be handled?
43. **Environments:** separate dev and prod Firebase projects (recommended)?
44. **Bundle ID and name:** are the `com.softwareofnote.dogtrackin` bundle ID and the "Dog Trackin'" name (with the apostrophe) final? Is the App Store name available? I can't check that from here.
