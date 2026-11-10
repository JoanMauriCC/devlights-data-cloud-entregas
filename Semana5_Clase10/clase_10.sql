-- Semana 5 · Clase 10 · Tarea — Relaciones con foreign keys
-- Joan Mauri

-- =========================================
-- Base de datos
-- =========================================
--Crear una base de datos nueva llamada relaciones_db
CREATE DATABASE relaciones_db;


-- =========================================
-- 1:1 — Conductores y vehículos
-- =========================================
--Cada conductor tiene un solo vehículo asignado, y cada vehículo está asignado a un solo conductor.
--La FK conductor_id es UNIQUE: eso impide que un conductor tenga dos vehículos (si no fuera UNIQUE, sería 1:N).
CREATE TABLE conductores (
    id SERIAL PRIMARY KEY,                 -- Identificador único, se autoincrementa
    nombre VARCHAR(100) NOT NULL,          -- NOT NULL = obligatorio
    licencia VARCHAR(20) UNIQUE,           -- UNIQUE = no puede haber dos conductores con la misma licencia
    fecha_ingreso DATE
);

CREATE TABLE vehiculos (
    id SERIAL PRIMARY KEY,
    patente VARCHAR(10) UNIQUE,            -- No puede haber dos vehículos con la misma patente
    modelo VARCHAR(50),
    conductor_id INTEGER UNIQUE REFERENCES conductores(id)   -- FK única → asegura el 1:1
);


-- =========================================
-- 1:N — Profesores y clases
-- =========================================
--Un profesor puede dictar muchas clases, pero cada clase pertenece a un solo profesor.
--La FK va en la tabla del lado "muchos" (clases). Es NOT NULL: no puede existir una clase sin profesor.
CREATE TABLE profesores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50),
    fecha_contratacion DATE
);

CREATE TABLE clases (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    horario VARCHAR(50),
    profesor_id INTEGER NOT NULL REFERENCES profesores(id)   -- FK sin UNIQUE → un profe puede repetirse (1:N)
);


-- =========================================
-- N:N — Pacientes y enfermedades
-- =========================================
--Un paciente puede tener varias enfermedades, y una enfermedad puede afectar a muchos pacientes.
--Se resuelve con una tabla intermedia (pacientes_enfermedades) que tiene dos FK.
--Su PK compuesta (paciente_id, enfermedad_id) evita cargar dos veces el mismo diagnóstico.
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(20)
);

CREATE TABLE enfermedades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,                      -- TEXT = texto sin límite de largo
    nivel_gravedad VARCHAR(10) CHECK (nivel_gravedad IN ('leve', 'moderada', 'grave'))   -- CHECK = solo acepta esos 3 valores
);

CREATE TABLE pacientes_enfermedades (
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    enfermedad_id INTEGER NOT NULL REFERENCES enfermedades(id),
    fecha_diagnostico DATE,
    PRIMARY KEY (paciente_id, enfermedad_id)   -- PK compuesta: la combinación no se puede repetir
);


-- =========================================
-- Datos de prueba (2–3 filas por tabla)
-- =========================================
--Primero las tablas "padre" y después las que tienen FK (si no, la FK apunta a algo que no existe)
INSERT INTO conductores (nombre, licencia, fecha_ingreso) VALUES
('Carlos Gómez', 'LIC-1001', '2022-03-15'),
('María López', 'LIC-1002', '2023-01-10'),
('Jorge Benítez', 'LIC-1003', '2024-06-01');

INSERT INTO vehiculos (patente, modelo, conductor_id) VALUES
('AB123CD', 'Toyota Hilux', 1),
('AC456EF', 'Ford Ranger', 2),
('AD789GH', 'Renault Kangoo', 3);

INSERT INTO profesores (nombre, especialidad, fecha_contratacion) VALUES
('Laura Fernández', 'Bases de Datos', '2020-02-01'),
('Martín Acosta', 'Cloud', '2021-08-15');

INSERT INTO clases (nombre, horario, profesor_id) VALUES
('SQL básico', 'Lunes 18:00', 1),
('Modelado de datos', 'Miércoles 18:00', 1),   -- Laura dicta 2 clases → eso es el 1:N
('Introducción a AWS', 'Jueves 19:00', 2);

INSERT INTO pacientes (nombre, fecha_nacimiento, telefono) VALUES
('Ana Romero', '1990-05-12', '3794-111111'),
('Pedro Sosa', '1985-11-30', '3794-222222'),
('Lucía Vera', '2000-07-21', '3794-333333');

INSERT INTO enfermedades (nombre, descripcion, nivel_gravedad) VALUES
('Gripe', 'Infección viral respiratoria', 'leve'),
('Hipertensión', 'Presión arterial alta', 'moderada'),
('Neumonía', 'Infección pulmonar', 'grave');

INSERT INTO pacientes_enfermedades (paciente_id, enfermedad_id, fecha_diagnostico) VALUES
(1, 1, '2024-05-10'),   -- Ana tiene gripe
(1, 2, '2024-06-02'),   -- Ana también tiene hipertensión (un paciente → varias enfermedades)
(2, 1, '2024-05-15'),   -- Pedro también tiene gripe (una enfermedad → varios pacientes)
(3, 3, '2024-07-01');   -- Lucía tiene neumonía

-- =========================================
-- Prueba de constraint: INSERT que falla
-- =========================================
--Intentar asignar un segundo vehículo al conductor 1 (Carlos), que ya tiene la Toyota Hilux.
--Como conductor_id es UNIQUE, Postgres lo rechaza. Queda comentado para que el script se pueda ejecutar entero.

-- INSERT INTO vehiculos (patente, modelo, conductor_id) VALUES ('AE000ZZ', 'Fiat Cronos', 1);

-- Error que devuelve Postgres:
-- ERROR:  duplicate key value violates unique constraint "vehiculos_conductor_id_key"
-- DETAIL:  Key (conductor_id)=(1) already exists.