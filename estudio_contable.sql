-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: estudio_contable
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `asignaciones`
--

DROP TABLE IF EXISTS `asignaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asignaciones` (
  `id_asignacion` int NOT NULL AUTO_INCREMENT,
  `id_contador` int NOT NULL,
  `id_cliente` int NOT NULL,
  PRIMARY KEY (`id_asignacion`),
  KEY `id_contador` (`id_contador`),
  KEY `id_cliente` (`id_cliente`),
  CONSTRAINT `asignaciones_ibfk_1` FOREIGN KEY (`id_contador`) REFERENCES `contador` (`id_contador`),
  CONSTRAINT `asignaciones_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignaciones`
--

LOCK TABLES `asignaciones` WRITE;
/*!40000 ALTER TABLE `asignaciones` DISABLE KEYS */;
INSERT INTO `asignaciones` VALUES (1,1,1),(2,1,2),(3,2,3);
/*!40000 ALTER TABLE `asignaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `cuit` varchar(15) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cuit` (`cuit`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Juan','Pérez','20-12345678-9'),(2,'María','González','27-98765432-1'),(3,'Carlos','López','23-45678901-2');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contador`
--

DROP TABLE IF EXISTS `contador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contador` (
  `id_contador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `matricula` varchar(50) NOT NULL,
  PRIMARY KEY (`id_contador`),
  UNIQUE KEY `matricula` (`matricula`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contador`
--

LOCK TABLES `contador` WRITE;
/*!40000 ALTER TABLE `contador` DISABLE KEYS */;
INSERT INTO `contador` VALUES (1,'Laura','Martínez','MAT123'),(2,'Andrés','Suárez','MAT456');
/*!40000 ALTER TABLE `contador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `impuesto`
--

DROP TABLE IF EXISTS `impuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impuesto` (
  `id_impuesto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_organismo` int NOT NULL,
  PRIMARY KEY (`id_impuesto`),
  KEY `id_organismo` (`id_organismo`),
  CONSTRAINT `impuesto_ibfk_1` FOREIGN KEY (`id_organismo`) REFERENCES `organismo_fiscal` (`id_organismo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `impuesto`
--

LOCK TABLES `impuesto` WRITE;
/*!40000 ALTER TABLE `impuesto` DISABLE KEYS */;
INSERT INTO `impuesto` VALUES (1,'IVA',1),(2,'Ganancias',1),(3,'Ingresos Brutos',2);
/*!40000 ALTER TABLE `impuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obligacion_impositiva`
--

DROP TABLE IF EXISTS `obligacion_impositiva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obligacion_impositiva` (
  `id_obligacion` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_impuesto` int NOT NULL,
  `periodo` varchar(45) NOT NULL,
  `fecha_presentacion` date NOT NULL,
  `estado` varchar(45) NOT NULL,
  PRIMARY KEY (`id_obligacion`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_impuesto` (`id_impuesto`),
  CONSTRAINT `obligacion_impositiva_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `obligacion_impositiva_ibfk_2` FOREIGN KEY (`id_impuesto`) REFERENCES `impuesto` (`id_impuesto`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obligacion_impositiva`
--

LOCK TABLES `obligacion_impositiva` WRITE;
/*!40000 ALTER TABLE `obligacion_impositiva` DISABLE KEYS */;
INSERT INTO `obligacion_impositiva` VALUES (1,1,1,'2025-06','2025-07-20','Presentado'),(2,2,2,'2025-06','2025-07-21','Pendiente'),(3,3,3,'2025-06','2025-07-22','Presentado');
/*!40000 ALTER TABLE `obligacion_impositiva` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organismo_fiscal`
--

DROP TABLE IF EXISTS `organismo_fiscal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organismo_fiscal` (
  `id_organismo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_organismo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organismo_fiscal`
--

LOCK TABLES `organismo_fiscal` WRITE;
/*!40000 ALTER TABLE `organismo_fiscal` DISABLE KEYS */;
INSERT INTO `organismo_fiscal` VALUES (1,'AFIP'),(2,'ARBA');
/*!40000 ALTER TABLE `organismo_fiscal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vista_obligaciones_clientes`
--

DROP TABLE IF EXISTS `vista_obligaciones_clientes`;
/*!50001 DROP VIEW IF EXISTS `vista_obligaciones_clientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_obligaciones_clientes` AS SELECT 
 1 AS `id_obligacion`,
 1 AS `id_impuesto`,
 1 AS `id_cliente`,
 1 AS `nombre_cliente`,
 1 AS `apellido_cliente`,
 1 AS `cuit`,
 1 AS `impuesto`,
 1 AS `organismo_fiscal`,
 1 AS `periodo`,
 1 AS `estado`,
 1 AS `fecha_presentacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_obligaciones_pendientes`
--

DROP TABLE IF EXISTS `vista_obligaciones_pendientes`;
/*!50001 DROP VIEW IF EXISTS `vista_obligaciones_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_obligaciones_pendientes` AS SELECT 
 1 AS `id_obligacion`,
 1 AS `id_impuesto`,
 1 AS `id_cliente`,
 1 AS `nombre_cliente`,
 1 AS `apellido_cliente`,
 1 AS `impuesto`,
 1 AS `periodo`,
 1 AS `estado`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_obligaciones_clientes`
--

/*!50001 DROP VIEW IF EXISTS `vista_obligaciones_clientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_obligaciones_clientes` AS select `oi`.`id_obligacion` AS `id_obligacion`,`oi`.`id_impuesto` AS `id_impuesto`,`oi`.`id_cliente` AS `id_cliente`,`c`.`nombre` AS `nombre_cliente`,`c`.`apellido` AS `apellido_cliente`,`c`.`cuit` AS `cuit`,`i`.`nombre` AS `impuesto`,`ofi`.`nombre` AS `organismo_fiscal`,`oi`.`periodo` AS `periodo`,`oi`.`estado` AS `estado`,`oi`.`fecha_presentacion` AS `fecha_presentacion` from (((`obligacion_impositiva` `oi` join `cliente` `c` on((`c`.`id_cliente` = `oi`.`id_cliente`))) join `impuesto` `i` on((`i`.`id_impuesto` = `oi`.`id_impuesto`))) left join `organismo_fiscal` `ofi` on((`ofi`.`id_organismo` = `i`.`id_organismo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_obligaciones_pendientes`
--

/*!50001 DROP VIEW IF EXISTS `vista_obligaciones_pendientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_obligaciones_pendientes` AS select `oi`.`id_obligacion` AS `id_obligacion`,`oi`.`id_impuesto` AS `id_impuesto`,`oi`.`id_cliente` AS `id_cliente`,`c`.`nombre` AS `nombre_cliente`,`c`.`apellido` AS `apellido_cliente`,`i`.`nombre` AS `impuesto`,`oi`.`periodo` AS `periodo`,`oi`.`estado` AS `estado` from ((`obligacion_impositiva` `oi` join `cliente` `c` on((`c`.`id_cliente` = `oi`.`id_cliente`))) join `impuesto` `i` on((`i`.`id_impuesto` = `oi`.`id_impuesto`))) where (`oi`.`estado` = 'Pendiente') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-18 18:48:44
