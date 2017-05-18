use sab;

insert into magacin(plata) values(0.25);

insert into Roba(naziv) values('nekaroba');

insert into sadrzijedinica(idroba, idmagacin, jedinica) values(1,1, 5);

insert into sadrzi values(1,1);

insert into radnik(ime) values('bojan');

delete from zaduzenje ;

insert into Zaduzenje values (1, null, null, null, 1,1, 5);

select * from sadrzijedinica;

insert into gradiliste(naziv) values('gradiliste')
insert into gradiliste(naziv) values('gradiliste2')
insert into gradiliste(naziv) values('gradiliste3')
insert into gradiliste(naziv, brojobjekata) values('gradiliste4', 0)

insert into objekat(gradiliste) values(3);

insert into objekat(gradiliste) values(4);

update objekat set gradiliste = 3;

update gradiliste set brojobjekata = 2;

select * from objekat;
select * from gradiliste;


alter table sprat add rednibroj int;

use sab;

select * from sadrzijedinica;

execute dbo.PovecajRobuJedinica 1,2,3000 ;

INSERT INTO [Zaduzenje](IDRadnik,IDMagacin,IDRoba,DatumZaduzenja,Napomena) values ('3','1','9','2016-06-10','...')

select * from zaduzenje;
 UPDATE [Zaduzenje] SET datumRazduzenja = '2016-08-01' WHERE ID = 1;

 UPDATE [Posao] SET DatumKraja = '2016-11-25',Status = 'Z' WHERE ID = '1';
 
 select * from radnaposlu;

 use sab;

 select  * from radnik;

 select * from radnaposlu;


 select * from zaduzenje;

 SELECT UkupnoIsplacenIznos FROM [Radnik] WHERE ID = '1'

 SELECT ID FROM [Zaduzenje] WHERE IDRadnik = '3' AND DatumRazduzenja IS NULL 

 select * from magacin;
 select * from sadrzijedinica;

 UPDATE [RadNaPoslu] SET ocena = '8' WHERE ID = '3';

 update posao set datumkraja='2017-12-10', status='Z' WHERE ID=2;

 select * from NormaUgradnogDela;

 select * from posao;

 UPDATE [Posao] SET DatumKraja = '2016-11-25',Status = 'Z' WHERE ID = '1';