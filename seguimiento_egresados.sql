
CREATE DATABASE IF NOT EXISTS seguimiento_egresados;
USE seguimiento_egresados;

CREATE TABLE personas (
    id_persona INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    direccion TEXT,
    rol ENUM('docente','estudiante','maestro'),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE docentes (
    id_docente INT PRIMARY KEY AUTO_INCREMENT,
    id_persona INT,
    hash_password VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    intentos_fallidos INT DEFAULT 0,
    ultima_sesion TIMESTAMP NULL,
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    id_persona INT,
    especialidad ENUM('Especialidad1', 'Especialidad2', 'Especialidad3', 'Especialidad4'),
    año_egreso YEAR,
    estado_laboral ENUM('Desempleado', 'Trabajando', 'Estudiando', 'Otro'),
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE empresas (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150),
    contacto VARCHAR(100),
    telefono VARCHAR(15),
    direccion TEXT
);

CREATE TABLE maestros_guias (
    id_maestro INT PRIMARY KEY AUTO_INCREMENT,
    id_persona INT,
    id_empresa INT,
    cargo VARCHAR(100),
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

CREATE TABLE titulacion (
    id_titulacion INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    estado ENUM('No iniciada', 'En proceso', 'Titulado'),
    fecha_titulo DATE,
    observaciones TEXT,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
);

CREATE TABLE practicas (
    id_practica INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_docente INT,
    id_maestro INT,
    id_empresa INT,
    id_titulacion INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado ENUM('En curso', 'Finalizada', 'Cancelada'),
    observaciones TEXT,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente),
    FOREIGN KEY (id_maestro) REFERENCES maestros_guias(id_maestro),
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),
    FOREIGN KEY (id_titulacion) REFERENCES titulacion(id_titulacion)
);

CREATE TABLE seguimiento (
    id_seguimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_docente INT,
    fecha_contacto TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    medio_contacto ENUM('Teléfono', 'Email', 'Presencial', 'Encuesta'),
    resultado TEXT,
    proximo_contacto DATE,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
);

CREATE TABLE reportes (
    id_reporte INT PRIMARY KEY AUTO_INCREMENT,
    id_practica INT,
    tipo_reporte ENUM('Titulación', 'Prácticas', 'Empleabilidad'),
    fecha_generado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos JSON,
    FOREIGN KEY (id_practica) REFERENCES practicas(id_practica)
);
