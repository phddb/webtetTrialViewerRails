# Form dates mean two things

Synchronize discovers warehouse items by warehouse created-at. Every local Postgres filter uses `start_time`, because the warehouse cannot filter on listening session time. Date fields may be blank: both blank means no time filter; one blank is an open bound; both filled requires start on or before end.
