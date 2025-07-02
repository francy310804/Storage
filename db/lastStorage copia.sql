create database progettotsw;
use progettotsw;
CREATE TABLE `Prodotto` (
  `idProdotto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `categoria` char(10) NOT NULL,
  `descrizione` varchar(200) NOT NULL,
  `stato` tinyint(1) NOT NULL,
  `lingua` varchar(20) NOT NULL,
  `iva` int NOT NULL,
  `prezzo` decimal(6,2) NOT NULL,
  `stock` int DEFAULT NULL,
  `linkAccesso` varchar(200) DEFAULT NULL,
  `linkImg` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idProdotto`));
  
  CREATE TABLE `Utenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `nome` varchar(15) NOT NULL,
  `cognome` varchar(15) NOT NULL,
  `indirizzo` varchar(50) NOT NULL,
  `citta` varchar(10) NOT NULL,
  `provincia` char(2) NOT NULL,
  `cap` int NOT NULL,
  `password` varchar(100) NOT NULL,
  `ruolo` varchar(20) NOT NULL DEFAULT 'utente',
  PRIMARY KEY (`id`));
  
  -- contiene l'ordine generico
CREATE TABLE Orders (
id INT AUTO_INCREMENT PRIMARY KEY,
utente INT NOT NULL,
order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
total_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY(utente) REFERENCES Utenti(id)
);

-- contiene l'ordine nel dettaglio
CREATE TABLE Order_Details(
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  image_url VARCHAR(255) NOT NULL, -- campo ridondante ma giustificato
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  iva int(2) not null,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES prodotto(idProdotto)
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Prodotto(idProdotto),
    FOREIGN KEY (user_id) REFERENCES Utenti(id)
);

CREATE TABLE user_favorites (
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES Utenti(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Prodotto(idProdotto) ON DELETE CASCADE
);
 
CREATE TABLE Amministratore (
idAdmin int(2) primary key AUTO_INCREMENT,
email varchar(50) not null,
nome varchar(15) not null,
cognome varchar(15) not null,
password varchar(100) not null
);
 INSERT INTO Prodotto (nome, categoria, descrizione, stato, lingua, iva, prezzo, stock, linkAccesso, linkImg) VALUES
-- Corsi di lingua
('Corso Base Cinese', 'corso', 'Corso online per principianti di lingua cinese.', TRUE, 'cinese', 22, 129.99, NULL, 'https://www.youtube.com/watch?v=HO2BB-w_6jg', 'images/cinesebase.png'),
('Corso Base Giapponese', 'corso', 'Corso online per principianti di lingua giapponese.', TRUE, 'giapponese', 22, 129.99, NULL, 'https://www.youtube.com/watch?v=OV0zSQYHnY0', 'images/giapponesebase.jpg'),
('Corso Base Coreano', 'corso', 'Corso online per principianti di lingua coreana.', TRUE, 'coreano', 22, 129.99, NULL, 'https://www.youtube.com/watch?v=J6hzMJx8qL8', 'images/coreanobase.png'),

-- Manuali e materiali didattici
('Manuale Cinese HSK1', 'oggetto', 'Manuale cartaceo per la preparazione al test HSK1.', TRUE, 'cinese', 10, 24.50, 50, NULL, 'images/manualecinese.jpg'),
('Manuale Giapponese JLPT N5', 'oggetto', 'Libro per la preparazione al JLPT N5.', TRUE, 'giapponese', 10, 27.90, 40, NULL, 'images/manualegiapponese.jpg'),
('Manuale Coreano TOPIK I', 'oggetto', 'Libro per la preparazione al TOPIK I.', TRUE, 'coreano', 10, 26.00, 45, NULL, 'images/manualecoreano.jpg'),

-- Flashcard
('Flashcard Kanji', 'oggetto', 'Set di 100 flashcard per memorizzare i kanji base.', TRUE, 'giapponese', 10, 15.99, 60, NULL, 'images/chineseflashcards.jpg'),
('Flashcard Hangul', 'oggetto', 'Set di 100 flashcard per imparare il sistema Hangul.', TRUE, 'coreano', 10, 15.99, 55, NULL, 'images/koreanflashcards.jpg'),
('Flashcard Hanzi', 'oggetto', 'Set di 100 flashcard per memorizzare i caratteri Hanzi.', TRUE, 'cinese', 10, 15.99, 50, NULL, 'images/japaneseflashcards.jpg'),

-- Corsi intermedi
('Corso Intermedio Cinese', 'corso', 'Corso online per livello intermedio di lingua cinese.', TRUE, 'cinese', 22, 159.99, NULL, 'https://www.youtube.com/playlist?list=PLfjpNHFrqU1vmTULV-QtsH9OkZo9ErNnc', 'images/cineseintermedio.png'),
('Corso Intermedio Giapponese', 'corso', 'Corso online per livello intermedio di lingua giapponese.', TRUE, 'giapponese', 22, 159.99, NULL, 'https://www.youtube.com/playlist?list=PLjmSlqmrTdIQzmpMfEzxCJX2WALmREtGp', 'images/giapponeseintermedio.png'),
('Corso Intermedio Coreano', 'corso', 'Corso online per livello intermedio di lingua coreana.', TRUE, 'coreano', 22, 159.99, NULL, 'https://www.youtube.com/playlist?list=PL7AhQ8iqblcR7Jk5wu4csEcP_eXbp2H_s', 'images/coreanointermedio.png'),

-- Dizionari
('Dizionario Cinese-Italiano', 'oggetto', 'Dizionario tascabile cinese-italiano.', TRUE, 'cinese', 10, 19.90, 30, NULL, 'images/dizionariocinese.jpg'),
('Dizionario Giapponese-Italiano', 'oggetto', 'Dizionario tascabile giapponese-italiano.', TRUE, 'giapponese', 10, 19.90, 35, NULL, 'images/dizionariogiapponese.jpg'),
('Dizionario Coreano-Italiano', 'oggetto', 'Dizionario tascabile coreano-italiano.', TRUE, 'coreano', 10, 19.90, 30, NULL, 'images/dizionariocoreano.jpg');
