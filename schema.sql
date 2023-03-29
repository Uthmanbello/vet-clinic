/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
    id INT GENERATED ALWAYS AS IDENTITY, 
    name VARCHAR(250), 
    date_of_birth DATE, 
    escape_attempts INT, 
    neutered BOOLEAN, 
    weight_kg DECIMAL(2), 
    PRIMARY KEY(id)
);

/* Update of the animals table. */

 ALTER TABLE animals ADD species VARCHAR(250);
