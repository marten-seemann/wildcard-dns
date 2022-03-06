CREATE DATABASE IF NOT EXISTS `coredns`;
USE `coredns`;

/* see https://coredns.io/explugins/mysql/#database-setup */
CREATE TABLE IF NOT EXISTS `coredns_records` (
  `id` INT NOT NULL AUTO_INCREMENT,
	`zone` VARCHAR(255) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`ttl` INT DEFAULT NULL,
	`content` TEXT,
	`record_type` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = INNODB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
