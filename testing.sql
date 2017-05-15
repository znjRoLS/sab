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