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
