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
	DELETE FROM [SadrziJedinica] WHERE Jedinica = 0;
END

GO
CREATE TRIGGER PraznaRobaKolicina 
ON SadrziKolicinu
AFTER  UPDATE, DELETE
AS BEGIN
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

