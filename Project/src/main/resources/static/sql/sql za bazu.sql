-- MySQL Script generated by MySQL Workbench
-- Wed Aug 18 19:18:26 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema baza
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `baza` ;

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
  `Broj` INT(15) NOT NULL,
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
join likes l on o.idoglas = l.idoglasa
join dislikes d on o.idoglas = d.idoglasa;

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
