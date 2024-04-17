create view lint."0014_extension_in_public" as

select 
    'extension_in_public' as name,
    'WARN' as level,
    'EXTERNAL' as facing,
    array['SECURITY'] as categories,
    'Detects extensions installed in the \`public\` schema.' as description,
    format(
        'Extension \`%s\` is installed in the public schema. Move it to another schema.',
        pe.extname
    ) as detail,
    'https://supabase.com/docs/guides/database/database-linter?lint=0014_extension_in_public' as remediation,
    jsonb_build_object(
        'schema', pe.extnamespace::regnamespace,
        'name', pe.extname,
        'type', 'extension'
    ) as metadata,
    format(
        'extension_in_public_%s',
        pe.extname
    ) as cache_key
from
    pg_catalog.pg_extension pe
where
    -- plpgsql is installed by default in public and outside user control
    -- confirmed safe
    pe.extname not in ('plpgsql')
    and pe.extnamespace::regnamespace::text = 'public';
