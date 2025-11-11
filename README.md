# transfer-form
digitized transfer form
# Transfer Form – 5‑Signer Workflow (Version B: Custom Web App)

This is a deployable full‑stack app to digitize the **Transfer/Change Schedule Request** form with **up to 5 signers** in sequence:
1) Employee
2) Current Supervisor
3) Current Program Director
4) New Supervisor
5) New Program Director

**Flow**
- Employee submits the form and signs.
- The system emails a unique, signed link to the Current Supervisor.
- Each signer reviews, signs, and (if applicable) chooses YES/NO + reason.
- After the final signer completes, a **PDF** is generated and emailed to all parties + HR.

**Stack**
- **Frontend:** React (Vite), react-router, react-signature-canvas
- **Backend:** Node.js + Express, node-postgres (`pg`), CORS
- **Email:** SendGrid (Transaction emails with magic links)
- **PDF:** `pdfkit` (pure Node; no headless browser needed)
- **Deploy:** Frontend on Vercel (static). Backend on Railway (or Render/Fly/Heroku). PostgreSQL on Railway.

---

## 1) Quick Start (Local)

### Prereqs
- Node 18+
- PostgreSQL 14+
- A SendGrid API key for email (or leave unset to log to console during dev)

### Setup DB
Create a database and run the schema:
```bash
createdb transfer_form_db
psql transfer_form_db -f backend/src/schema.sql
```

### Backend
```bash
cd backend
cp .env.example .env  # then edit values
npm install
npm run dev
```

### Frontend
```bash
cd ../frontend
npm install
npm run dev
```
Visit: http://localhost:5173

---

## 2) Environment Variables

Create `backend/.env` from `.env.example`:

```
DATABASE_URL=postgres://USER:PASSWORD@HOST:PORT/transfer_form_db
SENDGRID_API_KEY=
FROM_EMAIL=hr@yourorg.org
FROM_NAME=HR Team
APP_BASE_URL=http://localhost:5173
API_BASE_URL=http://localhost:3001
HR_NOTIFICATIONS=hr@yourorg.org
```

- If `SENDGRID_API_KEY` is empty, the backend **logs emails** to the console for development.
- `APP_BASE_URL` is where the **frontend** lives.
- `API_BASE_URL` is where the **backend** lives.

---

## 3) Deploy

### Backend (Railway)
1. Push `backend/` to a GitHub repo.
2. In Railway, create a new project → **Deploy from GitHub** (select your repo).
3. Create a **PostgreSQL** database in Railway and copy its connection string.
4. Set backend variables in Railway project settings:
   - `DATABASE_URL` (from Railway Postgres)
   - `SENDGRID_API_KEY` (from SendGrid)
   - `FROM_EMAIL`, `FROM_NAME`
   - `APP_BASE_URL` (your Vercel frontend URL)
   - `API_BASE_URL` (Railway service URL)
   - `HR_NOTIFICATIONS`
5. Deploy. Railway will build and run `npm start`.

### Frontend (Vercel)
1. Push `frontend/` to GitHub.
2. Import to Vercel → Framework preset **Vite**.
3. Environment variables (Build & Runtime):
   - `VITE_API_BASE_URL` = Backend URL (Railway)
4. Deploy and test.

---

## 4) Notes

- This starter uses **magic-link tokens** for each signer. Each email contains a URL like:
  `https://your-frontend/sign/<token>` which gives access to the signing page.
- Tokens expire once used (or when the next signer completes).
- The PDF is a clean, structured rendering of the fields + signatures.
- For production, consider adding **email domain allow-lists** and **single-use token TTLs**.

---

## 5) Mapping to Source PDF

This build digitizes the fields from the provided Transfer/Change Schedule Request and preserves
all approval checkpoints (two supervisors + two program directors). You can tweak labels in the frontend form and the PDF renderer to match the exact layout.
