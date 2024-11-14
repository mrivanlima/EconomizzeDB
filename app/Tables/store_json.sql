CREATE TABLE app.store_json (
    store_cnpj VARCHAR(100) ,              
    store_json JSONB NOT NULL,                
    created_by VARCHAR(100) NOT NULL,         
    modified_by VARCHAR(100),                 
    created_on TIMESTAMP DEFAULT NOW(),      
    modified_on TIMESTAMP DEFAULT NOW()                
);