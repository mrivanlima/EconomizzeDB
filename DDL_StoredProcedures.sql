-----------------------------------------------------------------
--Create procedure to drop all foreign keys
-----------------------------------------------------------------
create or replace procedure drop_foreign_keys()
as $$
declare
    fk_record record;
    drop_stmt text;
begin
    for fk_record in (
        select conrelid::regclass as table_from,
               conname as constraint_def
        from pg_constraint
        where contype = 'f'
    )
    loop
        drop_stmt := 'ALTER TABLE ' || fk_record.table_from || ' DROP CONSTRAINT ' || quote_ident(fk_record.constraint_def);
        raise notice 'Droping FK %', drop_stmt;
        execute drop_stmt;
    end loop;    
end;
$$ language plpgsql;


-----------------------------------------------------------------
--Create procedure to add new user 
-----------------------------------------------------------------
create or replace procedure app.usp_api_user_create(
        out out_user_id integer,
        in user_first_name varchar(100),
        in user_middle_name varchar(100) default null,
	    in user_last_name varchar(100) default null,
        in cpf char(11) default null,
	    in rg  varchar(100) default null,
	    in date_of_birth date default null,
        inout error boolean default false
)
as $$
declare 
    l_context text;
begin
    user_first_name := trim(user_first_name);
    user_middle_name := trim(user_middle_name);
    user_last_name := trim(user_last_name);
    cpf := trim(cpf);
    rg := trim(rg);
   
    begin
        if cpf is not null and length(cpf) < 11 then
            raise exception 'cpf dever ser de 11 caracteres.';
        end if;

        insert into app.user
        (
            user_first_name,
            user_middle_name,
            user_last_name,
            cpf,
            rg,
            date_of_birth
        ) 
        values 
        (
            user_first_name,
            user_middle_name,
            user_last_name,
            cpf,
            rg,
            date_of_birth
        ) returning user_id into out_user_id;  

        exception
            when others then
                error := true;
                get stacked diagnostics l_context = pg_exception_context;
                insert into app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                values 
                (
                    sqlerrm, 
                    sqlstate, 
                    l_context
                );
    end;  
end;
$$ language plpgsql;