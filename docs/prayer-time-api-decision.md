# Prayer-Time API Decision (Issue #9)

Date: 2026-03-03

## 1. Decision Summary
- Primary provider: **AlAdhan Prayer Times API**
- Fallback provider: **ezanvakti.emushaf.net** (community adapter)
- Turkey official-source feasibility status: **no public, officially documented Diyanet prayer-time API contract confirmed for direct app integration**

## 2. Why This Decision
AlAdhan is selected for MVP because it has:
- Public OpenAPI specification.
- Stable daily/monthly prayer-time endpoints.
- Explicit calculation-method support including Turkey/Diyanet (`method=13`).
- Working live responses for Istanbul with timezone metadata.

## 3. Live Verification Snapshot (2026-03-03)

## 3.1 AlAdhan
- OpenAPI doc available: `https://api.aladhan.com/v1/documentation/openapi/prayer-times/yaml`
- Methods endpoint includes Turkey/Diyanet:
  - `GET https://api.aladhan.com/v1/methods`
  - Includes method id `13` and name `Diyanet İşleri Başkanlığı, Turkey (experimental)`
- Daily timings by city work:
  - `GET https://api.aladhan.com/v1/timingsByCity?city=Istanbul&country=Turkey&method=13`
  - Returns `code: 200`, timezone `Europe/Istanbul`, Fajr/Isha values.
- Monthly calendar by city works:
  - `GET https://api.aladhan.com/v1/calendarByCity/2026/3?city=Istanbul&country=Turkey&method=13`
  - Returns 31-day list for March 2026.

## 3.2 Turkey/Government Sources
- Official Diyanet prayer-times website exists (`namazvakitleri.diyanet.gov.tr`).
- During this validation, a direct public API contract suitable for app integration was not confirmed from official Diyanet prayer-time documentation.
- `acikkaynakkuran-dev.diyanet.gov.tr` is reachable, but content is **Quran API service** (not a published prayer-time API contract for this module).

## 3.3 Turkey Community Source
- `https://ezanvakti.emushaf.net/docs` exposes Swagger/OpenAPI.
- OpenAPI declares endpoints for country/city/district/prayer-times and indicates data sourced from Diyanet publication.
- Treated as **community/unofficial adapter** for fallback use.

## 3.4 Secondary Alternative
- MuslimSalat remains available but its FAQ currently still shows `last updated: 31st March, 2019`, creating maintenance/operational risk for primary use.

## 4. Provider Matrix
| Criterion | AlAdhan | ezanvakti.emushaf.net | MuslimSalat |
|---|---|---|---|
| Public API contract | Yes (OpenAPI) | Yes (OpenAPI) | Partial docs |
| Daily timings | Yes | Yes | Yes |
| Monthly calendar | Yes | Via list endpoints | Limited |
| Method configuration | Yes (`method` incl. 13) | Diyanet-oriented dataset | Limited |
| Official government API | No | No (community) | No |
| API key required | No (free, keyless) | No (keyless) | Yes (free key) |
| Rate limits/quotas | ~3,600 req/h per IP (documented); daily and monthly endpoints count toward quota | Not publicly documented; community-operated capacity unknown | Not publicly documented |
| Caching policy | Responses may be cached; re-fetching identical requests counts against quota | No explicit policy; cache strongly recommended given unofficial nature | Not publicly documented |
| ToS / Licensing | Free for non-commercial and commercial use; attribution encouraged; no redistribution of bulk data | No formal ToS; community service, no SLA guarantee | Free for non-commercial use; commercial use requires permission |
| MVP suitability | **Primary** | **Fallback** | Backup only |

## 5. Normalized Data Contract
Repository output contract:

```text
PrayerDay {
  date: LocalDate,
  timezone: String,
  method: String,
  fajr: LocalTime,
  sunrise: LocalTime,
  dhuhr: LocalTime,
  asr: LocalTime,
  maghrib: LocalTime,
  isha: LocalTime,
}
```

Mapping rules:
- AlAdhan -> `timings.Fajr/Sunrise/Dhuhr/Asr/Maghrib/Isha`, `meta.timezone`, `meta.method.name`, `date.gregorian.date`.
- EzanVakti adapter -> `Imsak->Fajr`, `GunesDogus->Sunrise`, `Ogle->Dhuhr`, `Ikindi->Asr`, `Aksam->Maghrib`, `Yatsi->Isha`, plus local timezone from location config.

## 6. Fallback Strategy
1. Try AlAdhan for daily/monthly fetch.
2. If request/network/provider failure threshold is exceeded, switch to fallback adapter (`ezanvakti.emushaf.net`) for Turkey-supported flows.
3. Keep provider abstraction in data layer:
   - `PrayerTimesDataSource`
   - `AlAdhanDataSource`
   - `EzanVaktiDataSource`
4. Persist source metadata with cached records to trace origin.

## 7. Risks and Mitigations
- AlAdhan method 13 marked as experimental.
  - Mitigation: allow per-user method override in settings (issue #15) and compare with local mosque times.
- Community fallback is unofficial.
  - Mitigation: feature-flag fallback and monitor response consistency.
- API schema or availability changes.
  - Mitigation: parser tests + response validation + offline cache (issue #11/#16).
- **Rate limits / quotas**: AlAdhan enforces ~3,600 requests/h per IP; ezanvakti quotas are undocumented (community service).
  - Mitigation: cache daily and monthly responses locally (issue #11/#16); implement request de-duplication; alert on 429 responses.
- **Caching policy**: Repeatedly fetching identical prayer-time data wastes quota and may trigger throttling.
  - Mitigation: persist provider responses with a TTL keyed by date/city/method; refresh only when TTL expires or user forces refresh.
- **API key / authentication**: Both AlAdhan and ezanvakti currently require no API key, reducing onboarding friction but also meaning no per-key quota management.
  - Mitigation: abstract authentication behind a provider config so a key can be injected via env/secret if either provider introduces key-gated tiers in future.
- **ToS / Licensing**: AlAdhan is free for commercial use with attribution encouraged; ezanvakti has no formal ToS or SLA; MuslimSalat restricts commercial use.
  - Mitigation: review AlAdhan terms before GA release; do not rely on ezanvakti in commercial contexts without explicit approval; document chosen provider and terms in release notes.

## 8. Final Recommendation
- Lock **AlAdhan** as MVP primary provider now.
- Keep **community Diyanet-based adapter** as optional fallback for Turkey.
- Do not block delivery on official Diyanet API discovery; continue periodic checks for any newly published official contract.

## Sources
- https://api.aladhan.com/v1/documentation/openapi/prayer-times/yaml
- https://api.aladhan.com/v1/methods
- https://api.aladhan.com/v1/timingsByCity?city=Istanbul&country=Turkey&method=13
- https://api.aladhan.com/v1/calendarByCity/2026/3?city=Istanbul&country=Turkey&method=13
- https://aladhan.com
- https://ezanvakti.emushaf.net/docs
- https://ezanvakti.emushaf.net/openapi.json
- https://www.muslimsalat.com/api/
- https://www.muslimsalat.com/api/faq.php
- https://acikkaynakkuran-dev.diyanet.gov.tr/
