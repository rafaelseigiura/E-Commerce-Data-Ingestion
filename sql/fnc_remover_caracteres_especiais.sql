CREATE OR REPLACE FUNCTION silver.remover_caracteres_especiais(texto text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN upper(
        regexp_replace(
            unaccent(texto),
            '[^a-zA-Z0-9 ]',
            '',
            'g'
        )
    );
END;
$function$
