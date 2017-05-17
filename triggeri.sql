USE sab;
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
			ROLLBACK TRANSACTION;
		ELSE
			IF ((
			SELECT Jedinica FROM [SadrziJedinica] 
			WHERE IDRoba = @idroba AND IDMagacin = @idmagacin
			) < @jedinica)
				ROLLBACK TRANSACTION;
			ELSE 
				UPDATE [SadrziJedinica] 
				SET Jedinica = Jedinica - @jedinica
				WHERE IDRoba = @idroba AND IDMagacin = @idmagacin;

		FETCH NEXT FROM @cursor INTO @idroba, @idmagacin, @jedinica;
	END

	--DELETE FROM [SadrziJedinica] WHERE Jedinica = 0;
	-- should be in another trigger!
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

		ROLLBACK TRANSACTION;
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
		ROLLBACK TRANSACTION;
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
	IF EXISTS( SELECT * FROM inserted UNION SELECT * FROM deleted WHERE rednibroj  < 0) ROLLBACK TRANSACTION;
	IF EXISTS( 
		SELECT * FROM (
			SELECT sum(rednibroj) suma, (count(*) * (count(*) - 1)) / 2 pravasuma
			FROM [Sprat] s
			JOIN (SELECT objekat FROM inserted UNION SELECT objekat FROM deleted) j
			ON s.objekat = j.objekat
			GROUP BY s.objekat) o
		WHERE o.suma <> o.pravasuma)

		ROLLBACK TRANSACTION;


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
			SELECT AVG(Ocena) FROM RadNaPoslu 
			WHERE Ocena IS NOT NULL 
			AND IDRadnik = @idradnik
		);
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
		ROLLBACK TRANSACTION;
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
		ROLLBACK TRANSACTION;
		PRINT 'Not allowed to close job untill all workers have finished working, or finish job earlier than workers'
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
		PRINT 'Not allowed to set worker end day to null or after closed job date'
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
			PRINT 'Cannot set worker start date before job start date'
		END
		ELSE IF EXISTS (
			SELECT * FROM inserted rad
			WHERE rad.DatumKraja < rad.DatumPocetka)
			BEGIN
				ROLLBACK TRANSACTION;
				PRINT 'Cannot set end day before start day'
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
			PRINT 'Cannot change work dates when job is finished'
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
			PRINT 'Not allowed to work on two places'
		END

	ELSE
	BEGIN
		UPDATE r 
		SET r.RadiTrenutnoNaPoslu = 1
		FROM Radnik r
		JOIN inserted i on i.IDRadnik = r.ID;
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
			ROLLBACK TRANSACTION
			PRINT 'Not allowed to work two jobs'
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
			PRINT 'Not allowed to change start date of finished job'
		END

	ELSE
		IF EXISTS(
			SELECT * FROM inserted
			WHERE DatumKraja < DatumPocetka
			)
			BEGIN
				ROLLBACK TRANSACTION;
				PRINT 'Cannot set end date before start date'
			END

END


-- dont reopen job
GO
CREATE TRIGGER PosaoReopen ON [Posao]
AFTER INSERT, UPDATE, DELETE
AS BEGIN

	IF EXISTS(
		SELECT i.ID from inserted i
		JOIN deleted d ON i.ID = d.ID
		WHERE i.Status = 'Z'
		AND d.Status = 'U'
	)
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Not allowed to reopen jobs';
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
			r.prosecnaocena * norma.cena * datediff(day, rad.DatumPocetka, rad.DatumKraja)/datediff(day, posao.DatumPocetka, posao.DatumKraja)
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
	JOIN Magacin m on m.ID = @idmagacin
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
		PRINT 'Cannot delete magacin if there is some Roba or Zaposleni'
	END


END

