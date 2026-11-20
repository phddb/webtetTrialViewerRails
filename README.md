webtet-trail-viewer-rails is an app that transforms raw trial data from our data warehouse (https://jsontocsvpipeline.onrender.com/) into csv files suitable for EDA and statistical analysis. 

Its backend is written in Rails and its frontend is written in React.

Its frontend contains a simple form specifying a date range to synchronize over, and a synchronize button. The synchronize button syncronizes the app's local postgres database with the warehouse. Pressing this button first calls the data warehouse to retrieve the ids of all trials in the date range. Then, for any id not already present in postgres, it launches a sidekiq worker. The sidekiq worker retrieves the item, and saves the relevant fields to postgres.

For now, local database (and the "trial" model) only contains the columns "uuid" (matching the warehouse id), score, cookie, audio_file_id, and raw (containing the raw cookie_trial object).

The frontend also contains a "export" button, which exports the contents of the local database (except the "raw" column) as a csv.

Source code for the data warehouse is here /Users/davebenson/git/jsonToCsvPipeline; the live app to contact is here https://jsontocsvpipeline.onrender.com/.