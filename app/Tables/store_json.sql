CREATE TABLE app.store_json (
    store_id INT ,              
    store_json JSONB NOT NULL,                
    created_by VARCHAR(100) NOT NULL,         
    modified_by VARCHAR(100),                 
    created_on TIMESTAMP DEFAULT NOW(),      
    modified_on TIMESTAMP DEFAULT NOW(),
    constraint pk_store_json primary key (store_id), 
    constraint fk_store_json_store foreign key (store_id) references app.store(store_id)                  
);