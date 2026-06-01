import { serve } from 'https://deno.land/std@0.224.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.4';

const premiumProductIds = new Set([
  'boutiflow_premium_monthly',
  'boutiflow_premium_yearly',
]);

const premiumEventTypes = new Set([
  'INITIAL_PURCHASE',
  'NON_RENEWING_PURCHASE',
  'PRODUCT_CHANGE',
  'RENEWAL',
  'TEMPORARY_ENTITLEMENT_GRANT',
  'UNCANCELLATION',
]);

const freeEventTypes = new Set([
  'EXPIRATION',
  'REFUND',
  'SUBSCRIPTION_PAUSED',
]);

function normalizedString(value: unknown): string | null {
  if (typeof value !== 'string') return null;
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : null;
}

function revenueCatEventFromPayload(payload: Record<string, unknown>) {
  const nestedEvent = payload.event;
  if (nestedEvent && typeof nestedEvent === 'object') {
    return nestedEvent as Record<string, unknown>;
  }
  return payload;
}

function appUserIdsForEvent(event: Record<string, unknown>): string[] {
  const ids = new Set<string>();

  for (const key of ['app_user_id', 'original_app_user_id']) {
    const id = normalizedString(event[key]);
    if (id) ids.add(id);
  }

  const aliases = event.aliases;
  if (Array.isArray(aliases)) {
    for (const alias of aliases) {
      const id = normalizedString(alias);
      if (id) ids.add(id);
    }
  }

  return [...ids];
}

function planForEvent(event: Record<string, unknown>): 'premium' | 'free' | null {
  const eventType = normalizedString(event.type)?.toUpperCase();
  const productId = normalizedString(event.product_id);

  if (productId && !premiumProductIds.has(productId)) {
    return null;
  }

  if (eventType && premiumEventTypes.has(eventType)) return 'premium';
  if (eventType && freeEventTypes.has(eventType)) return 'free';

  return null;
}

serve(async (request) => {
  if (request.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  const expectedAuthorization = Deno.env.get('REVENUECAT_WEBHOOK_AUTHORIZATION');
  const authorization = request.headers.get('authorization');
  if (!expectedAuthorization || authorization !== expectedAuthorization) {
    return new Response('Unauthorized', { status: 401 });
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!supabaseUrl || !serviceRoleKey) {
    return new Response('Server is not configured', { status: 500 });
  }

  let payload: Record<string, unknown>;
  try {
    payload = await request.json();
  } catch (_) {
    return new Response('Invalid JSON', { status: 400 });
  }

  const event = revenueCatEventFromPayload(payload);
  const plan = planForEvent(event);
  const appUserIds = appUserIdsForEvent(event);

  if (!plan || appUserIds.length === 0) {
    return Response.json({ updated: 0, ignored: true });
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false },
  });

  const { data, error } = await supabase
    .from('users')
    .update({ plan })
    .in('hotel_id', appUserIds)
    .select('id, hotel_id, plan');

  if (error) {
    console.error('RevenueCat webhook plan update failed', error);
    return Response.json({ error: error.message }, { status: 500 });
  }

  return Response.json({
    updated: data?.length ?? 0,
    plan,
    app_user_ids: appUserIds,
  });
});
