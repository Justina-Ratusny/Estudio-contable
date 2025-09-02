
-- ================================
-- ENTREGA 3 - PROYECTO SQL CONTABLE
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

-- ================================
-- CREACIÓN DE NUEVAS TABLAS
-- ================================

-- TABLA Honorarios
CREATE TABLE honorarios (
    id_honorario INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    periodo VARCHAR(45) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estado VARCHAR(45) NOT NULL,
    pago DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- TABLA Proveedores
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuit VARCHAR(20),
    servicio_ofrecido VARCHAR(100),
    mail VARCHAR(100),
    telefono VARCHAR(20)
);

-- TABLA Gastos_Estudio
CREATE TABLE gastos_estudio (
    id_gasto INT AUTO_INCREMENT PRIMARY KEY,
    tipo_gasto VARCHAR(50),
    descripcion VARCHAR(200),
    monto DECIMAL(10,2),
    fecha DATE,
    medio_pago VARCHAR(50),
    id_proveedor INT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

-- TABLA Vencimientos_Adicionales
CREATE TABLE vencimientos_adicionales (
    id_vencimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    descripcion VARCHAR(200),
    fecha_vencimiento DATE,
    estado VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- ================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- ================================

-- Proveedores
INSERT INTO proveedores (nombre, cuit, servicio_ofrecido, mail, telefono) VALUES
('Edesur', '30-11223344-9', 'Electricidad', 'contacto@edesur.com', '1140001111'),
('Fibertel', '30-55667788-1', 'Internet', 'soporte@fibertel.com', '1140002222'),
('Librería San Martín', '20-99887766-3', 'Papelería', 'ventas@libreriasm.com', '1140003333');

-- Honorarios
INSERT INTO honorarios (id_cliente, periodo, monto, estado, pago) VALUES
(1, '2025-01', 150000.00, 'Pendiente', NULL),
(2, '2025-01', 200000.00, 'Pagado', '2025-02-10'),
(1, '2025-02', 150000.00, 'Pagado', '2025-03-05');

-- Gastos del Estudio (incluye alquiler)
INSERT INTO gastos_estudio (tipo_gasto, descripcion, monto, fecha, medio_pago, id_proveedor) VALUES
('Luz', 'Factura enero 2025', 25000.00, '2025-02-05', 'Débito automático', 1),
('Internet', 'Plan fibra 300mb', 18000.00, '2025-02-07', 'Transferencia', 2),
('Papelería', 'Resmas de hojas y biromes', 8000.00, '2025-02-10', 'Efectivo', 3),
('Alquiler', 'Alquiler oficina febrero 2025', 120000.00, '2025-02-01', 'Transferencia', NULL);

-- Vencimientos adicionales
INSERT INTO vencimientos_adicionales (id_cliente, descripcion, fecha_vencimiento, estado) VALUES
(1, 'Renovación contrato de alquiler', '2025-06-30', 'Pendiente'),
(2, 'Presentación balances societarios', '2025-04-15', 'Pendiente'),
(1, 'Pago seguro ART', '2025-03-10', 'Cumplido');

