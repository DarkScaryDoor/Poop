-- MySQL Script generated by MySQL Workbench
-- Thu Sep 16 16:20:26 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema baza
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema baza
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `baza` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `baza` ;

-- -----------------------------------------------------
-- Table `baza`.`tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`tags` ;

CREATE TABLE IF NOT EXISTS `baza`.`tags` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`Mesto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`Mesto` ;

CREATE TABLE IF NOT EXISTS `baza`.`Mesto` (
  `idMesto` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Ime` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idMesto`),
  UNIQUE INDEX `idMesto_UNIQUE` (`idMesto` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`Korisnik`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`Korisnik` ;

CREATE TABLE IF NOT EXISTS `baza`.`Korisnik` (
  `idKorisnik` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Ime` VARCHAR(50) NOT NULL,
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Poslodavac` TINYINT NOT NULL,
  `Admin` TINYINT NOT NULL,
  `idmesta` INT UNSIGNED NOT NULL,
  `Opis` VARCHAR(512) NULL,
  PRIMARY KEY (`idKorisnik`),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  INDEX `mes_idx` (`idmesta` ASC) VISIBLE,
  CONSTRAINT `mest`
    FOREIGN KEY (`idmesta`)
    REFERENCES `baza`.`Mesto` (`idMesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`Oglas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`Oglas` ;

CREATE TABLE IF NOT EXISTS `baza`.`Oglas` (
  `idOglas` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idCoveka` INT UNSIGNED NOT NULL,
  `Naslov` VARCHAR(50) NOT NULL,
  `Tip` TINYINT UNSIGNED NOT NULL,
  `Plata` INT UNSIGNED NULL,
  `Opis` VARCHAR(512) NULL,
  `Mesto` INT UNSIGNED NULL,
  PRIMARY KEY (`idOglas`),
  INDEX `Gazda_idx` (`idCoveka` ASC) VISIBLE,
  INDEX `mes_idx` (`Mesto` ASC) VISIBLE,
  CONSTRAINT `Gazda`
    FOREIGN KEY (`idCoveka`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `mess`
    FOREIGN KEY (`Mesto`)
    REFERENCES `baza`.`Mesto` (`idMesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`lajkovi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`lajkovi` ;

CREATE TABLE IF NOT EXISTS `baza`.`lajkovi` (
  `idCoveka` INT UNSIGNED NOT NULL,
  `idOglasa` INT UNSIGNED NOT NULL,
  `lajk` TINYINT NOT NULL,
  PRIMARY KEY (`idCoveka`, `idOglasa`),
  INDEX `Oglas_idx` (`idOglasa` ASC) VISIBLE,
  CONSTRAINT `Covek`
    FOREIGN KEY (`idCoveka`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Oglas`
    FOREIGN KEY (`idOglasa`)
    REFERENCES `baza`.`Oglas` (`idOglas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`poruke`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`poruke` ;

CREATE TABLE IF NOT EXISTS `baza`.`poruke` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idCoveka` INT UNSIGNED NOT NULL,
  `idOglasa` INT UNSIGNED NOT NULL,
  `odgovor` INT NULL,
  `tekst` VARCHAR(512) NULL,
  PRIMARY KEY (`id`),
  INDEX `covekid_idx` (`idCoveka` ASC) VISIBLE,
  INDEX `oglasa_idx` (`idOglasa` ASC) VISIBLE,
  CONSTRAINT `covekid`
    FOREIGN KEY (`idCoveka`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `oglasa`
    FOREIGN KEY (`idOglasa`)
    REFERENCES `baza`.`Oglas` (`idOglas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`podtags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`podtags` ;

CREATE TABLE IF NOT EXISTS `baza`.`podtags` (
  `id` INT UNSIGNED NOT NULL,
  `idkategorije` INT UNSIGNED NOT NULL,
  `podkategorija` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `kategorija_idx` (`idkategorije` ASC) VISIBLE,
  CONSTRAINT `kategorija`
    FOREIGN KEY (`idkategorije`)
    REFERENCES `baza`.`tags` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`tagovi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`tagovi` ;

CREATE TABLE IF NOT EXISTS `baza`.`tagovi` (
  `idoglasa` INT UNSIGNED NOT NULL,
  `idtaga` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idoglasa`, `idtaga`),
  INDEX `tag_idx` (`idtaga` ASC) VISIBLE,
  CONSTRAINT `firma`
    FOREIGN KEY (`idoglasa`)
    REFERENCES `baza`.`Oglas` (`idOglas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tag`
    FOREIGN KEY (`idtaga`)
    REFERENCES `baza`.`podtags` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`Telefoni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`Telefoni` ;

CREATE TABLE IF NOT EXISTS `baza`.`Telefoni` (
  `idKorisnika` INT UNSIGNED NOT NULL,
  `Broj` VARCHAR(15) NOT NULL,
  INDEX `Covek_idx` (`idKorisnika` ASC) VISIBLE,
  PRIMARY KEY (`idKorisnika`, `Broj`),
  CONSTRAINT `kevoc`
    FOREIGN KEY (`idKorisnika`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`Ocena`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`Ocena` ;

CREATE TABLE IF NOT EXISTS `baza`.`Ocena` (
  `IdCoveka` INT UNSIGNED NOT NULL,
  `IdOcenjenog` INT UNSIGNED NOT NULL,
  `Ocena` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`IdCoveka`, `IdOcenjenog`),
  INDEX `IdOcenjog_idx` (`IdOcenjenog` ASC) VISIBLE,
  CONSTRAINT `IdCoveka`
    FOREIGN KEY (`IdCoveka`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IdOcenjog`
    FOREIGN KEY (`IdOcenjenog`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `baza`.`Prijave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`Prijave` ;

CREATE TABLE IF NOT EXISTS `baza`.`Prijave` (
  `idCovek` INT UNSIGNED NOT NULL,
  `idOglas` INT UNSIGNED NOT NULL,
  `CV` VARCHAR(512) NULL,
  PRIMARY KEY (`idCovek`, `idOglas`),
  INDEX `po_idx` (`idOglas` ASC) VISIBLE,
  CONSTRAINT `co`
    FOREIGN KEY (`idCovek`)
    REFERENCES `baza`.`Korisnik` (`idKorisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `po`
    FOREIGN KEY (`idOglas`)
    REFERENCES `baza`.`Oglas` (`idOglas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `baza` ;

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`SveOKorisniku`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`SveOKorisniku` (`idkorisnik` INT, `ime` INT, `email` INT, `username` INT, `password` INT, `opis` INT, `mesto` INT, `petice` INT, `cetvorke` INT, `trojke` INT, `dvojke` INT, `jedinice` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`petice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`petice` (`broj` INT, `idCoveka` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`cetvorke`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`cetvorke` (`broj` INT, `idCoveka` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`trojke`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`trojke` (`broj` INT, `idCoveka` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`dvojke`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`dvojke` (`broj` INT, `idCoveka` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`jedinice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`jedinice` (`broj` INT, `idCoveka` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`likes` (`broj` INT, `idoglasa` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`dislikes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`dislikes` (`broj` INT, `idoglasa` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`SveOOglasu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`SveOOglasu` (`idoglas` INT, `ime` INT, `naslov` INT, `tip` INT, `plata` INT, `opis` INT, `mesto` INT, `likes` INT, `dislikes` INT);

-- -----------------------------------------------------
-- Placeholder table for view `baza`.`slozeniTagovi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `baza`.`slozeniTagovi` (`idoglasa` INT, `concat(ta.tag,"-",pt.podkategorija)` INT);

-- -----------------------------------------------------
-- View `baza`.`SveOKorisniku`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`SveOKorisniku`;
DROP VIEW IF EXISTS `baza`.`SveOKorisniku` ;
USE `baza`;
CREATE  OR REPLACE VIEW `SveOKorisniku` AS
select k.idkorisnik,k.ime ,k.email,k.username,k.password,k.opis,m.ime as mesto,p.broj as petice,c.broj as cetvorke,t.broj as trojke,d.broj as dvojke,j.broj as jedinice
from korisnik k join mesto m on k.idmesta = m.idmesto
left join petice p on k.idkorisnik = p.idcoveka
left join cetvorke c on k.idkorisnik = c.idcoveka
left join trojke t on k.idkorisnik = t.idcoveka
left join dvojke d on k.idkorisnik = d.idcoveka
left join jedinice j on k.idkorisnik = j.idcoveka;

-- -----------------------------------------------------
-- View `baza`.`petice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`petice`;
DROP VIEW IF EXISTS `baza`.`petice` ;
USE `baza`;
CREATE  OR REPLACE VIEW `petice` AS
select count(ocena) as broj, idCoveka
from Ocena
where ocena=5
group by idCoveka;

-- -----------------------------------------------------
-- View `baza`.`cetvorke`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`cetvorke`;
DROP VIEW IF EXISTS `baza`.`cetvorke` ;
USE `baza`;
CREATE  OR REPLACE VIEW `cetvorke` AS
select count(ocena) as broj , idCoveka
from Ocena
where ocena=4
group by idCoveka;

-- -----------------------------------------------------
-- View `baza`.`trojke`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`trojke`;
DROP VIEW IF EXISTS `baza`.`trojke` ;
USE `baza`;
CREATE  OR REPLACE VIEW `trojke` AS
select count(ocena) as broj , idCoveka
from Ocena
where ocena=3
group by idCoveka;

-- -----------------------------------------------------
-- View `baza`.`dvojke`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`dvojke`;
DROP VIEW IF EXISTS `baza`.`dvojke` ;
USE `baza`;
CREATE  OR REPLACE VIEW `dvojke` AS
select count(ocena) as broj , idCoveka
from Ocena
where ocena=2
group by idCoveka;

-- -----------------------------------------------------
-- View `baza`.`jedinice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`jedinice`;
DROP VIEW IF EXISTS `baza`.`jedinice` ;
USE `baza`;
CREATE  OR REPLACE VIEW `jedinice` AS
select count(ocena) as broj, idCoveka
from Ocena
where ocena=1
group by idCoveka;

-- -----------------------------------------------------
-- View `baza`.`likes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`likes`;
DROP VIEW IF EXISTS `baza`.`likes` ;
USE `baza`;
CREATE  OR REPLACE VIEW `likes` AS
select count(lajk) as broj, idoglasa
from lajkovi
where lajk=true
group by idoglasa;

-- -----------------------------------------------------
-- View `baza`.`dislikes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`dislikes`;
DROP VIEW IF EXISTS `baza`.`dislikes` ;
USE `baza`;
CREATE  OR REPLACE VIEW `dislikes` AS
select count(lajk) as broj, idoglasa
from lajkovi
where lajk=false
group by idoglasa;

-- -----------------------------------------------------
-- View `baza`.`SveOOglasu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`SveOOglasu`;
DROP VIEW IF EXISTS `baza`.`SveOOglasu` ;
USE `baza`;
CREATE  OR REPLACE VIEW `SveOOglasu` AS
select o.idoglas,k.ime,o.naslov,o.tip,o.plata,o.opis,m.ime as mesto,l.broj as likes,d.broj as dislikes
from oglas o join korisnik k on o.idcoveka = k.idkorisnik
join mesto m on o.mesto = m.idmesto
left join likes l on o.idoglas = l.idoglasa
left join dislikes d on o.idoglas = d.idoglasa;

-- -----------------------------------------------------
-- View `baza`.`slozeniTagovi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baza`.`slozeniTagovi`;
DROP VIEW IF EXISTS `baza`.`slozeniTagovi` ;
USE `baza`;
CREATE  OR REPLACE VIEW `slozeniTagovi` AS
select t.idoglasa,concat(ta.tag,"-",pt.podkategorija)
from tagovi t join podtags pt on t.idtaga = pt.id
join tags ta on pt.idkategorije = ta.id;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



INSERT INTO MESTO(ime) values('Beograd');
INSERT INTO MESTO(ime) values('Novi Sad');
INSERT INTO MESTO(ime) values('Nis');
INSERT INTO MESTO(ime) values('Kragujevac');
INSERT INTO MESTO(ime) values('Pristina');
INSERT INTO MESTO(ime) values('Subotica');
INSERT INTO MESTO(ime) values('Zrenjanin');
INSERT INTO MESTO(ime) values('Pancevo');
INSERT INTO MESTO(ime) values('Cacak');
INSERT INTO MESTO(ime) values('Krusevac');
INSERT INTO MESTO(ime) values('Kraljevo');
INSERT INTO MESTO(ime) values('Novi Paza');
INSERT INTO MESTO(ime) values('Smederevo');
INSERT INTO MESTO(ime) values('Leskovac');
INSERT INTO MESTO(ime) values('Uzice');
INSERT INTO MESTO(ime) values('Vranje');
INSERT INTO MESTO(ime) values('Valjevo');
INSERT INTO MESTO(ime) values('Sabac');
INSERT INTO MESTO(ime) values('Sombor');
INSERT INTO MESTO(ime) values('Pozarevac');
INSERT INTO MESTO(ime) values('Pirot');
INSERT INTO MESTO(ime) values('Zajecar');
INSERT INTO MESTO(ime) values('Kikinda');
INSERT INTO MESTO(ime) values('Sremska Mitrovica');
INSERT INTO MESTO(ime) values('Jagodina');
INSERT INTO MESTO(ime) values('Vrsac');
INSERT INTO MESTO(ime) values('Bor');
INSERT INTO MESTO(ime) values('Loznica');

INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ("admin","admin","admin","admin@admin.admin",1,true,false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Milica Medakovic', 'MilicaM', 'milica01', 'milica.medakovic@gmail.com', 1, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Mladen Krstic', 'MladenK', 'mladen02', 'mladen.krstic@gmail.com', 2, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Marko Pavlovic', 'MarkoP', 'marko03', 'marko.pavlovic@gmail.com', 3, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Ognjen Negic' , 'OgnjenN', 'ognjen04', 'ognjen.negic@gmail.com', 3, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Filip Ilic', 'FilipI', 'filip05', 'filip.ilic@gmail.com', 4, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Danica Lazarevic', 'DanicaL', 'danica06', 'danica.lazarevic@gmail.com', 4, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Jelena Gajic', 'JelenaG', 'jelena07', 'jelena.gajic@gmail.com', 5, true, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Katarina Ivanov', 'KatarinaI', 'katarina08', 'katarina.ivanov@gmail.com', 1, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Luka Jolic', 'LukaJ', 'luka09', 'luka.jolic@gmail.com', 1, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Dusan Tomic', 'DusanT', 'dusan10', 'dusan.tomic@gmail.com', 2, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Stefan Nenadovic', 'StefanN', 'stefan11', 'stefan.nenadovic@gmail.com', 2, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Janko Petrovic', 'JankoP', 'janko12', 'janko.petrovic@gmail.com', 3, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Ivan Markovic', 'IvanM', 'ivan13', 'ivan.markovic@gmail.com', 4, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Lazar Petkovic', 'LazarP', 'lazar14', 'lazar.petkovic@gmail.com', 12, false, false);
INSERT INTO KORISNIK(Ime,Username,Password,Email,idmesta,Poslodavac,Admin) values ('Danilo Jankovic', 'DaniloJ', 'danilo15', 'daniko.jankovic@gmail.com', 8, false, false);

insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (1, 'Java Developer', false, 2000, 'We are looking for senior developers. We are a team with 20 years of experience in the industry with multiple branches. Our plan is to emply more then 50 developers in one year time.', 1);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (1, 'Python Developer', false, 2200, 'We are looking for senior developers. We are a team with 20 years of experience in the industry with multiple branches. Our plan is to emply more then 50 developers in one year time.', 1);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (1, 'PHP Developer', false, 1800, 'We are looking for senior developers. We are a team with 20 years of experience in the industry with multiple branches. Our plan is to emply more then 50 developers in one year time.',1);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (2, 'Nastavnik engleskog jezika' ,false, 450, 'Trenutno pripremamo našu školu za novu akademsku godinu kako bi postala najbolja opcija za učenje stranih jezika za decu. Prijavite se odmah, tako da ste spremni da započnete predavanje od pocetka Septembra!', 2);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (2, 'Nastavnik nemackog jezika',false, 450, 'Trenutno pripremamo našu školu za novu akademsku godinu kako bi postala najbolja opcija za učenje stranih jezika za decu. Prijavite se odmah, tako da ste spremni da započnete predavanje od pocetka Septembra!', 2);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (3, 'Automehanicar', false, 500, 'Zbog povecanog obima posla raspisujemo konkurs za radnu poziciju : Automehanicar za servisiranje vozila iz programa Renault i Nissan', 3);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (4, 'Advokat - saradnik', false, 800, 'Mi smo advokatska kancelarija koja veruje u rast i stalno usavrsavanje. Zainteresovani smo da prosirimo tim sa novim kolegama koji se pronalaze u našim vrednostima, dele nase ambicije i predanost klijentima.',3);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (5, 'Projektant proizvoda tapaciranog nameštaja' ,false, 800, 'Nasem timu potrebni su kandidati za poziciju Projektant proizvoda tapaciranog namestaja, ciji opis posla obuhvata : izradu kalkulacija, konstrukcija proizvoda, definisanje definisanje konstrukcijske dokumentacije...',4);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (6, 'Medicinska sestra/tehničar', false, 500,'Zbog prosirenja posla potrebno nam je medicinsko osoblje: Medicinska sestra/tehnisar.',4);
insert into oglas(idCoveka,Naslov,Tip,Plata,Opis,Mesto) values (7, 'Office administrator', false, 700, 'Kao generalni uvoznik i distributer brendova  Energizer, Varte, Firecell i Mustang, imamo najsiru i najkompletniju ponudu akumulatora u Republici Srbiji. U cilju razvoja poslovanja, oglasavamo potrebu za sledesim radnim mestom: OFFICE ADMINISTRATOR',12);

insert into telefoni values(1, '0601234567');
insert into telefoni values(2, '0601324567');
insert into telefoni values(3, '0603214567');
insert into telefoni values(4, '0601234765');
insert into telefoni values(5, '0611234567');
insert into telefoni values(6, '0611324567');
insert into telefoni values(7, '0613214567');
insert into telefoni values(8, '0611234765');
insert into telefoni values(9, '0651234567');
insert into telefoni values(10, '0651324567');
insert into telefoni values(11, '0653214567');
insert into telefoni values(12, '0651234765');
insert into telefoni values(13, '0691234567');
insert into telefoni values(14, '0691324567');
insert into telefoni values(15, '0693214567');
insert into telefoni values(16, '0691234765');

Create USER 'MyLogin'@'localhost' identified by '123123';
Grant ALL privileges on baza .* to 'MyLogin'@'localhost';