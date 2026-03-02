# CheckMate — Going Live with Real Data

## Architecture Overview

The app is built with a clean separation between mock and real data. Every API call goes through `VehicleCheckRepository` (an abstract interface). Currently `MockVehicleService` implements it. To go live, you create a `RealVehicleService` implementing the same interface and swap the provider in `app_providers.dart`. Zero UI changes needed.

```dart
// In lib/core/providers/app_providers.dart, change:
final vehicleCheckRepositoryProvider = Provider<VehicleCheckRepository>((ref) {
  return RealVehicleService(); // was MockVehicleService()
});
```

---

## Data Sources You Need

### 1. DVLA Vehicle Enquiry Service (VES) API — FREE
**What it gives you:** Make, model, year, colour, fuel type, CO2, tax status, MOT status, engine size, date of first registration
**How to get it:**
- Register at https://developer-portal.driver-vehicle-licensing.api.gov.uk/
- Apply for API key (takes 1-2 business days)
- Rate limit: 10 requests/second
- Cost: **Free**
- This replaces the basic vehicle data in your mock

### 2. DVSA MOT History API — FREE
**What it gives you:** Full MOT history including dates, pass/fail, mileage at each test, advisories, failures, test location
**How to get it:**
- Register at https://dvsa.github.io/mot-history-api-documentation/
- Get API key (instant to 24 hours)
- Cost: **Free**
- This is the single best free data source — real MOT history is incredibly valuable

### 3. Premium Data — Experian AutoCheck / CDL VIS / HPI API
**What it gives you:** Outstanding finance, stolen status (PNC), insurance write-off (MIAFTR), V5C data, keeper history, plate changes, import/export, scrapped status
**How to get it:**
- **Experian AutoCheck**: Contact experian.co.uk/business — enterprise sales, expect £0.50-£2.00 per check depending on volume. Minimum contract.
- **CDL Vehicle Information Services**: cdl.co.uk — aggregator, similar pricing. More SME-friendly.
- **HPI Data**: hpi.co.uk/business — the original. Premium pricing but most recognised brand. £1-3 per check.
- **Cazana / Cap HPI**: Now merged. Contact cap-hpi.com for valuations + history data combined.

**Recommendation:** Start with **CDL VIS** — they're the most accessible for startups, have good documentation, and offer all the premium data points in one API. Experian is the gold standard but requires more business credentials.

**Expected cost per full check:** £1.50-£3.00 depending on provider and volume commitments.

### 4. Vehicle Valuations — CAP HPI / Glass's Guide
**What it gives you:** Trade-in, private sale, dealer retail, and forecourt prices. Condition-adjusted. Monthly updates.
**How to get it:**
- **CAP HPI**: cap-hpi.com — industry standard. Subscription model, typically £500-2000/month depending on volume.
- **Glass's Guide**: glass.co.uk — alternative to CAP. Similar pricing.
- **AutoTrader Retail Rating**: Contact AutoTrader for API access — gives live market pricing based on actual listings.

**Recommendation for MVP:** Use the **DVLA + MOT APIs (free)** to populate real basic data, then estimate valuations from AutoTrader listings data. Upgrade to CAP HPI when revenue justifies it.

### 5. Euro NCAP Safety Ratings
**What it gives you:** Adult, child, pedestrian, safety assist scores + overall star rating
**How to get it:**
- Public data at euroncap.com — no API, but you can build a static database from their published results
- Or use a third-party that includes it (CDL VIS often bundles this)

### 6. Safety Recalls — DVSA
**What it gives you:** Outstanding safety recalls for the specific vehicle
**How to get it:**
- Check recalls at https://www.check-vehicle-recalls.service.gov.uk/
- No public API — would need to scrape or use a data provider that includes it

---

## Implementation Roadmap

### Phase 1: Free Data (Week 1) — £0 cost
1. Apply for DVLA VES API key
2. Apply for DVSA MOT History API key
3. Create `RealVehicleService` that calls both APIs
4. Map DVLA response → `VehicleCheckResult` basic fields
5. Map MOT History response → `MOTHistory` entity with full test data
6. This alone gives you a genuinely useful FREE check product

### Phase 2: Premium Data (Week 2-4) — £500-2000 setup
1. Sign contract with CDL VIS or Experian
2. Implement finance check (the most requested premium data point)
3. Implement stolen vehicle check
4. Implement insurance write-off check
5. Implement mileage verification (compare MOT readings for anomalies)
6. This enables your £4.99 and £9.99 paid tiers

### Phase 3: Valuations (Week 4-6) — £500-2000/month
1. Integrate CAP HPI or Glass's for real valuations
2. Add AutoTrader live market data
3. Build the "We Buy Any Car" estimate algorithm (their prices are roughly 85% of private sale CAP value)
4. This makes the valuation feature real

### Phase 4: Payments (Week 2, parallel) — 1.4% + 20p per transaction
1. Create Stripe account at stripe.com
2. Replace mock payment flow with real Stripe SDK
3. Add `stripe_sdk` Flutter package
4. Implement payment intents on your backend
5. You need a backend server for this — see Backend section below

---

## Backend Requirements

You need a simple backend to:
1. **Proxy API calls** — Don't expose API keys in the Flutter app. Route through your server.
2. **Handle Stripe payments** — Create payment intents server-side.
3. **Cache results** — Store check results so users can retrieve them offline.
4. **User accounts** — Auth, saved vehicles, check history.

**Recommended stack:**
- **Cloudflare Workers** (you're already on Cloudflare) or **Node.js on Railway/Render**
- **Supabase** for database + auth (generous free tier, Postgres)
- **Stripe webhooks** endpoint

Minimal backend flow:
```
Flutter App → Your API (Cloudflare Worker) → DVLA/CDL/Stripe APIs
                    ↓
              Supabase DB (cache results, user accounts)
```

---

## Revenue Model

| Check Type | Price | Your API Cost | Gross Margin |
|---|---|---|---|
| Free (DVLA + MOT) | £0 | £0 | Lead generation |
| Standard | £4.99 | ~£1.50 | £3.49 (70%) |
| Full Check | £9.99 | ~£2.50 | £7.49 (75%) |
| 3-Pack | £12.99 | ~£7.50 | £5.49 (42%) |
| Valuation Only | £2.99 | ~£0.50 | £2.49 (83%) |

At 1,000 checks/month: **~£5,000-7,500 gross revenue**
At 10,000 checks/month: **~£50,000-75,000 gross revenue**

The free check (DVLA + MOT) is your customer acquisition funnel. Users get real value for free, then upgrade for finance/stolen/write-off checks.

---

## Legal Requirements

1. **Data Protection**: Register with ICO as a data controller. GDPR compliance for storing vehicle check data.
2. **Consumer Rights**: Clear refund policy. The £10k data guarantee needs backing — consider professional indemnity insurance.
3. **FCA**: If you're providing financial information (finance checks), ensure you're not giving regulated advice.
4. **Terms of Service**: Clear that valuations are estimates, not guarantees.
5. **Privacy Policy**: Required for app stores. Disclose what data you collect and why.

---

## App Store Submission

### iOS (Apple App Store)
- Apple Developer Account: £79/year
- Build: `flutter build ios --release`
- Submit via Xcode → App Store Connect
- Review takes 1-3 days typically
- Needs privacy nutrition labels

### Android (Google Play)
- Google Play Developer Account: $25 one-time
- Build: `flutter build appbundle --release`
- Submit via Play Console
- Review takes 1-7 days
- Needs data safety form

### Web (Already deployed)
- Already live at https://checkmate-app.pages.dev/
- Consider custom domain: checkmate.uk or checkmatecar.co.uk

---

## Quick Start: Go Live in 48 Hours

The fastest path to a real, revenue-generating product:

1. **Today**: Apply for DVLA VES + DVSA MOT API keys
2. **Tomorrow**: Build `RealVehicleService` for free data (basic check + MOT history)
3. **Day 2**: Set up Stripe account, implement real payments
4. **Day 2**: Deploy with free checks + Stripe → you now have a revenue-generating product
5. **Week 2**: Sign with CDL VIS for premium data → enable paid checks
6. **Week 3**: Submit to App Store + Play Store

You can be generating revenue within 48 hours using just the free DVLA/MOT APIs + Stripe.
