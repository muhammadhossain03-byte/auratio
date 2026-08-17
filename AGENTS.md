# AGENTS.md — Auratio (CSE311L, NSU, Section 3, Group 9)

Standing rules for any agent in this repo.

**This file overrides `docs/BUILD_PLAN.md` wherever they disagree.** Read the plan only for
§4.2 (the DDL), §4.4 (seed data spec), and §4.5 (verification queries). Ignore its frontend
and API sections — they describe a larger build than this one.

---

## Hard constraints

1. **MySQL/MariaDB via XAMPP.** No other database, ever.
2. **XAMPP Apache hosts it.** Project lives in `C:\xampp\htdocs\auratio\`.
3. **PHP 8 + PDO.** Plain `.php` files in `api/`. No framework, no Composer.
4. **No build step.** No npm, no bundler, no Docker. Clone + XAMPP must be enough.
5. **Frontend: one `index.html`, Tailwind via CDN script tag, vanilla ES modules.**
   No React, Vue, or Flutter.
6. **All paths relative** (`./assets/...`). Root-absolute paths 404 on GitHub Pages.
7. **PDO prepared statements only.** Never interpolate a variable into SQL.

## The database is frozen and is the whole point

`database/schema.sql` mirrors an ERD already submitted to the instructor.

- **All 22 tables get built,** with every constraint. Non-negotiable, worth 10 marks alone.
- Do not add, rename, drop, or retype anything. Do not "simplify" or "normalise further".
- Expected totals: **22 tables · 22 primary keys · 29 foreign keys · 9 unique constraints ·
  14 CHECK constraints.** If a verification query returns anything but 29 foreign keys,
  something drifted — stop and report it.
- ERD uses PascalCase, tables use snake_case (`UserAccount` → `user_account`). Not a change.

## The application is deliberately small

The rubric requires all four CRUD operations working against real MySQL. It does not require
CRUD on 22 tables, or more than one page. Build exactly this and nothing more.

**Full CRUD (4 tables):** `user_account`, `curriculum`, `speech_submission`, `community_event`

**Create + Read only (3 tables):** `evaluation`, `curriculum_enrollment`, `event_registration`

**Read-only everywhere else (15 tables).** Seeded, displayed, never edited. Reference tables
are administrative configuration — do not build edit forms for them.

**One page, five tabs:** Dashboard · Users · Curricula · Submissions · Community.
Single `index.html`. Tabs swap a content div. No routing library, no separate HTML files.

**Seven API files total:**
- `api/db.php` — PDO connection, JSON response helpers, and one shared `crud()` function the
  endpoints call with a table name and an allowed-column list. Column names come from that
  hardcoded list, never from user input.
- `api/users.php`, `api/curricula.php`, `api/submissions.php`, `api/events.php` — full CRUD
- `api/evaluations.php` — create and read
- `api/lookups.php` — one GET returning all read-only tables plus dashboard stats

## Six features must be visible in the UI

| Feature | Where |
|---|---|
| 1 Structured curricula | Curricula tab — curriculum CRUD, modules listed read-only beneath each |
| 2 Practice submissions | Submissions tab — submission CRUD with video URI and attempt number |
| 3 AI or human evaluator | Add-evaluation form: a toggle that swaps one dropdown (agent vs evaluator) |
| 4 Progress dashboard | Dashboard tab — all figures computed by SQL, none stored |
| 5 Community events | Community tab — event CRUD plus registrations |
| 6 Role-based users | Users tab — user CRUD, role chips shown read-only |

## Never build

AI model calls of any kind. Video upload or playback. Login, sessions, or password reset.
Payments, certificates, notifications, chat, follows. An admin settings panel. A seventh feature.

`ai_specialist_agent` holds real seeded rows and `evaluation.agent_id` points at them, but no
model is ever called. An evaluation is a record. Its CHECK constraint enforces exactly one
source — AI agent or human evaluator, never both, never neither.

## No fake data in the app

The instructor's brief states hardcoded or fake data will not be accepted.

- Every row on screen comes from a `fetch` to `api/*.php` that ran a real query.
- **Design-tool HTML in `design/stitch/` contains hardcoded sample rows. Keep its markup and
  Tailwind classes; delete every literal row and re-render from the API.** This is the single
  most likely way to fail this project.
- The one exception is `data/demo-data.json`, a dump of the seeded database used only by the
  GitHub Pages demo mode, behind a visible banner.

## Two run modes

```js
const IS_PAGES = location.hostname.endsWith('github.io');
export const DEMO_MODE = IS_PAGES;                     // Pages: read data/demo-data.json
export const API_BASE  = IS_PAGES ? null : './api';    // Local: real PHP + MySQL
```

GitHub Pages cannot run PHP or reach MySQL, and an `https://*.github.io` page is blocked from
calling `http://localhost`. Demo mode must always show its banner.

## API conventions

`GET` list/read · `POST` create · `PUT` update · `DELETE` delete. Id via `?id=`.
Always respond `{"ok":true,"data":...}` or `{"ok":false,"error":{"message":"..."}}`.

Translate MySQL errors into sentences: `1062` → "That email is already registered."
`1451`/`1452` → "Cannot delete — other records reference this row." CHECK failure → name the rule.

Three writes the API must handle or MySQL will reject them:
- Enrollment or progress set to `Completed` must also set `completed_at`.
- Creating an evaluation must null the unused evaluator column, matching `evaluator_type`.
- Confirming a registration must count existing `Confirmed` rows against `capacity`.

## Delete behaviour is intentional

`CASCADE` where a child cannot exist without its parent. `RESTRICT` where history must survive —
a user who evaluated a submission cannot be deleted. **A blocked delete is a feature.** It gets
demonstrated during the graded review. Do not loosen the constraint or switch to soft deletes.

## Verification

A write is not done because a toast appeared. After every create, update, and delete:

- Query MySQL directly and confirm the row changed:
  `C:\xampp\mysql\bin\mysql -u root auratio_db -e "SELECT ..."`
- Use the browser to click the path a grader will click; capture the screenshot.
- Test the failure path too.

## Seeding

`seed.sql` inserts in the same order tables are created. Reversing it causes FK errors.
Rubric weights total exactly 100.00 per speech format. At least two users hold two roles. At
least one submission has three attempts with improving scores. At least one submission has two
evaluation rounds. Roughly 10–20 rows per table, no more. Bangladeshi names, Dhaka venues.

## Style

Match existing conventions. Don't reformat files you weren't asked to change. Don't write
summary markdown, changelogs, or progress reports unless asked. Don't backdate commits.

## Stop and ask

Anything that changes `schema.sql`. Anything that adds a feature. Anything that adds a
dependency, build step, or hosting service.


Never modify the database directly. Any change goes into schema.sql or seed.sql first, then re-run the file. The repo files must always reproduce the running database exactly.