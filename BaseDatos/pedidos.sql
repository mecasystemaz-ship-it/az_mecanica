-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-05-2025 a las 14:17:09
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cafeteria`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `cliente` varchar(100) DEFAULT NULL,
  `producto` varchar(50) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id`, `cliente`, `producto`, `cantidad`, `fecha`) VALUES
(1, 'hugod', 'Café', 2, '2025-05-01 11:31:50'),
(2, 'hugo hernan', 'Capuchino', 1, '2025-05-01 11:34:00'),
(3, 'hernan', 'Latte', 3, '2025-05-01 11:36:34'),
(4, 'pedro', 'Capuchino', 2, '2025-05-01 11:39:32'),
(5, 'pablo', 'Café', 15, '2025-05-01 11:42:30'),
(6, 'mistyk', 'Café', 5, '2025-05-01 11:45:29'),
(7, 'hugod', 'Capuchino', 2, '2025-05-01 11:53:13'),
(8, 'pablo', 'Capuchino', 8, '2025-05-01 11:54:34'),
(9, 'pablo', 'Café', 8, '2025-05-01 11:56:06'),
(10, 'pablo', 'Café', 8, '2025-05-01 12:03:56'),
(11, 'hugod', 'Café', 2, '2025-05-01 12:06:46'),
(12, 'pablo', 'Capuchino', 4, '2025-05-01 12:08:20'),
(13, 'hugod', 'Café', 2, '2025-05-01 12:10:38'),
(14, 'mistyk', 'Café', 14, '2025-05-01 12:12:25'),
(15, 'pedro', 'Capuchino', 6, '2025-05-01 12:13:15'),
(16, 'hernan', 'Café', 5, '2025-05-01 12:15:48');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
