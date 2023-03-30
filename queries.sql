/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true and escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name= 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5; 
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Queries to make species 'unspecified'. */

BEGIN TRANSACTION;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/* Queries to fill species column */

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

/* Queries to test ROLLBACK. */

BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

/* Update queries to remove negative weights. */

BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_sp;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT my_sp;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * from animals;

/* Queries for finding aggregates. */

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, COUNT(*) as escape_count FROM animals WHERE escape_attempts > 0 GROUP BY neutered;
SELECT neutered, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY neutered;
SELECT neutered, AVG(escape_attempts) as avg_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY neutered;

/* Queries using JOIN. */

SELECT animals.* FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';
SELECT animals.* FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;
SELECT species.name, COUNT(animals.id) AS count FROM species LEFT JOIN animals ON species.id = animals.species_id GROUP BY species.id;
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE animals.name LIKE '%mon' AND owners.name = 'Jennifer Orwell';
SELECT animals.name as animal_name, owners.full_name as owner_name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
SELECT owners.full_name, COUNT(*) as num_animals FROM owners LEFT JOIN animals ON owners.id = animals.owner_id GROUP BY owners.id ORDER BY num_animals DESC LIMIT 1;

/* Queries using JOIN Tables for many-to-many relationship. */

SELECT animals.name FROM animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'William Tatcher' ORDER BY visits.visit_date DESC LIMIT 1;
SELECT COUNT (DISTINCT animal_id) FROM visits JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'Stephanie Mendez';
SELECT vets.name, species.name AS specialty FROM vets LEFT JOIN specializations ON vets.id = specializations.vet_id LEFT JOIN species ON specializations.species_id = species.id;
SELECT animals.name AS animal_name, vets.name AS vet_name, visits.visit_date FROM animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON visits.vet_id = vets.id INNER JOIN specializations ON animals.species_id = specializations.species_id AND specializations.vet_id = vets.id WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30' ORDER BY visits.visit_date;
SELECT animals.name, COUNT(*) as visits_count FROM animals JOIN visits ON animals.id = visits.animal_id JOIN vets ON visits.vet_id = vets.id GROUP BY animals.id ORDER BY visits_count DESC LIMIT 1;
SELECT animals.name, visits.visit_date FROM animals JOIN visits ON animals.id = visits.animal_id JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Maisy Smith' AND visits.visit_date = (SELECT MIN(visit_date) FROM visits WHERE vet_id = vets.id);
SELECT animals.name as animal_name, vets.name as vet_name, visits.visit_date FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id WHERE visits.visit_date = (SELECT MAX(visit_date) FROM visits);
SELECT COUNT(*) as visits_without_specialization FROM visits JOIN animals ON visits.animal_id = animals.id JOIN specializations ON animals.species_id = specializations.species_id JOIN vets ON visits.vet_id = vets.id JOIN specializations s ON vets.id = s.vet_id WHERE s.species_id != animals.species_id;
SELECT s.name, COUNT(*) AS num_visits FROM visits v JOIN animals a ON v.animal_id = a.id JOIN species s ON a.species_id = s.id JOIN vets vet ON vet.id = v.vet_id WHERE vet.name = 'Maisy Smith' GROUP BY s.name ORDER BY num_visits DESC LIMIT 1;
