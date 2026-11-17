-- Semana 6 · Clase 11 · Tarea — Diseñar una base de datos transaccional
-- Caso elegido: Veterinaria
-- Joan Mauri

-- =========================================
-- Base de datos
-- =========================================
--Crear una base de datos nueva llamada veterinaria_db
CREATE DATABASE veterinaria_db;

-- =========================================
-- 1:N — Dueños y mascotas
-- =========================================
--Un dueño puede tener varias mascotas; cada mascota tiene un solo dueño.
--La FK dueno_id va en mascotas (el lado "muchos") y NO es UNIQUE: el mismo dueño puede repetirse.
CREATE TABLE duenos(
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	dni VARCHAR(8) UNIQUE NOT NULL,
	telefono VARCHAR(20),
	mail VARCHAR(100) UNIQUE,
	direccion VARCHAR(100),
	fecha_alta DATE DEFAULT CURRENT_DATE
);

CREATE TABLE mascotas(
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	especie VARCHAR(50) NOT NULL,
	raza VARCHAR(50) NOT NULL,
	fecha_nacimiento DATE,
	dueno_id INTEGER NOT NULL REFERENCES duenos(id)
);

-- =========================================
-- 1:1 — Mascotas e historias clínicas
-- =========================================
--Cada mascota tiene una sola historia clínica, y cada historia es de una sola mascota.
--La FK mascota_id es UNIQUE: eso impide que una mascota tenga dos historias (sin UNIQUE sería 1:N).
CREATE TABLE historias_clinicas(
	id SERIAL PRIMARY KEY,
	grupo_sanguineo VARCHAR(10),
	alergias TEXT, --Texto largo sin limites
	castrado BOOLEAN,
	peso NUMERIC(5,2) CHECK (peso > 0),
	fecha_apertura DATE DEFAULT CURRENT_DATE,
	mascota_id INTEGER UNIQUE REFERENCES mascotas(id)
);

-- =========================================
-- 1:N — Mascotas y citas
-- =========================================
--Cada cita es de una sola mascota, y una mascota puede tener muchas citas.
--La FK mascota_id va en citas (el lado "muchos"), NO es UNIQUE (la mascota se repite) y es NOT NULL (no hay cita sin mascota).
CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    motivo VARCHAR(100),
    costo NUMERIC(10,2) CHECK (costo >= 0),
    estado VARCHAR(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'realizada', 'cancelada')),
    mascota_id INTEGER  NOT NULL REFERENCES mascotas(id)
);



-- =========================================
-- N:N — Citas y tratamientos
-- =========================================
--Una cita puede incluir varios tratamientos, y un tratamiento puede estar en varias citas.
--Se resuelve con la tabla intermedia cita_tratamiento, que tiene dos FK (cita_id y tratamiento_id).
--Su PK compuesta (cita_id, tratamiento_id) evita cargar dos veces el mismo tratamiento en la misma cita.
CREATE TABLE tratamientos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10,2) CHECK (precio > 0)
);

CREATE TABLE cita_tratamiento (
    cita_id INTEGER NOT NULL REFERENCES citas(id),
    tratamiento_id INTEGER NOT NULL REFERENCES tratamientos(id),
    cantidad INTEGER DEFAULT 1 CHECK (cantidad > 0),
    PRIMARY KEY (cita_id, tratamiento_id)
);

-- =========================================
-- Datos de prueba (al menos 3 filas por tabla)
-- =========================================
--Primero las tablas "padre" y después las que tienen FK (si no, la FK apunta a algo que no existe)

--fecha_alta no se carga: la completa sola el DEFAULT CURRENT_DATE
INSERT INTO duenos (nombre, apellido, dni, telefono, mail, direccion) VALUES
('Carlos', 'Gómez', '30111222', '3794-111111', 'carlos.gomez@mail.com', 'Junín 1300'),
('María', 'López', '28333444', '3794-222222', 'maria.lopez@mail.com', 'Av. 3 de Abril 950'),
('Jorge', 'Benítez', '35555666', '3794-333333', 'jorge.benitez@mail.com', 'La Rioja 650');

--Carlos (dueño 1) tiene 2 mascotas → eso muestra el 1:N
INSERT INTO mascotas (nombre, especie, raza, fecha_nacimiento, dueno_id) VALUES
('Firulais', 'perro', 'Mestizo', '2019-04-10', 1),
('Michi', 'gato', 'Siamés', '2020-08-22', 1),
('Rocky', 'perro', 'Labrador', '2018-01-15', 2),
('Luna', 'gato', 'Persa', '2021-11-03', 3);

--Una historia por mascota → eso muestra el 1:1
INSERT INTO historias_clinicas (grupo_sanguineo, alergias, castrado, peso, fecha_apertura, mascota_id) VALUES
('DEA 1.1+', 'Ninguna', TRUE, 12.50, '2019-06-01', 1),
('A', 'Pollo', TRUE, 4.20, '2020-10-15', 2),
('DEA 1.1-', 'Penicilina', FALSE, 30.80, '2018-03-20', 3),
('B', 'Ninguna', FALSE, 3.60, '2022-01-10', 4);

--Firulais (mascota 1) tiene 2 citas → otro 1:N
INSERT INTO citas (fecha, motivo, costo, estado, mascota_id) VALUES
('2024-03-10', 'Vacunación anual', 15000, 'realizada', 1),
('2024-06-02', 'Control general', 10000, 'realizada', 1),
('2024-07-15', 'Desparasitación', 8000, 'realizada', 3),
('2024-09-20', 'Castración', 45000, 'realizada', 2),
('2026-11-20', 'Control anual', 10000, 'pendiente', 4);

INSERT INTO tratamientos (nombre, descripcion, precio) VALUES
('Vacuna antirrábica', 'Vacuna obligatoria anual contra la rabia', 12000),
('Desparasitación', 'Antiparasitario interno y externo', 8000),
('Castración', 'Cirugía de esterilización', 40000),
('Control clínico', 'Revisión general: peso, temperatura, corazón', 10000);

--La cita 1 tiene 2 tratamientos y el "Control clínico" aparece en varias citas → eso es el N:N
INSERT INTO cita_tratamiento (cita_id, tratamiento_id, cantidad) VALUES
(1, 1, 1),   -- cita 1: vacuna antirrábica
(1, 4, 1),   -- cita 1: también control clínico
(2, 4, 1),   -- cita 2: control clínico
(3, 2, 2),   -- cita 3: desparasitación (2 dosis)
(4, 3, 1),   -- cita 4: castración
(5, 4, 1);   -- cita 5: control clínico