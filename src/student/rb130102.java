/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student;

import funkcionalnosti.Funkcionalnosti;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author rols
 */
public class rb130102 extends Funkcionalnosti{

    DBHelper dbhelper;

    public rb130102() {
        dbhelper = new DBHelper();
    }

    @Override
    public int unesiGradiliste(String naziv, Date datumOsnivanja) {
        return dbhelper.insert("Gradiliste", new String[]{"Naziv", "DatumOsnivanja"}, new String[] {naziv, datumOsnivanja.toString()});
    }

    @Override
    public int obrisiGradiliste(int idGradiliste) {
        if (dbhelper.delete("Gradiliste", new String[]{"ID"}, new String[]{String.valueOf(idGradiliste)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<Integer> dohvatiSvaGradilista() {

        List<Integer> res = new ArrayList<>();
        for (List<String> row : dbhelper.select("Gradiliste",new String[] {"id"}, null, null)) {
            res.add(Integer.parseInt(row.get(0)));
        }

        return res;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiObjekat(String naziv, int idGradiliste) {

        return dbhelper.insert("Objekat", new String[] {"Naziv", "Gradiliste"}, new String[] {naziv, String.valueOf(idGradiliste)});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiObjekat(int idObjekat) {
        if (dbhelper.delete("Objekat",new  String[]{"ID"},new String[] {String.valueOf(idObjekat)})) {
            return idObjekat;
        }
        return -1;
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiSprat(int brSprata, int idObjekat) {
        return dbhelper.insert("Sprat", new String[] {"RedniBroj", "Objekat"}, new String[]{String.valueOf(brSprata), String.valueOf(idObjekat)});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiSprat(int idSprat) {
        if (dbhelper.delete("Sprat", new String[]{"ID"}, new String[]{String.valueOf(idSprat)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiZaposlenog(String ime, String prezime, String jmbg, String pol, String ziroRacun, String email, String brojTelefona) {
        return dbhelper.insert("Radnik", new String[] {"Ime", "Prezime", "jmbg", "pol", "ziroRacun", "email", "Telefon", "ProsecnaOcena"},
                new String[]{ime, prezime, jmbg, pol, ziroRacun, email, brojTelefona, "10"});
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiZaposlenog(int idZaposleni) {
        if (dbhelper.delete("Radnik", new String[]{"ID"}, new String[]{String.valueOf(idZaposleni)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public BigDecimal dohvatiUkupanIsplacenIznosZaZaposlenog(int idZaposleni) {
        return new BigDecimal(
                dbhelper.select(
                        "Radnik",
                        new String[]{"UkupnoIsplacenIznos"},
                        new String[]{"ID"},
                        new String[]{String.valueOf(idZaposleni
                        )}).get(0).get(0)
                .replace(",", "")
        );

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public BigDecimal dohvatiProsecnuOcenuZaZaposlenog(int idZaposleni) {
        return new BigDecimal(
                dbhelper.select(
                        "Radnik",
                        new String[]{"ProsecnaOcena"},
                        new String[]{"ID"},
                        new String[]{String.valueOf(idZaposleni
                        )}).get(0).get(0)
                        .replace(",", "")
        );

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int dohvatiBrojTrenutnoZaduzeneOpremeZaZaposlenog(int idZaposleni) {
        return dbhelper.select("Zaduzenje",
                new String[]{"ID"},
                new String[]{"IDRadnik", "DatumRazduzenja"},
                new String[]{String.valueOf(idZaposleni), "null"}
                ).size();

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<Integer> dohvatiSveZaposlene() {
        List<List<String>> lista = dbhelper.select("Radnik", new String[]{"ID"}, null, null);
        List<Integer> res = new ArrayList<>();

        for (List<String> row : lista) {
            res.add(Integer.parseInt(row.get(0)));
        }

        return res;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiMagacin(int idSef, BigDecimal plata, int idGradiliste) {
        return dbhelper.insert("Magacin",
                new String[]{"Sef", "Plata", "Gradiliste"},
                new String[]{String.valueOf(idSef), String.valueOf(plata.floatValue()), String.valueOf(idGradiliste)});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiMagacin(int idMagacin) {
        if (dbhelper.delete("Magacin", new String[] {"ID"}, new String[] {String.valueOf(idMagacin)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int izmeniSefaZaMagacin(int idMagacin, int idSefNovo) {
        if ( dbhelper.update("Magacin",
                new String[] {"Sef"},
                new String[] {String.valueOf(idSefNovo)},
                new String[] {"ID"},
                new String[] {String.valueOf(idMagacin)}
                )) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int izmeniPlatuZaMagacin(int idMagacin, BigDecimal plataNovo) {
        if ( dbhelper.update("Magacin",
                new String[] {"plata"},
                new String[] {String.valueOf(plataNovo.floatValue())},
                new String[] {"ID"},
                new String[] {String.valueOf(idMagacin)}
        )) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int isplatiPlateZaposlenimaUSvimMagacinima() {
        List<List<String>> magacini = dbhelper.select("Magacin", new String[]{"ID"}, null,null);
        int res = 0;
        for (List<String> magacin : magacini) {
            if (!dbhelper.call("IsplatiPlateUMagacinu", new String[]{magacin.get(0)})) {
                res = -1;
            }
        }

        return res;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int isplatiPlateZaposlenimaUMagacinu(int idMagacin) {
        if (dbhelper.call("IsplatiPlateUMagacinu", new String[]{String.valueOf(idMagacin)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiRobuUMagacinPoKolicini(int idRoba, int idMagacin, BigDecimal kolicina) {
        if( dbhelper.call("PovecajRobuKolicina",
                new String[] {String.valueOf(idMagacin), String.valueOf(idRoba), String.valueOf(kolicina.floatValue())})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiRobuUMagacinPoBrojuJedinica(int idRoba, int idMagacin, int brojJedinica) {
        if (dbhelper.call("PovecajRobuJedinica",
                new String[] {String.valueOf(idMagacin), String.valueOf(idRoba), String.valueOf(brojJedinica)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public BigDecimal uzmiRobuIzMagacinaPoKolicini(int idRoba, int idMagacin, BigDecimal kolicina) {
        BigDecimal imaKolicine = pogledajKolicinuRobeUMagacinu(idRoba, idMagacin);
        if (imaKolicine.floatValue() < kolicina.floatValue()) kolicina = imaKolicine;

        dbhelper.call("SmanjiRobuKolicina",
                new String[]{String.valueOf(idMagacin), String.valueOf(idRoba), String.valueOf(kolicina.floatValue())});

        return imaKolicine;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int uzmiRobuIzMagacinaPoBrojuJedinica(int idRoba, int idMagacin, int brojJedinca) {

        int imaJedinica = pogledajBrojJedinicaRobeUMagacinu(idRoba, idMagacin);
        if (imaJedinica < brojJedinca) brojJedinca = imaJedinica;

        dbhelper.call("SmanjiRobuJedinica",
                new String[]{String.valueOf(idMagacin), String.valueOf(idRoba), String.valueOf(brojJedinca)});

        return imaJedinica;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public BigDecimal pogledajKolicinuRobeUMagacinu(int idRoba, int idMagacin) {
        String kolicina = dbhelper.select(
                "SadrziKolicinu",
                new String[]{"kolicinu"},
                new String[]{"IDRoba", "IDMagacin"},
                new String[]{String.valueOf(idRoba), String.valueOf(idMagacin)}).get(0).get(0);

        return new BigDecimal(kolicina.replace(",", ""));

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int pogledajBrojJedinicaRobeUMagacinu(int idRoba, int idMagacin) {
        String jedinica = dbhelper.select(
                "SadrziJedinica",
                new String[]{"jedinica"},
                new String[]{"IDRoba", "IDMagacin"},
                new String[]{String.valueOf(idRoba), String.valueOf(idMagacin)}).get(0).get(0);

        return Integer.parseInt(jedinica);

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiTipRobe(String naziv) {

        return dbhelper.insert("TipRobe", new String[]{"Naziv"}, new String[]{naziv});
    }

    @Override
    public int obrisiTipRobe(int idTipRobe) {

        dbhelper.delete("TipRobe", new String[]{"ID"}, new String[]{String.valueOf(idTipRobe)});

        return idTipRobe;
    }

    @Override
    public int unesiRobu(String naziv, String kod, int idTipRobe) {
        return dbhelper.insert("Roba", new String[]{"Naziv", "Kod", "Tip"}, new String[]{naziv, kod, String.valueOf(idTipRobe)});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiRobu(int idRoba) {
        if (dbhelper.delete("Roba", new String[]{"ID"}, new String[]{String.valueOf(idRoba)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<Integer> dohvatiSvuRobu() {
        List<Integer> res = new ArrayList<>();

        for (List<String> row : dbhelper.select("Roba", new String[]{"ID"}, null, null)) {
            res.add(Integer.parseInt(row.get(0)));
        }

        return res;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniRadiUMagacinu(int idZaposleni, int idMagacin) {
        if( dbhelper.update("Radnik",
                new String[]{"Magacin"},
                new String[]{String.valueOf(idMagacin)},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleni)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniNeRadiUMagacinu(int idZaposleni) {
        if (dbhelper.update("Radnik",
                new String[]{"Magacin"},
                new String[]{"null"},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleni)})) {
            return 0;
        }
        return -1;

       // throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniZaduzujeOpremu(int idZaposlenogKojiZaduzuje, int idMagacin, int idRoba, Date datumZaduzenja, String napomena) {
        return dbhelper.insert("Zaduzenje",
                new String[]{"IDRadnik", "IDMagacin", "IDRoba", "DatumZaduzenja", "Napomena", "Jedinica"},
                new String[]{String.valueOf(idZaposlenogKojiZaduzuje), String.valueOf(idMagacin), String.valueOf(idRoba),
                    datumZaduzenja.toString(), napomena, "1"}
                );

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniRazduzujeOpremu(int idZaduzenjaOpreme, Date datumRazduzenja) {
        if (dbhelper.update(
                "Zaduzenje",
                new String[]{"datumRazduzenja"},
                new String[]{datumRazduzenja.toString()},
                new String[]{"ID"},
                new String[] {String.valueOf(idZaduzenjaOpreme)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiNormuUgradnogDela(String naziv, BigDecimal cenaIzrade, BigDecimal jedinicnaPlataRadnika) {
        return dbhelper.insert("NormaUgradnogDela",
                new String[]{"Naziv", "Cena", "Plata"},
                new String[]{naziv, String.valueOf(cenaIzrade.floatValue()), String.valueOf(jedinicnaPlataRadnika.floatValue())});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiNormuUgradnogDela(int idNormaUgradnogDela) {
        if (dbhelper.delete("NormaUgradnogDela", new String[]{"ID"}, new String[]{String.valueOf(idNormaUgradnogDela)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public BigDecimal dohvatiJedinicnuPlatuRadnikaNormeUgradnogDela(int idNR) {
        String plata = dbhelper.select("NormaUgradnogDela", new String[]{"plata"},
                new String[]{"ID"}, new String[]{String.valueOf(idNR)}).get(0).get(0);

        return new BigDecimal(plata.replace(",", ""));

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiPotrebanMaterijalPoBrojuJedinica(int idRobaKojaJePotrosniMaterijal, int idNormaUgradnogDela, int brojJedinica) {
        return dbhelper.insert("PotrosniMaterijalJedinica",
                new String[]{"IDRoba", "IDNorma", "Jedinica"},
                new String[]{String.valueOf(idRobaKojaJePotrosniMaterijal), String.valueOf(idNormaUgradnogDela), String.valueOf(brojJedinica)});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiPotrebanMaterijalPoKolicini(int idRobaKojaJePotrosniMaterijal, int idNormaUgradnogDela, BigDecimal kolicina) {
        return dbhelper.insert("PotrosniMaterijalKolicina",
                new String[]{"IDRoba", "IDNorma", "Kolicina"},
                new String[]{String.valueOf(idRobaKojaJePotrosniMaterijal), String.valueOf(idNormaUgradnogDela), String.valueOf(kolicina)});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiPotrebanMaterijal(int idRobaKojaJePotrosniMaterijal, int idNormaUgradnogDela) {
        if (dbhelper.delete("PotrosniMaterijalJedinica",
                new String[]{"IDRoba", "IDNorma"},
                new String[]{String.valueOf(idRobaKojaJePotrosniMaterijal), String.valueOf(idNormaUgradnogDela)})) {
            if (dbhelper.delete("PotrosniMaterijalKolicina",
                    new String[]{"IDRoba", "IDNorma"},
                    new String[]{String.valueOf(idRobaKojaJePotrosniMaterijal), String.valueOf(idNormaUgradnogDela)})) {
                return 0;
            }
        }
        return -1;
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int unesiPosao(int idNormaUgradnogDela, int idSprat, Date datumPocetka) {
        return dbhelper.insert("Posao",
                new String[]{"IDNorma", "IDSprat", "DatumPocetka"},
                new String[]{String.valueOf(idNormaUgradnogDela), String.valueOf(idSprat), datumPocetka.toString()});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiPosao(int idPosao) {
        if(dbhelper.delete("Posao", new String[]{"ID"}, new String[]{String.valueOf(idPosao)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int izmeniDatumPocetkaZaPosao(int idPosao, Date datumPocetka) {
        if (dbhelper.update("Posao",
                new String[]{"DatumPocetka"},
                new String[]{datumPocetka.toString()},
                new String[]{"ID"},
                new String[]{String.valueOf(idPosao)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zavrsiPosao(int idPosao, Date datumKraja) {

        dbhelper.call("SviRadniciZavrsavaju", new String[]{String.valueOf(idPosao),datumKraja.toString()});

        if (dbhelper.update("Posao",
                new String[]{"DatumKraja", "Status"},
                new String[]{datumKraja.toString(), "Z"},
                new String[]{"ID"},
                new String[]{String.valueOf(idPosao)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniRadiNaPoslu(int idZaposleni, int idPosao, Date datumPocetka) {
        return dbhelper.insert("RadNaPoslu",
                new String[]{"IDRadnik", "IDPosao", "DatumPocetka"},
                new String[]{String.valueOf(idZaposleni), String.valueOf(idPosao), datumPocetka.toString()});

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniJeZavrsioSaRadomNaPoslu(int idZaposleniNaPoslu, Date datumKraja) {
        if ( dbhelper.update("RadNaPoslu",
                new String[]{"DatumKraja"},
                new String[]{datumKraja.toString()},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleniNaPoslu)})) {
            return 0;
        }
        return -1;

        //
        // throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int izmeniDatumPocetkaRadaZaposlenogNaPoslu(int idZaposleniNaPoslu, Date datumPocetkaNovo) {
        if (dbhelper.update("RadNaPoslu",
                new String[]{"DatumPocetka"},
                new String[]{datumPocetkaNovo.toString()},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleniNaPoslu)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int izmeniDatumKrajaRadaZaposlenogNaPoslu(int idZaposleniNaPoslu, Date datumKrajaNovo) {
        if (dbhelper.update("RadNaPoslu",
                new String[]{"DatumKraja"},
                new String[]{datumKrajaNovo.toString()},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleniNaPoslu)})){
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int zaposleniDobijaOcenu(int idZaposleniNaPoslu, int ocena) {
        if (dbhelper.update("RadNaPoslu",
                new String[]{"Ocena"},
                new String[]{String.valueOf(ocena)},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleniNaPoslu)})) {
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int obrisiOcenuZaposlenom(int idZaposleniNaPoslu) {
         if (dbhelper.update("RadNaPoslu",
                new String[]{"ocena"},
                new String[]{"null"},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleniNaPoslu)})) {
             return 0;
         }
         return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int izmeniOcenuZaZaposlenogNaPoslu(int idZaposleniNaPoslu, int ocenaNovo) {
        if (dbhelper.update("RadNaPoslu",
                new String[]{"ocena"},
                new String[]{String.valueOf(ocenaNovo)},
                new String[]{"ID"},
                new String[]{String.valueOf(idZaposleniNaPoslu)})){
            return 0;
        }
        return -1;

        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
