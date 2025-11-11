import React from 'react'
import { createRoot } from 'react-dom/client'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import App from './App.jsx'
import SignerView from './pages/SignerView.jsx'

const router = createBrowserRouter([
  { path: '/', element: <App />},
  { path: '/sign/:token', element: <SignerView /> }
])

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
)
