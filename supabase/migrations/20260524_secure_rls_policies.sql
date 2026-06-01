-- BoutiFlow pre-release security hardening.
-- Run after existing Apple users/business rows are linked with user_id.

create or replace function public.boutiflow_owns_business_row(
  row_user_id text,
  row_hotel_id text
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select auth.uid() is not null
    and (
      row_user_id = auth.uid()::text
      or row_hotel_id in (
        select h.id::text
        from public.hotels h
        where h.user_id::text = auth.uid()::text
      )
    );
$$;

create or replace function public.boutiflow_owns_user_row(
  row_id text,
  row_hotel_id text
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select auth.uid() is not null
    and (
      row_id = auth.uid()::text
      or row_hotel_id in (
        select h.id::text
        from public.hotels h
        where h.user_id::text = auth.uid()::text
      )
    );
$$;

create or replace function public.boutiflow_guard_user_plan_update()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.plan is distinct from old.plan
      and coalesce(auth.role(), '') <> 'service_role' then
    raise exception 'plan can only be updated by service role'
      using errcode = '42501';
  end if;

  return new;
end;
$$;

do $$
declare
  target_table text;
  policy_expression text;
  has_user_id boolean;
  has_hotel_id boolean;
  has_owner_id boolean;
  has_booking_id boolean;
  has_guest_id boolean;
begin
  if to_regclass('public.users') is not null then
    execute 'alter table public.users enable row level security';
    execute 'drop policy if exists "Allow all for anon" on public.users';
    execute 'drop trigger if exists boutiflow_guard_user_plan_update on public.users';
    execute $trigger$
      create trigger boutiflow_guard_user_plan_update
      before update of plan on public.users
      for each row
      execute function public.boutiflow_guard_user_plan_update()
    $trigger$;
    execute 'drop policy if exists boutiflow_users_own_rows on public.users';
    execute $policy$
      create policy boutiflow_users_own_rows
      on public.users
      for all
      using (public.boutiflow_owns_user_row(id::text, hotel_id::text))
      with check (public.boutiflow_owns_user_row(id::text, hotel_id::text))
    $policy$;
  else
    raise notice 'Skipping public.users because it does not exist';
  end if;

  foreach target_table in array array[
    'hotels',
    'rooms',
    'guests',
    'bookings',
    'expenses',
    'finances',
    'payments',
    'room_types',
    'guest_documents',
    'message_templates',
    'messages_log'
  ]
  loop
    if to_regclass(format('public.%I', target_table)) is null then
      raise notice 'Skipping public.% because it does not exist', target_table;
      continue;
    end if;

    execute format(
      'alter table public.%I enable row level security',
      target_table
    );
    execute format(
      'drop policy if exists "Allow all for anon" on public.%I',
      target_table
    );

    select exists (
      select 1
      from information_schema.columns c
      where c.table_schema = 'public'
        and c.table_name = target_table
        and c.column_name = 'user_id'
    ) into has_user_id;

    select exists (
      select 1
      from information_schema.columns c
      where c.table_schema = 'public'
        and c.table_name = target_table
        and c.column_name = 'hotel_id'
    ) into has_hotel_id;

    select exists (
      select 1
      from information_schema.columns c
      where c.table_schema = 'public'
        and c.table_name = target_table
        and c.column_name = 'owner_id'
    ) into has_owner_id;

    select exists (
      select 1
      from information_schema.columns c
      where c.table_schema = 'public'
        and c.table_name = target_table
        and c.column_name = 'booking_id'
    ) into has_booking_id;

    select exists (
      select 1
      from information_schema.columns c
      where c.table_schema = 'public'
        and c.table_name = target_table
        and c.column_name = 'guest_id'
    ) into has_guest_id;

    if target_table = 'hotels' then
      policy_expression :=
        'public.boutiflow_owns_business_row(user_id::text, id::text)';
    elsif has_user_id and has_hotel_id then
      policy_expression :=
        'public.boutiflow_owns_business_row(user_id::text, coalesce(hotel_id::text, user_id::text))';
    elsif has_hotel_id then
      policy_expression :=
        'public.boutiflow_owns_business_row(null, hotel_id::text)';
    elsif has_user_id then
      policy_expression :=
        'public.boutiflow_owns_business_row(user_id::text, user_id::text)';
    elsif has_owner_id then
      policy_expression :=
        'auth.uid() is not null and owner_id::text = auth.uid()::text';
    elsif has_booking_id then
      policy_expression :=
        'exists (
          select 1
          from public.bookings b
          where b.id::text = booking_id::text
            and public.boutiflow_owns_business_row(b.user_id::text, b.hotel_id::text)
        )';
    elsif has_guest_id then
      policy_expression :=
        'exists (
          select 1
          from public.guests g
          where g.id::text = guest_id::text
            and public.boutiflow_owns_business_row(g.user_id::text, g.hotel_id::text)
        )';
    else
      raise notice 'Skipping %.% because it has no owner column',
        'public',
        target_table;
      continue;
    end if;

    execute format(
      'drop policy if exists boutiflow_%s_own_rows on public.%I',
      target_table,
      target_table
    );
    execute format(
      'create policy boutiflow_%s_own_rows on public.%I for all using (%s) with check (%s)',
      target_table,
      target_table,
      policy_expression,
      policy_expression
    );
  end loop;
end $$;
