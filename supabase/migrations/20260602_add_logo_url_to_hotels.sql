-- Migration: Add logo_url column to hotels table
-- Run this SQL in your Supabase SQL Editor to support profile picture cloud sync.

ALTER TABLE public.hotels ADD COLUMN IF NOT EXISTS logo_url TEXT;

-- Reload schema cache to make sure PostgREST is aware of the new column immediately
NOTIFY pgrst, 'reload schema';
