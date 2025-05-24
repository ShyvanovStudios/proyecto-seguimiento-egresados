
-- INSERTS DE PRUEBA

INSERT INTO personas (nombre, email, telefono, direccion, rol)
VALUES 
('María Pérez', 'maria.perez@mail.com', '987654321', 'Av. Central 123', 'estudiante'),
('Juan Soto', 'juan.soto@mail.com', '912345678', 'Calle Norte 45', 'docente'),
('Carla Díaz', 'carla.diaz@mail.com', '923456789', 'Sur 456', 'maestro');

INSERT INTO estudiantes (id_persona, especialidad, año_egreso, estado_laboral)
VALUES (1, 'Especialidad1', 2022, 'Trabajando');

INSERT INTO docentes (id_persona, hash_password)
VALUES (2, 'hash123');

INSERT INTO empresas (nombre, contacto, telefono, direccion)
VALUES ('Geotec Ltda', 'Carlos Ruiz', '934567890', 'Parque Industrial 456');

INSERT INTO maestros_guias (id_persona, id_empresa, cargo)
VALUES (3, 1, 'Supervisor de Campo');

INSERT INTO titulacion (id_estudiante, estado, fecha_titulo, observaciones)
VALUES (1, 'Titulado', '2023-01-15', 'Cumplió todos los requisitos');

CALL sp_registrar_practica(1, 1, 1, 1, 1, '2022-08-01', '2022-12-01');
