-- MySQL dump 10.13  Distrib 5.5.30, for Linux (x86_64)
--
-- Host: localhost    Database: task
-- ------------------------------------------------------
-- Server version	5.5.30-log

--
-- Table structure for table `lists`
--

CREATE DATABASE IF NOT EXISTS `task`;
USE task;

DROP TABLE IF EXISTS `lists`;
CREATE TABLE `lists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `owner_id` int(11),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `lists_users`
--

DROP TABLE IF EXISTS `lists_users`;
CREATE TABLE `lists_users` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `list_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`list_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list_id` int(11) unsigned,
  `text` varchar(255) NOT NULL,
  `done` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `list_shared_with_user`;
CREATE TABLE `list_shared_with_user` (
  `shared_owner_id` int(11),
  `list_id` int(11) NOT NULL
);

INSERT INTO lists (name, owner_id) VALUES 
('NM List',1),
('NZ List',2),
('MA List',3),
('MH List',4);

INSERT INTO tasks (list_id, text, done) VALUES
(1,'Buy Supplies',0),
(1,'Fix Windows',1),
(2,'Do smth',0),
(3,'Do smth',0),
(4,'Do smth',0);

INSERT INTO users (username, password) VALUES 
('NM','123'),
('NZ','123'),
('MA','123'),
('MH','123');

-- Dump completed on 2013-03-03 16:46:02
