# ChainAlert - Design System

Bright, modern, trustworthy fintech mobile app for real-time blockchain event alerts. Light near-white surfaces, one vivid emerald accent, clean data cards, crisp numerals.

## Colors
- Background: #F6F8FB (near-white app canvas)
- Surface / cards: #FFFFFF
- Accent (primary): #0E9F6E (vivid emerald - primary actions, active states, live indicators, key values)
- Accent tint: #D9F5EA (soft fills, badges, selected chips)
- Positive / inflow: #0E9F6E
- Negative / outflow / destructive: #E5484D
- Warning / threshold tag: #F5A623
- Text primary: #0F172A
- Text secondary: #64748B
- Divider / border: #E6EAF0

## Typography
- Font family: Inter (geometric humanist sans)
- Large title: 28px / bold
- Screen heading: 22px / bold
- Card title: 16px / semibold
- Body: 15px / regular
- Caption / meta: 13px / medium, secondary color
- Numerals: tabular, semibold for amounts and thresholds

## Shape & spacing
- Corner radius: 16px cards, 12px inputs/chips, pill (full) buttons
- Soft shadows: y2 blur12 rgba(15,23,42,0.06)
- Spacing: 8pt scale, generous 20px screen side padding
- Frame: 390x844 mobile

## Buttons
- Primary: emerald #0E9F6E fill, white text, pill, full-width
- Secondary: white fill, #E6EAF0 border, primary text
- Destructive: text-only #E5484D

## Components
- Alert card: avatar (token/wallet), bold event title, entity name, relative time, threshold tag chip, unread emerald dot
- Entity row: avatar, name + short address, active-rules count, 24h alert badge, chevron
- Rule card: condition text, event-type toggles, threshold value, direction selector
- Live chip: small emerald dot + "Live" label, indicates real-time stream connected
- Plan card: price, period, benefit checklist, best-value emerald badge

## Shared components
### Bottom tab bar (MANDATORY, identical on the 3 primary screens)
Exactly THREE tabs, in this exact order:
1. Feed - activity/bell icon
2. Tracked - eye/watchlist icon
3. Settings - gear icon
Active tab: emerald #0E9F6E icon + label. Inactive tabs: neutral grey #64748B. White bar, top divider #E6EAF0, safe-area padding. Never rename, reorder, add, or remove tabs. Only the three primary screens (feed, tracked-entities, settings) show this bar. All onboarding, paywall, modal, detail, and rules screens hide the bottom tab bar entirely.

### Top area
Light near-white header, bold screen title left-aligned. On live/streaming screens show a small emerald dot + "Live" chip. Modals use a centered grabber handle and a title.
