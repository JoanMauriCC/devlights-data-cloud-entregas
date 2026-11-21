-- Semana 6 · Clase 12 · Tarea — JOINs sobre el minimercado
-- Joan Mauri

-- ---------- INNER JOIN ----------

--Ejercicio 1
--Mostrar el nombre de cada proveedor y los nombres de sus productos (solo proveedores que tienen productos).
SELECT p.nombre AS "proveedores", pr.nombre AS "producto"
FROM proveedores p
INNER JOIN productos pr ON pr.proveedor_id = p.id
ORDER BY p.nombre , pr.nombre;

-- ---------- LEFT JOIN ----------

--Ejercicio 2
--Mostrar todos los proveedores y cuántos productos tiene cada uno (incluyendo los que tienen 0).
SELECT p.nombre AS "proveedores", COUNT(pr.id) AS "cantidad_producto"
FROM proveedores p
LEFT JOIN productos pr ON pr.proveedor_id = p.id
GROUP BY p.nombre
ORDER BY p.nombre

--Ejercicio 3
--Mostrar las ventas que no tienen ningún producto cargado en venta_productos.
SELECT v.id AS "venta", v.fecha AS "fecha", v.total AS "total"
FROM ventas v
LEFT JOIN venta_productos vp ON vp.venta_id = v.id
WHERE vp.venta_id IS NULL
ORDER BY v.id;

-- ---------- RIGHT JOIN ----------

--Ejercicio 4
--Escribiendo la consulta con RIGHT JOIN, mostrar todos los métodos de pago y cuántas ventas tiene cada uno.
SELECT mp.nombre AS "metodo_pago", COUNT(v.id) AS "cantidad_ventas"
FROM ventas v
RIGHT JOIN metodos_pago mp ON v.metodo_pago_id = mp.id
GROUP BY mp.nombre
ORDER BY mp.nombre

-- ---------- FULL OUTER JOIN ----------

--Ejercicio 5
--Hacer un FULL OUTER JOIN entre productos y venta_productos y mostrar los productos que nunca se vendieron.
SELECT p.id , p.nombre
FROM productos p
FULL OUTER JOIN venta_productos vp ON vp.producto_id = p.id
WHERE vp.venta_id IS NULL
ORDER BY p.id;

-- ---------- CROSS JOIN ----------

--Ejercicio 6
--Generar todas las combinaciones de productos y métodos de pago (producto, precio, método de pago). ¿Cuántas filas devuelve y por qué?
SELECT p.nombre AS "producto", p.precio AS "precio", mp.nombre AS "metodo_pago"
FROM productos p
CROSS JOIN metodos_pago mp 
ORDER BY p.nombre, p.precio , mp.nombre

--Respuesta: devuelve 336 filas.
--El CROSS JOIN combina cada fila de productos con TODAS las filas de metodos_pago (producto cartesiano).
--Hay 42 productos y 8 métodos de pago → 42 × 8 = 336 combinaciones.

-- ---------- JOIN múltiple ----------

--Ejercicio 7
--Mostrar cliente, fecha de venta y cantidad total de unidades de cada venta, combinando ventas, venta_productos y clientes.
SELECT c.nombre AS "cliente", v.fecha AS "fecha_ventas", SUM(vp.cantidad) AS "total_unidades"
FROM clientes c
INNER JOIN ventas v ON v.cliente_id = c.id
INNER JOIN venta_productos vp ON vp.venta_id = v.id
GROUP BY v.id, c.nombre, v.fecha
ORDER BY c.nombre, v.fecha;

--Ejercicio 8
--Mostrar el total facturado (cantidad * precio_unitario) por proveedor, de mayor a menor.
SELECT pr.nombre ,SUM(vp.cantidad * vp.precio_unitario) AS "total_facturado"
FROM proveedores pr
INNER JOIN productos p ON p.proveedor_id = pr.id
INNER JOIN venta_productos vp ON vp.producto_id = p.id
GROUP BY pr.id, pr.nombre
ORDER BY total_facturado DESC;


-- ---------- JOIN múltiple combinando INNER y LEFT ----------

--Ejercicio 9
--Mostrar todos los productos con el nombre de su proveedor y cuántas unidades se vendieron de cada uno. Los productos que nunca se vendieron también tienen que aparecer.
SELECT p.nombre AS "producto", pr.nombre AS "proveedor", COALESCE(SUM(vp.cantidad), 0) AS "unidades_vendidas"
FROM productos p
INNER JOIN proveedores pr ON pr.id = p.proveedor_id
LEFT JOIN venta_productos vp ON vp.producto_id = p.id
GROUP BY p.id, p.nombre, pr.nombre
ORDER BY unidades_vendidas DESC, p.nombre;

--Ejercicio 10
--Mostrar todas las ventas con el nombre del cliente, el método de pago y cuántos productos distintos tiene cada una. Las ventas sin productos cargados tienen que aparecer con 0.
SELECT v.id AS "venta", c.nombre AS "cliente", mp.nombre AS "metodo_pago", COUNT(DISTINCT vp.producto_id) AS "productos_distintos"
FROM ventas v
INNER JOIN clientes c ON c.id = v.cliente_id
INNER JOIN metodos_pago mp ON mp.id = v.metodo_pago_id
LEFT JOIN venta_productos vp ON vp.venta_id = v.id
GROUP BY v.id, c.nombre, mp.nombre
ORDER BY v.id;

--Ejercicio 11
--Mostrar todos los proveedores y en cuántas ventas distintas se vendió algún producto suyo (0 si nunca).
SELECT pr.nombre AS "proveedor", COUNT(DISTINCT vp.venta_id) AS "ventas_distintas"
FROM proveedores pr
LEFT JOIN productos p ON p.proveedor_id = pr.id
LEFT JOIN venta_productos vp ON vp.producto_id = p.id
GROUP BY pr.id, pr.nombre
ORDER BY ventas_distintas DESC, pr.nombre;

--Prueba: cambiar el segundo LEFT JOIN por INNER JOIN
SELECT pr.nombre AS "proveedor", COUNT(DISTINCT vp.venta_id) AS "ventas_distintas"
FROM proveedores pr
LEFT JOIN productos p ON p.proveedor_id = pr.id
INNER JOIN venta_productos vp ON vp.producto_id = p.id
GROUP BY pr.id, pr.nombre
ORDER BY ventas_distintas DESC, pr.nombre;

--Respuesta: con LEFT salen los 11 proveedores; con INNER salen 9.
--Desaparecen "Bebidas del Litoral" y "Panificadora San Juan", los dos proveedores sin productos.
