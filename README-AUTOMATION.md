# Matchday Vault V14 — Cloud & Email Automation

This build remains local-first. Nothing is sent anywhere until you configure Supabase in **Sync & Automation**.

## 1) Create Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. In Authentication, enable Email (magic-link sign-in is enough).
4. In Matchday Vault > Sync & Automation, paste the Project URL and the public anon/publishable key. Do **not** paste the service-role key into the app.
5. Send yourself a magic link from Matchday Vault, sign in, then use Push/Pull.

## 2) Gmail automation (server-side)
The included `supabase/functions/gmail-sync/index.ts` is designed for Supabase Edge Functions. It can run even when the phone/app is closed.

You still need to complete Google OAuth once so a Gmail refresh token can be stored server-side. Store Google client credentials as Supabase function secrets (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`). Never put the Google client secret or Gmail password in GitHub Pages.

The worker searches for Arsenal, Liverpool, Manchester United, Ticombo, 1BoxOffice, ticket, booking and ballot messages. It classifies them and writes `inbox_events`. Low-confidence items are marked `needs_review` instead of inventing data.

## 3) Scheduling
After deploying the function, schedule it from Supabase/your scheduler at a reasonable interval (for example every 10–15 minutes). The app's Sync Centre can also invoke it manually.

## Security
- Login Vault passwords stay local unless you explicitly enable password sync.
- Supabase tables use Row Level Security for user-owned operational data.
- Gmail refresh tokens are server-side only and have no client read policy.
- Never place a service-role key, Gmail password, Google client secret, full card number or CVV in `index.html`.
