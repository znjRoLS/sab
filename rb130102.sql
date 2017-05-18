
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
	[Plata]              decimal(10,3)  NULL ,
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
	[Cena]               decimal(10,3)  NULL ,
	[Plata]              decimal(10,3)  NULL 
)
go

ALTER TABLE [NormaUgradnogDela]
	ADD CONSTRAINT [XPKNormaUgradnogDela] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Objekat]
( 
	[ID]                 numeric  NOT NULL  IDENTITY ,
	[BrojSpratova]       integer  NULL ,
	[Gradiliste]         numeric  NOT NULL 
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
	[Kolicina]           decimal(10,3)  NULL ,
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
	[ProsecnaOcena]      decimal(10,3)  NULL ,
	[ZaduzenaOprema]     integer  NULL ,
	[UkupnoIsplacenIznos] decimal(10,3)  NULL ,
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
	[Kolicina]           decimal(10,3)  NULL ,
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
