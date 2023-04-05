/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
    id INT GENERATED ALWAYS AS IDENTITY, 
    name VARCHAR(250), 
    date_of_birth DATE, 
    escape_attempts INT, 
    neutered BOOLEAN, 
    weight_kg NUMERIC(10, 2), 
    PRIMARY KEY(id)
);

/* Update of the animals table. */

 ALTER TABLE animals ADD species VARCHAR(250);

 /* Add new tables and update animals table. */

CREATE TABLE owners (id SERIAL PRIMARY KEY, full_name VARCHAR(250), age INTEGER); 
CREATE TABLE species (id SERIAL PRIMARY KEY, name VARCHAR(250));
ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species(id), ADD COLUMN owner_id INTEGER REFERENCES owners(id), DROP COLUMN species;

/* Add tables for many-to-many relationship */

CREATE TABLE vets (id SERIAL PRIMARY KEY, name VARCHAR(250), age INTEGER, date_of_graduation DATE);
CREATE TABLE specializations (id SERIAL PRIMARY KEY, vet_id INTEGER REFERENCES vets(id), species_id INTEGER REFERENCES species(id));
CREATE TABLE visits (id SERIAL PRIMARY KEY, animal_id INTEGER REFERENCES animals(id), vet_id INTEGER REFERENCES vets(id), visit_date DATE);

/* Performance audit. */
ALTER TABLE owners ADD COLUMN email VARCHAR(120);
CREATE INDEX visits_animal_id_idx ON visits (animal_id);
CREATE INDEX visits_vet_id_idx ON visits (vet_id);
CREATE INDEX idx_owners_email ON owners(email);
