CREATE TABLE app.store_json (
    store_json_id SERIAL,
    store_cnpj VARCHAR(20) ,
    sanitized_cnpj VARCHAR(20),
    store_json JSONB NOT NULL,                
    created_by INT,         
    modified_by INT,                 
    created_on TIMESTAMP DEFAULT NOW(),      
    modified_on TIMESTAMP DEFAULT NOW()                
);