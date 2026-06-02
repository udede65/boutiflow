-- Migration: Add hourly booking fields and change check_in/check_out column types
-- Run this script in your Supabase SQL Editor to enable hourly booking cloud sync.

ALTER TABLE public.bookings ALTER COLUMN check_in TYPE timestamptz USING check_in::timestamptz;
ALTER TABLE public.bookings ALTER COLUMN check_out TYPE timestamptz USING check_out::timestamptz;
ALTER TABLE public.bookings ADD COLUMN IF NOT EXISTS is_hourly BOOLEAN DEFAULT FALSE;

-- Force postgrest schema reload to catch new types and column
NOTIFY pgrst, 'reload schema';
