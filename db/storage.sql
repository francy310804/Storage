DROP DATABASE IF EXISTS progettotsw;
CREATE DATABASE progettotsw;
USE progettotsw;

CREATE TABLE Prodotto (
idProdotto int(3) primary key AUTO_INCREMENT,
nome varchar(20) not null,
categoria char(10) not null, -- Se è un oggetto oppure un corso
descrizione varchar(200) not null,
stato boolean not null, -- True se è ancora in vendita, False se non è più in vedita
lingua varchar(20) not null, -- Lingua del prodotto
iva int(2) not NULL,
prezzo decimal(6,2) not null,
stock int(3),
linkAccesso varchar(200)
);

CREATE TABLE Utenti (
id int primary key AUTO_INCREMENT,
email varchar(50) not null,
nome varchar(15) not null,
cognome varchar(15) not null,
indirizzo varchar(50) not null,
citta varchar(10) not null,
provincia char(2) not null,
cap int(4) not null,
password varchar(100) not null
);

CREATE TABLE Amministratore (
idAdmin int primary key AUTO_INCREMENT,
email varchar(50) not null,
nome varchar(15) not null,
cognome varchar(15) not null,
password varchar(100) not null
);