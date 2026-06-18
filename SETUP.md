# Donahue Road Trip Tracker — Setup Guide

## What you're deploying
A single-page site that shows your live location, itinerary, and trip photos.
Family opens the link and sees everything. You tap one button to update your location.

---

## Step 1 — Set up Supabase (free, ~5 minutes)

1. Go to https://supabase.com and sign up (free)
2. Click **New project**, name it `donahue-trip`
3. Choose a region close to you (US East or West)
4. Once created, go to **Settings → API**
5. Copy two values — you'll need them shortly:
   - **Project URL** (looks like `https://xxxx.supabase.co`)
   - **anon / public key** (long string starting with `eyJ...`)

### Create the database tables

In your Supabase project, click **SQL Editor** and run this:

```sql
-- Location table (stores your current position)
create table location (
  id integer primary key,
  city text,
  latitude double precision,
  longitude double precision,
  updated_at timestamptz default now()
);

-- Insert a placeholder row
insert into location (id, city) values (1, 'Ogden, UT');

-- Itinerary table (stores editable stops)
create table itinerary (
  id integer primary key,
  data text,
  updated_at timestamptz default now()
);

insert into itinerary (id, data) values (1, '[]');

-- Photos table
create table photos (
  id uuid primary key default gen_random_uuid(),
  url text,
  location text,
  taken_at timestamptz default now()
);

-- Allow public read access
alter table location enable row level security;
alter table photos enable row level security;

alter table itinerary enable row level security;
create policy "Public read itinerary" on itinerary for select using (true);
create policy "Anon insert itinerary" on itinerary for insert with check (true);
create policy "Anon update itinerary" on itinerary for update using (true);

create policy "Public read location" on location for select using (true);
create policy "Public read photos" on photos for select using (true);
create policy "Anon insert location" on location for insert with check (true);
create policy "Anon update location" on location for update using (true);
create policy "Anon insert photos" on photos for insert with check (true);
```

### Create photo storage bucket

1. In Supabase, go to **Storage**
2. Click **New bucket**, name it `trip-photos`
3. Check **Public bucket** → Save
4. Go to **Storage → Policies** → add policy: allow public reads and anon inserts on `trip-photos`

---

## Step 2 — Add your Supabase keys to index.html

Open `index.html` and find these two lines near the bottom:

```js
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

Replace them with your actual values from Step 1:

```js
const SUPABASE_URL = 'https://xxxx.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Save the file.

---

## Step 3 — Deploy to Netlify (~2 minutes)

1. Go to https://app.netlify.com
2. Log in with your existing account
3. Click **Add new site → Deploy manually**
4. Drag the entire `donahue-trip` folder onto the upload area
5. Netlify will give you a URL like `random-name-123.netlify.app`
6. (Optional) Click **Site settings → Change site name** to set it to something like `donahue-trip-2026`

Your site is now live!

---

## Step 4 — Your two links

**Family link** (share this with everyone):
```
https://donahue-trip-2026.netlify.app
```

**Your owner link** (bookmark this on your phone — shows the Update button):
```
https://donahue-trip-2026.netlify.app?owner=true
```

The `?owner=true` parameter is what shows the "Update my location" button.
Family visiting the plain URL won't see it.

---

## Updating the site

If you want to change the itinerary or anything else, edit `index.html` locally and
drag the folder to Netlify again — it redeploys in seconds.

---

## How location updates work

1. You open your owner link on your phone
2. Tap **Update my location**
3. Your phone asks permission to share GPS — tap Allow
4. The app reverse-geocodes your coordinates to a city name
5. It saves to Supabase — family's page refreshes and shows your location

Family doesn't need to refresh manually — the page loads fresh location each time they open it.

---

## Questions?
The entire site is one HTML file (`index.html`) — everything is readable and editable.
No frameworks, no build step, no Node.js required.
