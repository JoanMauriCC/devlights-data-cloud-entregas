-- Semana 5 · Clase 9 · Tarea — Crear tablas y consultar ventas
-- Joan Mauri

-- =========================================
-- Parte 0 — Base de datos
-- =========================================
--Crear una base de datos nueva llamada test_db
CREATE DATABASE test_db;

-- =========================================
-- Parte 1 — Tabla de departamentos
-- =========================================
--Crear la tabla apartments con las columnas: id, name, address, city, postal_code, bedrooms, area_m2, price, available, published_date
CREATE TABLE apartments (
    id SERIAL PRIMARY KEY,         -- Identificador único. SERIAL = entero que se autoincrementa solo (1, 2, 3...). PRIMARY KEY = no se repite ni puede ser nulo
    name VARCHAR(50),              -- Nombre o código del depto. VARCHAR(50) = texto de hasta 50 caracteres
    address VARCHAR(100),          -- Calle y número. Texto de hasta 100 caracteres
    city VARCHAR(50),              -- Ciudad donde se encuentra. Texto de hasta 50 caracteres
    postal_code VARCHAR(10),       -- Código postal. Es texto (no número) porque lleva letras, ej: 'C1000'
    bedrooms INT,                  -- Cantidad de habitaciones. INT = número entero, sin decimales
    area_m2 NUMERIC(6,2),          -- Superficie en m². NUMERIC(6,2) = 6 dígitos en total, 2 decimales (máx. 9999.99)
    price NUMERIC(10,2),           -- Precio. NUMERIC(10,2) = 10 dígitos, 2 decimales. Exacto, ideal para plata
    available BOOLEAN,             -- ¿Está disponible para venta/alquiler? BOOLEAN = TRUE (sí) o FALSE (no)
    published_date DATE            -- Fecha de publicación del anuncio. DATE = fecha en formato 'AAAA-MM-DD'
);

--Insertar al menos 30 filas con datos inventados
INSERT INTO apartments (name, address, city, postal_code, bedrooms, area_m2, price, available, published_date) VALUES
('Depto A', 'Av. Siempre Viva 123', 'Buenos Aires', 'C1000', 2, 55.5, 120000, TRUE, '2023-08-01'),
('Depto B', 'Av. Corrientes 1450', 'Buenos Aires', 'C1043', 1, 38.0, 85000, TRUE, '2023-07-15'),
('Depto C', 'Av. Santa Fe 2200', 'Buenos Aires', 'C1123', 3, 82.0, 210000, FALSE, '2023-06-20'),
('Depto D', 'Calle Florida 560', 'Buenos Aires', 'C1005', 2, 58.0, 135000, TRUE, '2023-09-05'),
('Depto E', 'Av. Cabildo 3100', 'Buenos Aires', 'C1429', 4, 110.0, 320000, TRUE, '2023-05-10'),
('Depto F', 'Bv. San Juan 850', 'Córdoba', 'X5000', 2, 60.0, 95000, TRUE, '2023-08-12'),
('Depto G', 'Av. Colón 1200', 'Córdoba', 'X5003', 1, 35.5, 62000, FALSE, '2023-07-01'),
('Depto H', 'Calle Obispo Trejo 400', 'Córdoba', 'X5000', 3, 75.0, 140000, TRUE, '2023-09-18'),
('Depto I', 'Av. Vélez Sarsfield 900', 'Córdoba', 'X5004', 2, 52.0, 88000, TRUE, '2023-06-25'),
('Depto J', 'Bv. Oroño 1500', 'Rosario', 'S2000', 2, 57.0, 98000, TRUE, '2023-08-22'),
('Depto K', 'Calle Córdoba 1100', 'Rosario', 'S2000', 1, 40.0, 70000, TRUE, '2023-07-30'),
('Depto L', 'Av. Pellegrini 2300', 'Rosario', 'S2002', 3, 90.0, 165000, FALSE, '2023-05-28'),
('Depto M', 'Calle San Martín 700', 'Rosario', 'S2000', 2, 65.0, 105000, TRUE, '2023-09-02'),
('Depto N', 'Av. 3 de Abril 950', 'Corrientes', 'W3400', 2, 54.0, 78000, TRUE, '2023-08-09'),
('Depto O', 'Calle Junín 1300', 'Corrientes', 'W3400', 1, 36.0, 52000, TRUE, '2023-07-11'),
('Depto P', 'Av. Costanera 200', 'Corrientes', 'W3402', 3, 85.0, 150000, FALSE, '2023-06-14'),
('Depto Q', 'Calle La Rioja 650', 'Corrientes', 'W3400', 2, 59.5, 82000, TRUE, '2023-09-20'),
('Depto R', 'Av. Sarmiento 400', 'Resistencia', 'H3500', 2, 50.0, 65000, TRUE, '2023-08-18'),
('Depto S', 'Calle Güemes 280', 'Resistencia', 'H3500', 1, 33.0, 45000, FALSE, '2023-07-05'),
('Depto T', 'Av. Alberdi 1100', 'Resistencia', 'H3502', 3, 72.0, 110000, TRUE, '2023-06-30'),
('Depto U', 'Calle San Martín 1250', 'Mendoza', 'M5500', 2, 61.0, 92000, TRUE, '2023-08-27'),
('Depto V', 'Av. Arístides Villanueva 500', 'Mendoza', 'M5500', 1, 42.0, 68000, TRUE, '2023-09-10'),
('Depto W', 'Calle Sarmiento 300', 'Mendoza', 'M5502', 4, 120.0, 250000, FALSE, '2023-05-22'),
('Depto X', 'Av. Emilio Civit 800', 'Mendoza', 'M5500', 2, 56.0, 87000, TRUE, '2023-07-19'),
('Depto Y', 'Av. Colón 2400', 'Mar del Plata', 'B7600', 2, 48.0, 90000, TRUE, '2023-08-05'),
('Depto Z', 'Calle Güemes 3000', 'Mar del Plata', 'B7600', 3, 78.0, 155000, TRUE, '2023-09-25'),
('Depto AA', 'Bv. Marítimo 1800', 'Mar del Plata', 'B7602', 1, 37.0, 72000, FALSE, '2023-06-08'),
('Depto AB', 'Calle 7 N° 950', 'La Plata', 'B1900', 2, 53.0, 84000, TRUE, '2023-08-14'),
('Depto AC', 'Av. 53 N° 600', 'La Plata', 'B1900', 3, 80.0, 130000, TRUE, '2023-07-24'),
('Depto AD', 'Calle 12 N° 1400', 'La Plata', 'B1902', 1, 39.0, 60000, TRUE, '2023-09-14');

-- ---------- Ejercicios Parte 1 ----------

--Ejercicio 1
--Mostrar los departamentos disponibles, ordenados del más barato al más caro.
SELECT * 
FROM apartments
WHERE available = TRUE 
ORDER BY price ASC;

--Ejercicio 2
--Calcular el precio promedio por ciudad.
SELECT city AS "ciudad", ROUND(AVG(price),2) AS "precio_promedio"
FROM apartments
GROUP BY city;

--Ejercicio 3
--Mostrar los departamentos con 2 o más habitaciones y con menos de 60 m².
SELECT * 
FROM apartments
WHERE  bedrooms >= 2  AND area_m2 < 60;


-- =========================================
-- Parte 2 — Ventas
-- =========================================
--Crear la tabla sales
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,      -- Identificador único, se autoincrementa solo
    product VARCHAR(50),        -- Nombre del producto
    category VARCHAR(30),       -- Categoría (Electronics, Stationery, Furniture, Accessories)
    price NUMERIC,              -- Precio unitario. NUMERIC sin (p,s) = acepta cualquier precisión
    quantity INT,               -- Cantidad de unidades vendidas
    sale_date DATE              -- Fecha de la venta
);

--Insertar los datos
INSERT INTO sales (product, category, price, quantity, sale_date) VALUES
('Mouse', 'Electronics', 15, 4, '2023-07-10'),
('Keyboard', 'Electronics', 30, 2, '2023-07-11'),
('Notebook', 'Stationery', 8, 10, '2023-07-12'),
('Pen', 'Stationery', 2, 25, '2023-07-13'),
('Headphones', 'Electronics', 40, 3, '2023-07-14'),
('Monitor', 'Electronics', 120, 1, '2023-07-15'),
('Desk Chair', 'Furniture', 85, 2, '2023-07-16'),
('Notebook Case', 'Accessories', 25, 3, '2023-07-17'),
('Printer Paper', 'Stationery', 6, 15, '2023-07-18'),
('USB Drive', 'Electronics', 12, 5, '2023-07-19'),
('Desk Lamp', 'Furniture', 35, 4, '2023-07-20'),
('Stapler', 'Stationery', 7, 6, '2023-07-21'),
('Calculator', 'Electronics', 20, 3, '2023-07-22'),
('Water Bottle', 'Accessories', 10, 8, '2023-07-23'),
('Laptop Stand', 'Accessories', 45, 2, '2023-07-24'),
('Office Desk', 'Furniture', 150, 1, '2023-07-25'),
('Whiteboard', 'Furniture', 60, 1, '2023-07-26'),
('Marker Set', 'Stationery', 5, 12, '2023-07-27'),
('Mouse Pad', 'Accessories', 8, 7, '2023-07-28'),
('Webcam', 'Electronics', 50, 2, '2023-07-29'),
('Smartphone', 'Electronics', 300, 1, '2023-07-30'),
('Notebook Pro', 'Electronics', 900, 1, '2023-07-31'),
('File Cabinet', 'Furniture', 120, 1, '2023-08-01'),
('Backpack', 'Accessories', 40, 3, '2023-08-02'),
('Binder', 'Stationery', 4, 20, '2023-08-03'),
('Headset Stand', 'Accessories', 15, 5, '2023-08-04'),
('Desk Organizer', 'Accessories', 12, 6, '2023-08-05'),
('Laptop Sleeve', 'Accessories', 30, 2, '2023-08-06'),
('Paper Clips', 'Stationery', 1, 50, '2023-08-07'),
('Surge Protector', 'Electronics', 25, 3, '2023-08-08'),
('Pen Holder', 'Accessories', 5, 10, '2023-08-09');

-- ---------- Ejercicios Parte 2 ----------

--Ejercicio 1
--Mostrar todas las ventas de la categoría 'Electronics'.
SELECT *
FROM sales
WHERE category = 'Electronics';

--Ejercicio 2
--Calcular el total de ingresos por categoría (price * quantity).
SELECT category AS "categoria", SUM(price * quantity) AS "total"
FROM sales
GROUP BY  category;

--Ejercicio 3
--Obtener la categoría con mayor ingreso total.
SELECT category AS "categoria", SUM(price * quantity) AS "ingreso_total"
FROM sales
GROUP BY category
ORDER BY ingreso_total DESC 
LIMIT 1;

--Ejercicio 4
--Mostrar todas las ventas donde el precio del producto sea mayor a 20.
SELECT * 
FROM sales 
WHERE price > 20;

--Ejercicio 5
--Calcular el total de unidades vendidas (SUM(quantity)) por cada producto.
SELECT product AS "producto", SUM(quantity) AS "unidades_vendidas"
FROM sales
GROUP BY product;

--Ejercicio 6
--Calcular el ingreso promedio por venta (AVG(price * quantity)) para cada producto.
SELECT product AS "producto", ROUND(AVG(quantity * price),2) AS "promedio_ventas"
FROM sales
GROUP BY product;

--Ejercicio 7
--Mostrar los 3 productos con mayor cantidad total vendida (SUM(quantity)) usando ORDER BY y LIMIT.
SELECT product AS "producto", SUM(quantity) AS "total_vendidas"
FROM sales
GROUP BY product
ORDER BY total_vendidas DESC
LIMIT 3;

--Ejercicio 8
--Mostrar todas las ventas realizadas después del 12 de julio de 2023.
SELECT *
FROM sales
WHERE sale_date > '2023-07-12';


--Ejercicio 9
--Mostrar la categoría y el ingreso total, pero solo para categorías cuyo ingreso sea mayor a 50 (HAVING SUM(price * quantity) > 50).
SELECT category AS "Categoria", SUM(price * quantity) AS "Ingreso total"
FROM sales
GROUP BY category
HAVING(SUM(price * quantity)) > 50;

--Ejercicio 10
--Mostrar todas las ventas donde el nombre del producto comience con la letra H (LIKE 'H%').
SELECT * 
FROM sales 
WHERE product LIKE 'H%';

--Ejercicio 11
--Calcular la cantidad promedio de productos vendidos (AVG(quantity)) agrupados por categoría.
SELECT category AS "Category", ROUND(AVG(quantity),2) AS "Promedio"
FROM sales
GROUP BY category;

--Ejercicio 12
--Mostrar todas las ventas y calcular el ingreso por fila (price * quantity), ordenadas de mayor a menor ingreso.
SELECT *, (price * quantity) AS ingreso
FROM  sales
ORDER BY  ingreso DESC;

--Ejercicio 13
--Mostrar todas las ventas de la categoría 'Electronics' donde la cantidad sea mayor a 2 y el precio menor a 40.
SELECT * 
FROM sales
WHERE category = 'Electronics' AND quantity > 2 AND price < 40;