
-- ================================
-- ENTREGA 2 - PROYECTO SQL CONTABLE
-- ================================

-- CREACIÓN DE TABLAS BASE

CREATE TABLE organismo_fiscal (
    id_organismo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE impuesto (
    id_impuesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_organismo INT,
    FOREIGN KEY (id_organismo) REFERENCES organismo_fiscal(id_organismo)
);

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE contador (
    id_contador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    matricula VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE asignaciones (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_contador INT,
    id_cliente INT,
    FOREIGN KEY (id_contador) REFERENCES contador(id_contador),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE obligacion_impositiva (
    id_obligacion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_impuesto INT,
    periodo VARCHAR(45) NOT NULL,
    fecha_presentacion DATE,
    estado VARCHAR(45) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_impuesto) REFERENCES impuesto(id_impuesto)
);

-- TABLA PARA AUDITORÍA DEL TRIGGER
CREATE TABLE auditoria_obligaciones (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_obligacion INT NOT NULL,
    id_impuesto INT NOT NULL,
    id_cliente INT NOT NULL,
    periodo VARCHAR(45) NOT NULL,
    estado_anterior VARCHAR(45) NOT NULL,
    estado_nuevo VARCHAR(45) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =======================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =======================================

INSERT INTO organismo_fiscal (nombre) VALUES ('AFIP'), ('ARBA');

INSERT INTO impuesto (nombre, id_organismo) VALUES 
('IVA', 1),
('Ganancias', 1),
('Ingresos Brutos', 2);

INSERT INTO cliente (nombre, cuit) VALUES
('Cliente A', '20-12345678-9'),
('Cliente B', '27-98765432-1');

INSERT INTO contador (nombre, matricula) VALUES
('Contador X', 'MAT-1001'),
('Contador Y', 'MAT-1002');

INSERT INTO asignaciones (id_contador, id_cliente) VALUES
(1, 1),
(2, 2);

INSERT INTO obligacion_impositiva (id_cliente, id_impuesto, periodo, fecha_presentacion, estado) VALUES
(1, 1, '2025-01', '2025-02-15', 'Pendiente'),
(1, 2, '2025-01', '2025-02-20', 'Presentado'),
(2, 3, '2025-01', '2025-02-18', 'Pendiente');

-- =======================================
-- CREACIÓN DE VISTAS
-- =======================================

CREATE VIEW vista_obligaciones_cliente AS
SELECT c.nombre AS cliente, i.nombre AS impuesto, o.periodo, o.estado
FROM obligacion_impositiva o
JOIN cliente c ON o.id_cliente = c.id_cliente
JOIN impuesto i ON o.id_impuesto = i.id_impuesto;

CREATE VIEW vista_obligaciones_pendientes AS
SELECT c.nombre AS cliente, i.nombre AS impuesto, o.periodo
FROM obligacion_impositiva o
JOIN cliente c ON o.id_cliente = c.id_cliente
JOIN impuesto i ON o.id_impuesto = i.id_impuesto
WHERE o.estado = 'Pendiente';

-- =======================================
-- CREACIÓN DE FUNCIÓN
-- =======================================

DELIMITER $$
CREATE FUNCTION Calcular_Pendientes_Cliente(p_id_cliente INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE cant INT DEFAULT 0;
    SELECT COUNT(*) INTO cant
    FROM obligacion_impositiva
    WHERE id_cliente = p_id_cliente AND estado = 'Pendiente';
    RETURN cant;
END $$
DELIMITER ;

-- =======================================
-- CREACIÓN DE PROCEDIMIENTO
-- =======================================

DELIMITER $$
CREATE PROCEDURE Registrar_Obligacion_Impositiva(
    IN p_id_cliente INT,
    IN p_id_impuesto INT,
    IN p_periodo VARCHAR(45),
    IN p_fecha_presentacion DATE,
    IN p_estado VARCHAR(45)
)
BEGIN
    INSERT INTO obligacion_impositiva (id_cliente, id_impuesto, periodo, fecha_presentacion, estado)
    VALUES (p_id_cliente, p_id_impuesto, p_periodo, p_fecha_presentacion, p_estado);
END $$
DELIMITER ;

-- =======================================
-- CREACIÓN DE TRIGGER
-- =======================================

DELIMITER $$
CREATE TRIGGER trg_Auditar_Cambio_Estado_Obligacion
AFTER UPDATE ON obligacion_impositiva
FOR EACH ROW
BEGIN
    IF OLD.estado <> NEW.estado THEN
        INSERT INTO auditoria_obligaciones (id_obligacion, id_impuesto, id_cliente, periodo, estado_anterior, estado_nuevo)
        VALUES (OLD.id_obligacion, OLD.id_impuesto, OLD.id_cliente, OLD.periodo, OLD.estado, NEW.estado);
    END IF;
END $$
DELIMITER ;
