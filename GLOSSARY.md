# Trial viewer

A local copy of trials from the warehouse, kept so they can be exported for analysis.

## Language

**Warehouse**:
The external store of posted trial JSON. Each stored post is one item, identified by a UUID.
_Avoid_: Pipeline, remote database

**Trial**:
One warehouse item, identified by that item's UUID, whatever was posted. There is only one Trial for a UUID. It records its start time. Once stored, it does not change.
_Avoid_: Item, row

**Cookie trial**:
The posted JSON for one listening attempt, when that is what the item contains. The Trial keeps that object in full. Score, cookie, and audio file hash may be empty.
_Avoid_: Trial, payload

**Start time**:
The listening session's start time on a cookie trial. A Trial stores it as a UTC timestamp converted from the cookie trial's epoch milliseconds. Every Postgres date filter uses this column alone. When an export uses a date range, a Trial with no start time is omitted.
_Avoid_: Created at warehouse, posted at, warehouse created-at, updated at

**Synchronize**:
Discovering warehouse items by warehouse created-at when the form has dates, then storing each that is not already a Trial. Both dates blank means every warehouse item is a candidate. One blank date is an open bound. Local date filters never use warehouse created-at.
_Avoid_: Sync, import, refresh

**Export**:
Trials selected by start time when the form has dates, otherwise every Trial. One blank date is an open bound. Each row is `uuid`, `start_time`, `score`, `cookie`, `audio_file_hash`, ordered by start time then uuid, with missing start times last, and omits the cookie trial body.
_Avoid_: Dump, backup

**Cookie**:
The anonymous browser identifier on a cookie trial.
_Avoid_: HTTP cookie, session

**Score**:
The listener's result on a cookie trial, from 0 to 1.
_Avoid_: Correctness, grade

**Audio file hash**:
The midpoint sample of the audio buffer recorded on a cookie trial.
_Avoid_: Audio file id
