
-- VISTAS

CREATE VIEW vista_egresados_con_practica AS
SELECT 
    e.id_estudiante,
    p.nombre AS nombre_estudiante,
    e.especialidad,
    e.año_egreso,
    pr.fecha_inicio,
    pr.fecha_fin,
    pr.estado AS estado_practica,
    emp.nombre AS empresa
FROM estudiantes e
JOIN personas p ON e.id_persona = p.id_persona
JOIN practicas pr ON e.id_estudiante = pr.id_estudiante
JOIN empresas emp ON pr.id_empresa = emp.id_empresa
WHERE pr.estado = 'Finalizada';

CREATE VIEW vista_egresados_empleados AS
SELECT id_estudiante, especialidad, año_egreso
FROM estudiantes
WHERE estado_laboral = 'Trabajando';

CREATE VIEW vista_practicas_finalizadas AS
SELECT 
    p.id_practica,
    e.nombre AS empresa,
    est.especialidad,
    p.fecha_inicio,
    p.fecha_fin
FROM practicas p
JOIN empresas e ON p.id_empresa = e.id_empresa
JOIN estudiantes est ON p.id_estudiante = est.id_estudiante
WHERE p.estado = 'Finalizada';

-- FUNCIONES

DELIMITER //
CREATE FUNCTION fn_antiguedad_egreso(año_egreso INT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN YEAR(CURDATE()) - año_egreso;
END;
//

CREATE FUNCTION fn_tasa_titulacion_por_especialidad_generacion(
    especialidad_input VARCHAR(50),
    anio_input INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE total_egresados INT;
  DECLARE total_titulados INT;
  DECLARE tasa DECIMAL(5,2);

  SELECT COUNT(*) INTO total_egresados
  FROM estudiantes
  WHERE especialidad = especialidad_input AND año_egreso = anio_input;

  SELECT COUNT(*) INTO total_titulados
  FROM estudiantes e
  JOIN titulacion t ON e.id_estudiante = t.id_estudiante
  WHERE e.especialidad = especialidad_input AND e.año_egreso = anio_input AND t.estado = 'Titulado';

  IF total_egresados = 0 THEN
    SET tasa = 0;
  ELSE
    SET tasa = (total_titulados * 100.0) / total_egresados;
  END IF;

  RETURN tasa;
END;
//
DELIMITER ;

-- PROCEDIMIENTOS

DELIMITER //
CREATE PROCEDURE sp_insertar_estudiante(
  IN nombre VARCHAR(100),
  IN email VARCHAR(100),
  IN telefono VARCHAR(15),
  IN direccion TEXT,
  IN especialidad VARCHAR(50),
  IN año_egreso YEAR,
  IN estado_laboral VARCHAR(50)
)
BEGIN
  DECLARE id_p INT;

  INSERT INTO personas(nombre, email, telefono, direccion, rol)
  VALUES (nombre, email, telefono, direccion, 'estudiante');

  SET id_p = LAST_INSERT_ID();

  INSERT INTO estudiantes(id_persona, especialidad, año_egreso, estado_laboral)
  VALUES (id_p, especialidad, año_egreso, estado_laboral);
END;
//

CREATE PROCEDURE sp_registrar_practica(
  IN id_estudiante INT,
  IN id_docente INT,
  IN id_maestro INT,
  IN id_empresa INT,
  IN id_titulacion INT,
  IN fecha_inicio DATE,
  IN fecha_fin DATE
)
BEGIN
  INSERT INTO practicas(
    id_estudiante, id_docente, id_maestro, id_empresa,
    id_titulacion, fecha_inicio, fecha_fin, estado
  )
  VALUES (
    id_estudiante, id_docente, id_maestro, id_empresa,
    id_titulacion, fecha_inicio, fecha_fin, 'En curso'
  );
END;
//
DELIMITER ;

-- TRIGGERS

CREATE TABLE IF NOT EXISTS log_estudiantes (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  id_estudiante INT,
  fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_log_estudiante_nuevo
AFTER INSERT ON estudiantes
FOR EACH ROW
BEGIN
  INSERT INTO log_estudiantes(id_estudiante)
  VALUES (NEW.id_estudiante);
END;
//

CREATE TRIGGER trg_evitar_estado_titulacion_invalido
BEFORE INSERT ON titulacion
FOR EACH ROW
BEGIN
  IF NEW.estado NOT IN ('No iniciada', 'En proceso', 'Titulado') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Estado de titulación no válido.';
  END IF;
END;
//
DELIMITER ;
