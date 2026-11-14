# Migration Replay

Run the same Postgres migration twice. The first database starts empty. The second already has a checked-in attendee at Community Build Night. This catches a release that works for new installations and fails for existing organizers.

[Open the example pull request](https://github.com/thsonvt/migration-replay/pull/1) to inspect the SQL change and its GitHub Actions check.

## Try the failing migration

From the repo root, run this with Python 3 and a running Docker engine. The first run downloads a pinned PostgreSQL 17 image.

```sh
./replay examples/eventops/require-source.sql
```

The migration adds a required field to registrations.

```sql
alter table public.registrations add column registration_source text not null;
```

PostgreSQL reports the two outcomes.

```text
fresh PASS | existing registrations: 0 | migration and assertions passed
upgrade FAIL | existing registrations: 1 | migration
psql:<stdin>:1: ERROR:  23502: column "registration_source" of relation "registrations" contains null values
```

A new registration can supply its source. An earlier registration has no recorded source. PostgreSQL rejects the change before it can enforce the constraint on that row.

## Try a compatible migration

For this fictional event, the organizer accepts `unknown` as the source for historical registrations. The [proposed migration](examples/eventops/proposed.sql) adds a nullable column, backfills the existing rows, then makes the column required. Future inserts must supply a value.

```sh
./replay examples/eventops/proposed.sql
```

Both runs pass. The upgrade check verifies the original registration ID, organization, event, attendee, check-in status, timestamp, and backfilled value. Both paths also check the column's type and nullability and insert a new registration with a supplied source. [Schema checks](examples/eventops/check.sql) · [Historical row check](examples/eventops/check-existing.sql)

## How the check works

Each run starts its own disposable Postgres container, applies the same EventOps baseline, and applies the candidate SQL in one transaction. The upgrade path commits the [fictional registration](examples/eventops/existing.sql) before applying the candidate. The runner checks the outcome inside each database and removes the containers when finished. It uses a small relational subset of EventOps, and fictional records. Docker runs each database with networking disabled and communicates over its local socket.

The command exits with `0` when both paths pass, `1` when the migration or a database assertion fails, and `2` on a setup or runtime error. On pull requests, GitHub Actions runs the candidate in `examples/eventops/proposed.sql`. A separate regression test checks that the known-bad example produces the specific PostgreSQL error on the upgrade path.

The project grew out of a Supabase Evals case where Codex edited a previously applied migration and reset the local database. This first example exercises a different failure and checks whether an existing installation can take the change. [Supabase Evals PR #80](https://github.com/supabase/evals/pull/80)
