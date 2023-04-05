CREATE TABLE "medical_histories"(
"id" SERIAL PRIMARY KEY,
"admitted_at" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
"patient_id" INTEGER NOT NULL REFERENCES "patients"("id"),
"status" VARCHAR(255) NOT NULL,
INDEX("patient_id"),
INDEX("id")
);

CREATE TABLE "invoices"(
"id" SERIAL PRIMARY KEY,
"total_amount" DECIMAL(8, 2) NOT NULL,
"generated_at" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
"paid_at" TIMESTAMP WITHOUT TIME ZONE,
"medical_history_id" INTEGER NOT NULL REFERENCES "medical_histories"("id"),
INDEX("medical_history_id")
);

CREATE TABLE "patients"(
"id" SERIAL PRIMARY KEY,
"name" VARCHAR(255) NOT NULL,
"date_of_birth" DATE NOT NULL
);

CREATE TABLE "treatments"(
"id" SERIAL PRIMARY KEY,
"type" VARCHAR(255) NOT NULL,
"name" VARCHAR(255) NOT NULL,
"medical_history_id" INTEGER NOT NULL REFERENCES "medical_histories"("id"),
INDEX("medical_history_id")
);

CREATE TABLE "invoice_items"(
"id" SERIAL PRIMARY KEY,
"unit_price" DECIMAL(8, 2) NOT NULL,
"quantity" INTEGER NOT NULL,
"total_price" DECIMAL(8, 2) NOT NULL,
"invoice_id" INTEGER NOT NULL REFERENCES "invoices"("id"),
"treatment_id" INTEGER NOT NULL REFERENCES "treatments"("id"),
INDEX("invoice_id"),
INDEX("treatment_id")
);

CREATE TABLE "medical_history_treatment"(
"id" SERIAL PRIMARY KEY,
"medical_history_id" INTEGER NOT NULL REFERENCES "medical_histories"("id"),
"treatment_id" INTEGER NOT NULL REFERENCES "treatments"("id"),
INDEX("medical_history_id"),
INDEX("treatment_id")
);
