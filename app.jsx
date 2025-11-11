import React, { useState } from 'react'
import TransferForm from './components/TransferForm.jsx'

export default function App() {
  return (
    <div style={{ maxWidth: 960, margin: '24px auto', padding: 16 }}>
      <h1>Transfer / Change Schedule Request</h1>
      <TransferForm />
    </div>
  )
}
