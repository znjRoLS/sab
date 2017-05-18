use sab;

CREATE TABLE [Firma]
( 
	[ID]                 numeric  NOT NULL  IDENTITY 
)
go

ALTER TABLE [Firma]
	ADD CONSTRAINT [XPKFirma] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Gradiliste]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Naziv]              varchar(50)  NULL ,
	[DatumOsnivanja]     datetime  NULL ,
	[BrojObjekata]       integer  NULL 
)
go

ALTER TABLE [Gradiliste]
	ADD CONSTRAINT [XPKGradiliste] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Magacin]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Plata]              decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_1094223414]
		 DEFAULT  0,
	[Sef]                numeric  NULL ,
	[Gradiliste]         numeric  NULL 
)
go

ALTER TABLE [Magacin]
	ADD CONSTRAINT [XPKMagacin] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [NormaUgradnogDela]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Naziv]              varchar(50)  NULL ,
	[Cena]               decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_1515740834]
		 DEFAULT  0,
	[Plata]              decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_1345616441]
		 DEFAULT  0
)
go

ALTER TABLE [NormaUgradnogDela]
	ADD CONSTRAINT [XPKNormaUgradnogDela] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Objekat]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[BrojSpratova]       integer  NULL ,
	[Gradiliste]         numeric  NOT NULL ,
	[Naziv]              varchar(50)  NULL 
)
go

ALTER TABLE [Objekat]
	ADD CONSTRAINT [XPKObjekat] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Posao]
( 
	[IDSprat]            numeric  NOT NULL ,
	[IDNorma]            numeric  NOT NULL ,
	[DatumPocetka]       datetime  NULL ,
	[DatumKraja]         datetime  NULL ,
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Status]             char  NULL 
	CONSTRAINT [Default_Value_Posao_U_Toku]
		 DEFAULT  'U'
	CONSTRAINT [Validation_Rule_Status]
		CHECK  ( Status = 'U' OR Status = 'Z' )
)
go

ALTER TABLE [Posao]
	ADD CONSTRAINT [XPKPosao] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [PotrosniMaterijalJedinica]
( 
	[Jedinica]           integer  NULL ,
	[IDNorma]            numeric  NOT NULL ,
	[IDRoba]             numeric  NOT NULL ,
	[ID]                 numeric  NOT NULL  IDENTITY 
)
go

ALTER TABLE [PotrosniMaterijalJedinica]
	ADD CONSTRAINT [XPKPotrosniMaterijalJedinica] PRIMARY KEY  CLUSTERED ([IDNorma] ASC,[IDRoba] ASC,[ID] ASC)
go

CREATE TABLE [PotrosniMaterijalKolicina]
( 
	[Kolicina]           decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_97904569]
		 DEFAULT  0,
	[IDRoba]             numeric  NOT NULL ,
	[IDNorma]            numeric  NOT NULL ,
	[ID]                 numeric  NOT NULL  IDENTITY 
)
go

ALTER TABLE [PotrosniMaterijalKolicina]
	ADD CONSTRAINT [XPKPotrosniMaterijalKolicina] PRIMARY KEY  CLUSTERED ([IDRoba] ASC,[IDNorma] ASC,[ID] ASC)
go

CREATE TABLE [RadNaPoslu]
( 
	[IDRadnik]           numeric  NOT NULL ,
	[Ocena]              integer  NULL ,
	[DatumPocetka]       datetime  NULL ,
	[DatumKraja]         datetime  NULL ,
	[IDPosao]            numeric  NOT NULL ,
	[ID]                 numeric  NOT NULL  IDENTITY 
)
go

ALTER TABLE [RadNaPoslu]
	ADD CONSTRAINT [XPKRadNaPoslu] PRIMARY KEY  CLUSTERED ([IDRadnik] ASC,[IDPosao] ASC,[ID] ASC)
go

CREATE TABLE [Radnik]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Firma]              numeric  NULL ,
	[Ime]                varchar(50)  NULL ,
	[Prezime]            varchar(50)  NULL ,
	[JMBG]               char(13)  NULL ,
	[Pol]                char  NULL 
	CONSTRAINT [Validation_Rule_Pol]
		CHECK  ( pol = 'M' OR pol = 'Z' ),
	[ZiroRacun]          varchar(25)  NULL ,
	[Email]              varchar(50)  NULL ,
	[Telefon]            varchar(11)  NULL ,
	[ProsecnaOcena]      decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_1853017771]
		 DEFAULT  0,
	[ZaduzenaOprema]     integer  NULL ,
	[UkupnoIsplacenIznos] decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_15663301]
		 DEFAULT  0,
	[Magacin]            numeric  NULL ,
	[RadiTrenutnoNaPoslu] bit  NULL 
)
go

ALTER TABLE [Radnik]
	ADD CONSTRAINT [XPKRadnik] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Roba]
( 
	[Naziv]              varchar(50)  NULL ,
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Kod]                varchar(10)  NULL ,
	[Tip]                numeric  NULL 
)
go

ALTER TABLE [Roba]
	ADD CONSTRAINT [XPKRoba] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [SadrziJedinica]
( 
	[Jedinica]           integer  NULL ,
	[IDRoba]             numeric  NOT NULL ,
	[IDMagacin]          numeric  NOT NULL 
)
go

ALTER TABLE [SadrziJedinica]
	ADD CONSTRAINT [XPKSadrziJedinica] PRIMARY KEY  CLUSTERED ([IDRoba] ASC,[IDMagacin] ASC)
go

CREATE TABLE [SadrziKolicinu]
( 
	[Kolicina]           decimal(10,3)  NULL 
	CONSTRAINT [Default_Value_608_1224680849]
		 DEFAULT  0,
	[IDRoba]             numeric  NOT NULL ,
	[IDMagacin]          numeric  NOT NULL 
)
go

ALTER TABLE [SadrziKolicinu]
	ADD CONSTRAINT [XPKSadrziKolicinu] PRIMARY KEY  CLUSTERED ([IDRoba] ASC,[IDMagacin] ASC)
go

CREATE TABLE [Sprat]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Objekat]            numeric  NOT NULL ,
	[RedniBroj]          integer  NULL 
)
go

ALTER TABLE [Sprat]
	ADD CONSTRAINT [XPKSprat] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

ALTER TABLE [Sprat]
	ADD CONSTRAINT [XIF2Sprat] UNIQUE ([RedniBroj]  ASC)
go

CREATE TABLE [TipRobe]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[Naziv]              varchar(50)  NULL 
)
go

ALTER TABLE [TipRobe]
	ADD CONSTRAINT [XPKTipRobe] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Zaduzenje]
( 
	[IDRadnik]           numeric  NOT NULL ,
	[DatumZaduzenja]     datetime  NULL ,
	[DatumRazduzenja]    datetime  NULL ,
	[Napomena]           varchar(200)  NULL ,
	[Jedinica]           integer  NULL ,
	[IDRoba]             numeric  NOT NULL ,
	[IDMagacin]          numeric  NOT NULL ,
	[ID]                 numeric  NOT NULL  IDENTITY 
)
go

ALTER TABLE [Zaduzenje]
	ADD CONSTRAINT [XPKZaduzenje] PRIMARY KEY  CLUSTERED ([ID] ASC)
go


ALTER TABLE [Magacin]
	ADD CONSTRAINT [R_9] FOREIGN KEY ([Sef]) REFERENCES [Radnik]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Magacin]
	ADD CONSTRAINT [R_11] FOREIGN KEY ([Gradiliste]) REFERENCES [Gradiliste]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Objekat]
	ADD CONSTRAINT [R_27] FOREIGN KEY ([Gradiliste]) REFERENCES [Gradiliste]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Posao]
	ADD CONSTRAINT [R_30] FOREIGN KEY ([IDSprat]) REFERENCES [Sprat]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Posao]
	ADD CONSTRAINT [R_33] FOREIGN KEY ([IDNorma]) REFERENCES [NormaUgradnogDela]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [PotrosniMaterijalJedinica]
	ADD CONSTRAINT [R_46] FOREIGN KEY ([IDNorma]) REFERENCES [NormaUgradnogDela]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PotrosniMaterijalJedinica]
	ADD CONSTRAINT [R_47] FOREIGN KEY ([IDRoba]) REFERENCES [Roba]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [PotrosniMaterijalKolicina]
	ADD CONSTRAINT [R_48] FOREIGN KEY ([IDRoba]) REFERENCES [Roba]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PotrosniMaterijalKolicina]
	ADD CONSTRAINT [R_49] FOREIGN KEY ([IDNorma]) REFERENCES [NormaUgradnogDela]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [RadNaPoslu]
	ADD CONSTRAINT [R_34] FOREIGN KEY ([IDRadnik]) REFERENCES [Radnik]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [RadNaPoslu]
	ADD CONSTRAINT [R_35] FOREIGN KEY ([IDPosao]) REFERENCES [Posao]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Radnik]
	ADD CONSTRAINT [R_6] FOREIGN KEY ([Firma]) REFERENCES [Firma]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Radnik]
	ADD CONSTRAINT [R_19] FOREIGN KEY ([Magacin]) REFERENCES [Magacin]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Roba]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([Tip]) REFERENCES [TipRobe]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [SadrziJedinica]
	ADD CONSTRAINT [R_41] FOREIGN KEY ([IDRoba]) REFERENCES [Roba]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [SadrziJedinica]
	ADD CONSTRAINT [R_42] FOREIGN KEY ([IDMagacin]) REFERENCES [Magacin]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [SadrziKolicinu]
	ADD CONSTRAINT [R_43] FOREIGN KEY ([IDRoba]) REFERENCES [Roba]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [SadrziKolicinu]
	ADD CONSTRAINT [R_44] FOREIGN KEY ([IDMagacin]) REFERENCES [Magacin]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Sprat]
	ADD CONSTRAINT [R_28] FOREIGN KEY ([Objekat]) REFERENCES [Objekat]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Zaduzenje]
	ADD CONSTRAINT [R_23] FOREIGN KEY ([IDRadnik]) REFERENCES [Radnik]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Zaduzenje]
	ADD CONSTRAINT [R_45] FOREIGN KEY ([IDRoba],[IDMagacin]) REFERENCES [SadrziJedinica]([IDRoba],[IDMagacin])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go



GO
CREATE TRIGGER ZaduzenjeOpremePropagate 
ON Zaduzenje
AFTER INSERT, UPDATE, DELETE
AS BEGIN
		
	SET NOCOUNT ON;

	DECLARE @idroba int, @idmagacin int, @jedinica int;
	DECLARE @cursor CURSOR;
	
	-- deleted
	SET @cursor = CURSOR FOR
	SELECT IDRoba, IDMagacin, Jedinica FROM deleted;

	OPEN @cursor;

	FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF NOT EXISTS(
		SELECT * FROM [SadrziJedinica] 
		WHERE IDRoba = @idroba AND IDMagacin = @idmagacin)
			INSERT INTO [SadrziJedinica] (IDRoba, IDMagacin, Jedinica) 
			VALUES (@idroba, @idmagacin, @jedinica);
		ELSE
			UPDATE [SadrziJedinica] 
			SET Jedinica = Jedinica + @jedinica
			WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

		FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;
	END

	CLOSE @cursor;
	DEALLOCATE @cursor;


	-- inserted
	SET @cursor = CURSOR FOR
	SELECT IDRoba, IDMagacin, Jedinica FROM inserted;

	OPEN @cursor;

	FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF NOT EXISTS(
		SELECT * FROM [SadrziJedinica] 
		WHERE IDRoba = @idroba AND IDMagacin = @idmagacin)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 51000,  'Trying to zaduziti where there is not roba in magacin', 1;
		END ELSE
			IF ((
			SELECT Jedinica FROM [SadrziJedinica] 
			WHERE IDRoba = @idroba AND IDMagacin = @idmagacin
			) < @jedinica)
			BEGIN
				ROLLBACK TRANSACTION;
				THROW 51000,  ' Not enough roba in magacin for zaduzenje', 1;
			END ELSE 
				UPDATE [SadrziJedinica] 
				SET Jedinica = Jedinica - @jedinica
				WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

		FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;
	END

	--DELETE FROM [SadrziJedinica] WHERE Jedinica = 0;
	-- should be in another trigger!


	-- razduzio
	SET @cursor = CURSOR FOR
	SELECT d.IDRoba, d.IDMagacin, d.Jedinica FROM deleted d
	JOIN inserted i ON d.IDRoba = i.IDRoba AND d.IDMagacin = i.IDMagacin
	WHERE d.DatumRazduzenja IS NULL
	AND i.DatumRazduzenja IS NOT NULL;

	OPEN @cursor;

	FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF NOT EXISTS(
		SELECT * FROM [SadrziJedinica] 
		WHERE IDRoba = @idroba AND IDMagacin = @idmagacin)
			INSERT INTO [SadrziJedinica] (IDRoba, IDMagacin, Jedinica) 
			VALUES (@idroba, @idmagacin, @jedinica);
		ELSE
			UPDATE [SadrziJedinica] 
			SET Jedinica = Jedinica + @jedinica
			WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

		FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;
	END

	CLOSE @cursor;
	DEALLOCATE @cursor;


	if EXISTS(
		SELECT d.IDRoba, d.IDMagacin, d.Jedinica FROM deleted d
		JOIN inserted i ON d.IDRoba = i.IDRoba AND d.IDMagacin = i.IDMagacin
		WHERE (d.DatumRazduzenja IS NOT NULL
		AND i.DatumRazduzenja IS NULL)
		)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Not allowed to delete datumrazduzenja', 1;
	END

	ELSE

		IF EXISTS(
			SELECT * FROM inserted
			WHERE (DatumRazduzenja < DatumZaduzenja)
			)
		BEGIN
			SELECT * FROM inserted
			WHERE (DatumRazduzenja < DatumZaduzenja);
			ROLLBACK TRANSACTION;
			THROW 51000,  'Not allowed to set datumrazduzenja before datumrazduzenja', 1;
		END

END


GO
CREATE TRIGGER PraznaRobaJedinica 
ON SadrziJedinica
AFTER  UPDATE, DELETE
AS BEGIN
	IF EXISTS(
		SELECT * FROM [SadrziJedinica]
		WHERE Jedinica < 0
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Negative jedinica in Magacin!', 1;
	END ELSE
		DELETE FROM [SadrziJedinica] WHERE Jedinica = 0;
END

GO
CREATE TRIGGER PraznaRobaKolicina 
ON SadrziKolicinu
AFTER  UPDATE, DELETE
AS BEGIN
	IF EXISTS(
		SELECT * FROM [SadrziKolicinu]
		WHERE Kolicina < 0
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Negative kolicina in magacin!', 1;
	END ELSE
		DELETE FROM [SadrziKolicinu] WHERE Kolicina = 0;
END

GO
CREATE TRIGGER ObjekatNaGradilistu 
ON Objekat
AFTER INSERT, UPDATE, DELETE
AS BEGIN
	
	DECLARE @aggregatedObjects table( gradiliste int, countInserted int);

	INSERT INTO @aggregatedObjects
	SELECT 
		CASE
			WHEN i.gradiliste IS NULL
			THEN d.gradiliste
			ELSE i.gradiliste
		END
		gradiliste,
		COALESCE(i.cnt,0) - COALESCE(d.cnt,0) countInserted
		FROM 
			(SELECT gradiliste, count(*) cnt 
				FROM inserted
				GROUP BY gradiliste) i
		FULL JOIN
			(SELECT gradiliste, count(*) cnt
				FROM deleted
				GROUP BY gradiliste) d
		ON i.gradiliste = d.gradiliste;

	UPDATE g
	SET g.BrojObjekata = g.BrojObjekata + a.countInserted
	FROM [Gradiliste] g
	JOIN @aggregatedObjects a
	ON g.id = a.gradiliste;
	
END


GO
CREATE TRIGGER SpratUObjektu 
ON Sprat
AFTER INSERT, UPDATE, DELETE
AS BEGIN
	
	DECLARE @aggregatedFloors table( objekat int, countInserted int);

	-- check if ordered floors
	IF EXISTS( SELECT * FROM inserted WHERE rednibroj < 0 UNION SELECT * FROM deleted WHERE rednibroj  < 0) 
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Sprat cannot have negative floor number', 1;

	END ELSE BEGIN
		IF EXISTS( 
			SELECT * FROM (
				SELECT sum(rednibroj) suma, (count(*) * (count(*) - 1)) / 2 pravasuma
				FROM [Sprat] s
				JOIN (SELECT objekat FROM inserted UNION SELECT objekat FROM deleted) j
				ON s.objekat = j.objekat
				GROUP BY s.objekat) o
			WHERE o.suma <> o.pravasuma)
		BEGIN

			ROLLBACK TRANSACTION;
			THROW 51000,  'Spratovi not in increasing order!', 1;

		END ELSE BEGIN
			INSERT INTO @aggregatedFloors
			SELECT 
				CASE
					WHEN i.objekat IS NULL
					THEN d.objekat
					ELSE i.objekat
				END
				objekat,
				COALESCE(i.cnt,0) - COALESCE(d.cnt,0) countInserted
				FROM 
					(SELECT objekat, count(*) cnt 
						FROM inserted
						GROUP BY objekat) i
				FULL JOIN
					(SELECT objekat, count(*) cnt
						FROM deleted
						GROUP BY objekat) d
				ON i.objekat = d.objekat;


			UPDATE g
			SET g.BrojSpratova = g.BrojSpratova + a.countInserted
			FROM [Objekat] g
			JOIN @aggregatedFloors a
			ON g.id = a.objekat;
		END
	END
	
END

GO
CREATE TRIGGER SetProsecnaOcena ON [RadNaPoslu] 
AFTER INSERT, UPDATE, DELETE 
AS BEGIN
	DECLARE @cursor CURSOR
	set @cursor = CURSOR FOR
	SELECT DISTINCT IDRadnik FROM deleted UNION SELECT DISTINCT IDRadnik FROM inserted;
	DECLARE @idradnik int;

	OPEN @cursor;
	FETCH NEXT FROM @cursor into @idradnik;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE Radnik SET ProsecnaOcena = (
			SELECT SUM(Ocena)/1.0/count(*) FROM RadNaPoslu 
			WHERE Ocena IS NOT NULL 
			AND IDRadnik = @idradnik
		)
		WHERE ID = @idradnik;
		FETCH NEXT FROM @cursor into @idradnik;
	END
END


GO
CREATE TRIGGER MaxJedanMagacin on [Magacin]
AFTER INSERT, UPDATE, DELETE
AS BEGIN
	IF EXISTS(
		SELECT * FROM (
			SELECT count(*) cnt FROM [Magacin] 
			GROUP BY Gradiliste
			) AS a
		WHERE a.cnt > 1
		)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Gradiliste cannot have more than 1 magacin', 1;
	END
END


GO
CREATE TRIGGER NapraviPosao on [Posao]
AFTER INSERT, UPDATE, DELETE
AS BEGIN
	
	DECLARE @idnorma int;
	DECLARE @idmagacin int;
	DECLARE @cursor CURSOR;

	DECLARE @idroba int;
	DECLARE @jedinica int;
	DECLARE @kolicina decimal(10,3);
	DECLARE @potrosniCursor CURSOR
	

	SET @cursor = CURSOR FOR
		SELECT posao.IDNorma, m.ID FROM deleted posao
		JOIN Sprat s ON s.ID = posao.IDSprat
		JOIN Objekat o ON o.ID = s.Objekat
		JOIN Magacin m ON m.Gradiliste = o.Gradiliste ;


	OPEN @cursor;

	FETCH NEXT FROM @cursor INTO @idnorma, @idmagacin;

	-- for each posao get normaugradnogdela (for materijal that is needed) and magacin(that has the materijal)
	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @potrosniCursor = CURSOR FOR
			SELECT IDRoba, Jedinica FROM [PotrosniMaterijalJedinica];

		OPEN @potrosniCursor;
		-- for each potrosnimaterijal for this norma, update roba in magacin
		FETCH NEXT FROM @potrosniCursor INTO @idroba, @jedinica;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF NOT EXISTS (
				SELECT * FROM [SadrziJedinica]
				WHERE IDRoba = @idroba 
				AND IDMagacin = @idmagacin
			)
				INSERT INTO [SadrziJedinica] (IDRoba, IDMagacin, Jedinica)
					VALUES( @idroba, @idmagacin, @jedinica)
			ELSE
				UPDATE [SadrziJedinica] SET Jedinica = Jedinica + @jedinica
				WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

			FETCH NEXT FROM @potrosniCursor INTO @idroba, @jedinica;
		END
		CLOSE @potrosniCursor;
		DEALLOCATE @potrosniCursor;


		SET @potrosniCursor = CURSOR FOR
			SELECT IDRoba, Kolicina FROM [PotrosniMaterijalKolicina];

		OPEN @potrosniCursor

		-- for each potrosnimaterijal for this norma, update roba in magacin
		FETCH NEXT FROM @potrosniCursor INTO @idroba, @kolicina;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF NOT EXISTS (
				SELECT * FROM [SadrziKolicinu]
				WHERE IDRoba = @idroba 
				AND IDMagacin = @idmagacin
			)
				INSERT INTO [SadrziKolicinu] (IDRoba, IDMagacin, Kolicina)
					VALUES( @idroba, @idmagacin, @kolicina)
			ELSE
				UPDATE [SadrziKolicinu] SET Kolicina = Kolicina + @kolicina
				WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

			FETCH NEXT FROM @potrosniCursor INTO @idroba, @kolicina;
		END
		CLOSE @potrosniCursor;
		DEALLOCATE @potrosniCursor;


		FETCH NEXT FROM @cursor INTO @idnorma, @idmagacin;
	END
	CLOSE @cursor;
	DEALLOCATE @cursor;

	SET @cursor = CURSOR FOR
		SELECT posao.IDNorma, m.ID FROM inserted posao
		JOIN Sprat s ON s.ID = posao.IDSprat
		JOIN Objekat o ON o.ID = s.Objekat
		JOIN Magacin m ON m.Gradiliste = o.Gradiliste ;

	OPEN @cursor;

	FETCH NEXT FROM @cursor INTO @idnorma, @idmagacin;

	-- for each posao get normaugradnogdela (for materijal that is needed) and magacin(that has the materijal)
	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @potrosniCursor = CURSOR FOR
			SELECT IDRoba, Jedinica FROM [PotrosniMaterijalJedinica];

		OPEN @potrosniCursor;
		-- for each potrosnimaterijal for this norma, update roba in magacin
		FETCH NEXT FROM @potrosniCursor INTO @idroba, @jedinica;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF NOT EXISTS (
				SELECT * FROM [SadrziJedinica]
				WHERE IDRoba = @idroba 
				AND IDMagacin = @idmagacin
			)
				INSERT INTO [SadrziJedinica] (IDRoba, IDMagacin, Jedinica)
					VALUES( @idroba, @idmagacin, -@jedinica)
			ELSE
				UPDATE [SadrziJedinica] SET Jedinica = Jedinica - @jedinica
				WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

			FETCH NEXT FROM @potrosniCursor INTO @idroba, @jedinica;
		END
		CLOSE @potrosniCursor;
		DEALLOCATE @potrosniCursor;


		SET @potrosniCursor = CURSOR FOR
			SELECT IDRoba, Kolicina FROM [PotrosniMaterijalKolicina];

		OPEN @potrosniCursor

		-- for each potrosnimaterijal for this norma, update roba in magacin
		FETCH NEXT FROM @potrosniCursor INTO @idroba, @kolicina;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF NOT EXISTS (
				SELECT * FROM [SadrziKolicinu]
				WHERE IDRoba = @idroba 
				AND IDMagacin = @idmagacin
			)
				INSERT INTO [SadrziKolicinu] (IDRoba, IDMagacin, Kolicina)
					VALUES( @idroba, @idmagacin, -@kolicina)
			ELSE
				UPDATE [SadrziKolicinu] SET Kolicina = Kolicina - @kolicina
				WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

			FETCH NEXT FROM @potrosniCursor INTO @idroba, @kolicina;
		END
		CLOSE @potrosniCursor;
		DEALLOCATE @potrosniCursor;


		FETCH NEXT FROM @cursor INTO @idnorma, @idmagacin;
	END
	CLOSE @cursor;
	DEALLOCATE @cursor; 
END


GO
CREATE TRIGGER ZatvaranjePosla ON [Posao]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS(
		SELECT * FROM inserted posao
		JOIN [RadNaPoslu] rad ON rad.IDPosao = posao.ID
		WHERE posao.Status = 'Z'
		AND (rad.DatumKraja IS NULL
		OR rad.DatumKraja > posao.DatumKraja)
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Not allowed to close job untill all workers have finished working, or finish job earlier than workers', 1;
	END
END


-- can change radnaposlu if job not finished, and check if DatumPocetka is before DatumKraja
GO
CREATE TRIGGER RadiDokJePosaoOtvoren ON [RadNaPoslu]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS (
		SELECT * FROM inserted rad
		JOIN [Posao] posao ON rad.IDPosao = posao.ID
		WHERE posao.Status = 'Z'
		AND (rad.DatumKraja IS NULL
		OR rad.DatumKraja > posao.DatumKraja)
	
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Not allowed to set worker end day to null or after closed job date', 1;
	END
	ELSE
		IF EXISTS (
			SELECT * FROM inserted rad
			JOIN [Posao] posao ON rad.IDPosao = posao.ID
			WHERE rad.DatumPocetka IS NOT NULL 
			AND (posao.DatumPocetka IS NULL 
			OR rad.DatumPocetka < posao.DatumPocetka)
		)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 51000,  'Cannot set worker start date before job start date', 1;
		END
		ELSE IF EXISTS (
			SELECT * FROM inserted rad
			WHERE rad.DatumKraja < rad.DatumPocetka)
			BEGIN
				ROLLBACK TRANSACTION;
				THROW 51000,  'Cannot set end day before start day', 1;
			END
END


-- cannot change dates if job is finished
GO
CREATE TRIGGER RadNaPosluPromenaDatuma ON [RadNaPoslu]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS(
		SELECT * FROM inserted i
		JOIN deleted d ON i.IDRadnik = d.IDRadnik AND i.IDPosao = d.IDPosao
		JOIN Posao posao ON posao.ID = i.IDPosao
		WHERE posao.Status = 'Z'
		AND (i.DatumPocetka <> d.DatumPocetka
		OR i.DatumKraja <> d.DatumKraja)
	)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 51000,  'Cannot change work dates when job is finished', 1;
		END
	
END


-- update raditrenutnonaposlu
GO
CREATE TRIGGER RadiTrenutnoNaPosluUgradniDeo ON [RadNaPoslu]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	UPDATE r
	SET r.RadiTrenutnoNaPoslu = 0
	FROM Radnik r
	JOIN deleted d on d.IDRadnik = r.ID
	;

	IF EXISTS(
		SELECT * FROM Radnik r
		JOIN inserted i on i.IDRadnik = r.ID
		WHERE r.RadiTrenutnoNaPoslu = 1
	)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 51000,  'Not allowed to work on two places', 1;
		END

	ELSE
	BEGIN
		UPDATE r 
		SET r.RadiTrenutnoNaPoslu = 1
		FROM Radnik r
		JOIN inserted i on i.IDRadnik = r.ID
		WHERE i.datumKraja IS NULL;
	END

END


-- update raditrenutnonaposlu
GO
CREATE TRIGGER RadiTrenutnoNaPosluMagacin ON [Radnik]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS(
		SELECT * from inserted i
		JOIN deleted d on d.ID = i.ID
		WHERE d.RadiTrenutnoNaPoslu = 1
		AND d.Magacin IS NULL
		AND i.Magacin IS NOT NULL
	)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 51000,  'Not allowed to work two jobs', 1;
		END

	ELSE
	BEGIN
		UPDATE  r
		SET r.RadiTrenutnoNaPoslu = 1
		FROM Radnik r
		WHERE r.Magacin IS NOT NULL;
	END

END

-- change date only if job open
GO
CREATE TRIGGER PosaoDatumPocetka ON [Posao]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS(
		SELECT i.ID from inserted i
		JOIN deleted d ON i.ID = d.ID
		WHERE i.Status = 'Z'
		AND i.DatumPocetka <> d.DatumPocetka
	)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 51000,  'Not allowed to change start date of finished job', 1;
		END

	ELSE
		IF EXISTS(
			SELECT * FROM inserted
			WHERE DatumKraja < DatumPocetka
			)
			BEGIN
				ROLLBACK TRANSACTION;
				THROW 51000,  'Cannot set end date before start date', 1;
			END

END


-- dont reopen job
go
CREATE TRIGGER PosaoReopen ON [Posao]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS(
		SELECT i.ID from inserted i
		JOIN deleted d ON i.ID = d.ID
		WHERE i.Status = 'U'
		AND d.Status = 'Z'
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Not allowed to reopen jobs', 1;
	END

END


-- give pay when job is marked as finished
GO 
CREATE TRIGGER IsplataPlata ON [Posao]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	DECLARE @idposao int;
	DECLARE @idnorma int;
	DECLARE @cursor CURSOR;

	SET @cursor =  CURSOR FOR
		SELECT i.ID, i.IDNorma from inserted i
		JOIN deleted d ON i.ID = d.ID
		WHERE i.Status = 'Z'
		AND d.Status = 'U';

	OPEN @cursor

	FETCH NEXT FROM @cursor INTO @idposao, @idnorma;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		UPDATE r
		SET r.UkupnoIsplacenIznos = r.UkupnoIsplacenIznos + 
			1.0 * r.prosecnaocena  * (datediff(day, rad.DatumPocetka, rad.DatumKraja)+1)/(datediff(day, posao.DatumPocetka, posao.DatumKraja)+1) * norma.plata
		FROM Radnik r
		JOIN [RadNaPoslu] rad ON r.ID = rad.IDRadnik
		JOIN [NormaUgradnogDela] norma ON norma.ID = @idnorma
		JOIN [Posao] posao ON posao.ID = @idposao
		WHERE rad.IDPosao = @idposao;

		FETCH NEXT FROM @cursor INTO @idposao, @idnorma;
	END
	CLOSE @cursor;
	DEALLOCATE @cursor;

END


-- magacin pay
GO
CREATE PROCEDURE IsplatiPlateUMagacinu @idmagacin int
AS BEGIN
	UPDATE r
	SET r.UkupnoIsplacenIznos = r.UkupnoIsplacenIznos + m.plata
	FROM Radnik r
	JOIN Magacin m on r.Magacin = m.ID
	AND m.ID = @idmagacin
	
END



-- magacin delete only if empty
GO
CREATE TRIGGER DeleteMagacin ON [Magacin]
AFTER DELETE
AS BEGIN

	IF EXISTS(
		SELECT m.ID FROM SadrziJedinica s
		JOIN deleted m ON m.ID = s.IDMagacin
		UNION
		SELECT m.ID FROM SadrziKolicinu s
		JOIN deleted m ON m.ID = s.IDMagacin
		UNION
		SELECT m.ID FROM Radnik r
		JOIN deleted m ON m.ID = r.Magacin
		UNION
		SELECT m.ID FROM deleted m 
		WHERE m.sef IS NOT NULL
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51000,  'Cannot delete magacin if there is some Roba or Zaposleni', 1;
	END
END


GO
CREATE TRIGGER UpdateSef ON [Magacin]
AFTER INSERT
AS BEGIN
	UPDATE rad
	SET rad.Magacin = mag.ID
	FROM Radnik rad
	JOIN inserted mag ON mag.Sef = rad.ID;
END

GO
CREATE PROCEDURE PovecajRobuJedinica @idmagacin int, @idRoba int, @jedinica int
AS BEGIN
	if EXISTS(
		SELECT * FROM SadrziJedinica
		WHERE IDMagacin = @idmagacin
		AND IDRoba = @idroba
	)
	BEGIN
		UPDATE SadrziJedinica SET Jedinica = Jedinica + @jedinica
		WHERE IDMagacin = @idmagacin
		AND IDRoba = @idroba
	END
	ELSE BEGIN
		INSERT INTO SadrziJedinica (IDMagacin, IDRoba, Jedinica)
		VALUES (@idmagacin, @idroba, @jedinica)
	END
END


GO
CREATE PROCEDURE PovecajRobuKolicina @idmagacin int, @idRoba int, @kolicina decimal(10,3)
AS BEGIN
	if EXISTS(
		SELECT * FROM SadrziKolicinu
		WHERE IDMagacin = @idmagacin
		AND IDRoba = @idroba
	)
	BEGIN
		UPDATE SadrziKolicinu SET Kolicina = Kolicina + @kolicina
		WHERE IDMagacin = @idmagacin
		AND IDRoba = @idroba
	END
	ELSE BEGIN
		INSERT INTO SadrziKolicinu (IDMagacin, IDRoba, Kolicina)
		VALUES (@idmagacin, @idroba, @kolicina)
	END
END



GO
CREATE PROCEDURE SmanjiRobuJedinica @idmagacin int, @idRoba int, @jedinica int
AS BEGIN

	UPDATE SadrziJedinica SET Jedinica = Jedinica - @jedinica
	WHERE IDMagacin = @idmagacin
	AND IDRoba = @idroba

END


GO
CREATE PROCEDURE SmanjiRobuKolicina @idmagacin int, @idRoba int, @kolicina decimal(10,3)
AS BEGIN

	UPDATE SadrziKolicinu SET Kolicina = Kolicina - @kolicina
	WHERE IDMagacin = @idmagacin
	AND IDRoba = @idroba

END


GO
CREATE PROCEDURE SviRadniciZavrsavaju @idposla int, @datumKraja datetime
AS BEGIN
	UPDATE rad SET rad.datumKraja = @datumKraja
	FROM RadNaPoslu rad
	JOIN Posao posao ON posao.ID = rad.IDPosao
	WHERE rad.datumKraja IS NULL
	AND posao.ID = @idposla
END
