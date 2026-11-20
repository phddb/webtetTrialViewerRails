import React, { useState } from "react"

function csrfToken() {
  const meta = document.querySelector('meta[name="csrf-token"]')
  return meta ? meta.content : ""
}

export default function App() {
  const [startDate, setStartDate] = useState("")
  const [endDate, setEndDate] = useState("")
  const [message, setMessage] = useState("")
  const [error, setError] = useState("")
  const [syncing, setSyncing] = useState(false)

  async function synchronize(event) {
    event.preventDefault()
    setSyncing(true)
    setError("")
    setMessage("")

    try {
      const response = await fetch("/synchronization", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
          "X-CSRF-Token": csrfToken()
        },
        body: JSON.stringify({
          start_date: startDate,
          end_date: endDate
        })
      })

      const data = await response.json()
      if (!response.ok) {
        throw new Error(data.error || "Synchronize failed")
      }

      setMessage(
        `Already stored: ${data.already_stored}. Queued: ${data.queued}.`
      )
    } catch (err) {
      setError(err.message)
    } finally {
      setSyncing(false)
    }
  }

  function exportCsv(event) {
    event.preventDefault()
    setError("")

    const params = new URLSearchParams()
    if (startDate) params.set("start_date", startDate)
    if (endDate) params.set("end_date", endDate)

    const query = params.toString()
    window.location.href = query ? `/export?${query}` : "/export"
  }

  return (
    <main className="page">
      <h1>Webtet Trial Viewer</h1>
      <p className="lede">
        Synchronize trials from the warehouse, then export them as CSV for analysis.
      </p>

      <form className="panel" onSubmit={synchronize}>
        <label>
          Start date
          <input
            type="date"
            value={startDate}
            onChange={(event) => setStartDate(event.target.value)}
          />
        </label>

        <label>
          End date
          <input
            type="date"
            value={endDate}
            onChange={(event) => setEndDate(event.target.value)}
          />
        </label>

        <div className="actions">
          <button type="submit" disabled={syncing}>
            {syncing ? "Synchronizing…" : "Synchronize"}
          </button>
          <button type="button" onClick={exportCsv}>
            Export
          </button>
        </div>
      </form>

      {message ? <p className="status ok">{message}</p> : null}
      {error ? <p className="status error">{error}</p> : null}
    </main>
  )
}
