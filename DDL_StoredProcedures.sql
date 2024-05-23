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
--Create procedure to add new customer 
-----------------------------------------------------------------
create or replace procedure app.usp_api_customer_create(
        out out_customer_id integer,
        inout error boolean default false,
        in customer_first_name varchar(100),
        in customer_middle_name varchar(100) default null,
	    in customer_last_name varchar(100),
        in cpf char(11) default null,
	    in rg  varchar(100) default null,
	    in date_of_birth date default null
)
as $$
declare 
    l_context text;
begin
    error := false;
    customer_first_name := trim(customer_first_name);
    customer_middle_name := trim(customer_middle_name);
    customer_last_name := trim(customer_last_name);
    cpf := trim(cpf);
    rg := trim(rg);
   
    begin
        if cpf is not null and length(cpf) < 11 then
            raise exception 'cpf dever ser de 11 caracteres.';
        end if;

        insert into app.customer
        (
            customer_first_name,
            customer_middle_name,
            customer_last_name,
            cpf,
            rg,
            date_of_birth
        ) 
        values 
        (
            customer_first_name,
            customer_middle_name,
            customer_last_name,
            cpf,
            rg,
            date_of_birth
        ) returning customer_id into out_customer_id;  

        exception
            when others then
                error := true;
                get stacked diagnostics l_context = pg_exception_context;
                insert into app.error_log (error_message, error_code, error_line)
                values (sqlerrm, sqlstate, l_context);
    end;  
end;
$$ language plpgsql;