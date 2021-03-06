package com.example.Project;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.boot.configurationprocessor.json.JSONArray;
import org.springframework.boot.configurationprocessor.json.JSONException;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ProjectController implements ErrorController {

    DatabaseConnector db = new DatabaseConnector();

    @GetMapping("/")
    public String home(HttpServletRequest req, HttpServletResponse res) {
        return "index";
    }

    @GetMapping("/error")
    public String greska() {
        return "redirect:/";
    }

    @GetMapping("/oglasi")
    public String oglasi(HttpServletRequest req, HttpServletResponse res) {
        return "sviOglasi";
    }

    @GetMapping("/potrazi")
    public @ResponseBody List<Oglas> potrazi(@RequestParam Integer tag, @RequestParam Integer mesto) {
        List<Oglas> oglasi = db.Daj_Oglase(tag, mesto);
        if (!oglasi.isEmpty()) {
            return oglasi;
        }
        return oglasi;
    }

    @GetMapping("/signup")
    public String signup(HttpServletRequest req, HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            return "redirect:/signin";
        }
        return "signup";
    }

    @PostMapping("/signup")
    public @ResponseBody List<errorCode> register(@RequestBody String body, HttpServletRequest req,
            HttpServletResponse res) {
        JSONObject js;
        List<errorCode> lista = new ArrayList<errorCode>();
        try {
            js = new JSONObject(body);
            if (body != null) {
                if (db.nadjiUser("username", js.getString("user")))
                    lista.add(new errorCode("UsernameVecPostoji"));
                if (db.nadjiUser("email", js.getString("email")))
                    lista.add(new errorCode("EmailVecPostoji"));
                if (js.getString("pass") == null)
                    lista.add(new errorCode("NeOdgovarajucaSifra"));
                if (js.getString("name") == null)
                    lista.add(new errorCode("NemaIme"));
                if (js.getString("telefon") == null)
                    lista.add(new errorCode("nemabroj"));
                if (js.getString("person") == null)
                    lista.add(new errorCode("nijeseoznacio"));
                if (lista.isEmpty()) {
                    lista.add(new errorCode("OK"));
                    db.ubaciUsera(js.getString("user"), js.getString("pass"), js.getString("name"),
                            js.getString("email"), js.getInt("mesto"), js.getInt("telefon"), js.getBoolean("person"));
                }
                return lista;
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        lista.add(new errorCode("LosBody"));
        return lista;
    }

    @GetMapping("/signin")
    public String signin(HttpServletRequest req, HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null)
            return "redirect:/";
        return "signin";
    }

    @PostMapping("/signin")
    public @ResponseBody List<errorCode> login(@RequestBody String body, HttpServletRequest req,
            HttpServletResponse res) {
        JSONObject js;
        List<errorCode> lista = new ArrayList<errorCode>();
        try {
            js = new JSONObject(body);
            if (body != null) {
                if (!db.proveriSignin(js.getString("user"), js.getString("pass"), js.getBoolean("rememberMe")))
                    lista.add(new errorCode("PasswordIliUsernameNisuUredu"));
                if (lista.isEmpty()) {
                    if (js.getBoolean("rememberMe") == true)
                        CookieManager.makeCookie(req, res, js.getString("user"), true);
                    else
                        CookieManager.makeCookie(req, res, js.getString("user"), false);
                    lista.add(new errorCode("OK"));
                }
                return lista;
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        lista.add(new errorCode("losBody"));
        return lista;
    }

    @GetMapping("/signout")
    public String signout(HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie;
        if ((cookie = CookieManager.getCookie(req)) != null)
            CookieManager.deleteCookie(req, res);
        return "redirect:/";
    }

    @GetMapping("/profil")
    public String Profil(@RequestParam(required = false) Integer user, HttpServletRequest req,
            HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (cookie == null && user == null)
            return "redirect:/";
        else {
            if (cookie != null) {
                if (user == null) {
                    return "profil";
                }
                if (db.dajId(CookieManager.getContent(cookie)) == user)
                    return "profil";
                Prijavljen pr = db.logovan(CookieManager.getContent(cookie));
                if (pr.admin || pr.poslodavac)
                    return "profil";
            }
            Prijavljen pr = db.logovan(db.dajUsername(user));
            if (pr.poslodavac)
                return "profil";
        }

        return "redirect:/";
    }

    @GetMapping("/profile")
    public @ResponseBody Korisnik nazivProfila(@RequestParam(required = false) Integer user, HttpServletRequest req,
            HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (user != null) {
            Korisnik k = db.Daj_Korisnika(user);
            k.password = "";
            return k;
        } else if (cookie != null && db.proveriCoveka(CookieManager.getContent(cookie))) {
            Korisnik k = db.Daj_Korisnika(db.dajId(CookieManager.getContent(cookie)));
            k.password = "";
            return k;
        }

        return null;
    }

    @PostMapping("/update")
    public @ResponseBody String update(@RequestBody String body, HttpServletRequest req, HttpServletResponse res) {
        JSONObject js;
        try {
            js = new JSONObject(body);
            if (body != null) {
                db.update(js.getInt("id"), js.getString("ime"), js.getString("username"), js.getString("password1"),
                        js.getString("password2"), js.getString("email"), js.getInt("mesto"), js.getString("opis"));
                return "OK";
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return "BAD";
    }

    @GetMapping("/cities")
    public @ResponseBody List<Mesto> gradovi(HttpServletRequest req, HttpServletResponse res) {
        List<Mesto> lista = db.Daj_gradove();
        if (lista.isEmpty()) {
            lista.add(new Mesto(-1, "Nema gradova"));
        }
        return lista;
    }

    @GetMapping("/tags")
    public @ResponseBody List<Tagovi> tagovi(HttpServletRequest req, HttpServletResponse res) {
        return db.Daj_tagove();
    }

    @PostMapping("/prijavi")
    public String prijavise(@RequestParam Integer id, @RequestBody String body, HttpServletRequest req,
            HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null) {
            if (db.prijavise(db.dajId(CookieManager.getContent(CookieManager.getCookie(req))), id, body))
                return "redirect:/profil";
        }
        return "redirect:/profil";
    }

    @PostMapping("/like")
    public @ResponseBody String lajkuj(@RequestParam Integer id, @RequestParam String lajk, HttpServletRequest req,
            HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            db.lajkuj(db.dajId(CookieManager.getContent(CookieManager.getCookie(req))), id, lajk);
        }
        return "redirect:/oglas?id=" + id;
    }

    @GetMapping("/lajkovao")
    public @ResponseBody errorCode lajkovao(@RequestParam Integer id, HttpServletRequest req, HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            return db.proverilajk(db.dajId(CookieManager.getContent(CookieManager.getCookie(req))), id);
        }
        return new errorCode("nista");
    }

    @PostMapping("/oceni")
    public @ResponseBody String oceni(@RequestParam Integer id, @RequestParam Integer ocena, HttpServletRequest req,
            HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            if (db.oceni(db.dajId(CookieManager.getContent(CookieManager.getCookie(req))), id, ocena))
                return "OK";
        }
        return "false";
    }

    @GetMapping("/ocena")
    public @ResponseBody errorCode ocena(@RequestParam(required = false) Integer id, HttpServletRequest req,
            HttpServletResponse res) {
        Integer ocena = -1;
        if (CookieManager.getCookie(req) != null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            ocena = db.dataOcena(db.dajId(CookieManager.getContent(CookieManager.getCookie(req))), id);
            if (ocena == null) {
                ocena = -1;
            }
        }
        return new errorCode(ocena.toString());
    }

    @GetMapping("/oglas")
    public String oglas(HttpServletRequest req, HttpServletResponse res) {
        return "stranicaOglasa";
    }

    @GetMapping("/sveooglasu")
    public @ResponseBody Oglas oglasu(@RequestParam Integer id, HttpServletRequest req, HttpServletResponse res) {
        Oglas oglas = db.Daj_Oglas(id);
        return oglas;
    }

    @GetMapping("/mojioglasi")
    public @ResponseBody List<Oglas> mojioglasi(@RequestParam(required = false) Integer user, HttpServletRequest req,
            HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        List<Oglas> k;
        if (cookie == null && user == null)
            return null;
        if (cookie != null && user == null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            k = db.Daj_Mojeoglase(db.dajId(CookieManager.getContent(cookie)));
        } else {
            k = db.Daj_Mojeoglase(user);
        }
        if (k != null) {
            return k;
        }
        return null;
    }

    @GetMapping("/telefon")
    public @ResponseBody List<errorCode> telefon(@RequestParam(required = false) Integer user, HttpServletRequest req,
            HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        List<errorCode> k;
        if (cookie == null && user == null)
            return null;
        if (cookie != null && user == null
                && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            k = db.Daj_telefone(db.dajId(CookieManager.getContent(cookie)));
        } else {
            k = db.Daj_telefone(user);
        }
        if (k != null) {
            return k;
        }
        return null;
    }

    @PostMapping("/izmenitelefone")
    public @ResponseBody String tel(@RequestBody String brojevi, HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        JSONObject js;
        if (cookie != null && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            try {
                js = new JSONObject(brojevi);
                JSONArray niz = js.getJSONArray("telefoni");
                db.izbrisiTelefone(db.dajId(CookieManager.getContent(cookie)));
                for (int i = 0; i < niz.length(); i++) {
                    db.ubaciTelefon(db.dajId(CookieManager.getContent(cookie)), niz.getString(i));
                }

                return "OK";
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return "bad";
    }

    @GetMapping("/prijavljeni")
    public @ResponseBody List<Korisnik> prijavljeni(@RequestParam Integer id, HttpServletRequest req,
            HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (cookie != null && db.proveriCoveka(CookieManager.getContent(CookieManager.getCookie(req)))) {
            if (db.jelovomoje(db.dajId(CookieManager.getContent(cookie)), id)
                    || db.logovan(CookieManager.getContent(cookie)).admin) {
                return db.prijavljeni(id);
            }
        }
        return null;
    }

    @GetMapping("/cv")
    public @ResponseBody errorCode cv(HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (cookie != null && db.proveriCoveka(CookieManager.getContent(cookie))) {
            Korisnik covek = db.Daj_Korisnika(db.dajId(CookieManager.getContent(cookie)));
            if (covek.opis == null || covek.opis == "")
                return new errorCode("");
            return new errorCode(covek.opis);
        }
        return null;
    }

    @GetMapping("/poslodavci")
    public String poslodavci(HttpServletRequest req, HttpServletResponse res) {
        return "poslodavci";
    }

    @GetMapping("/poslodavcii")
    public @ResponseBody List<Korisnik> poslodavcii(HttpServletRequest req, HttpServletResponse res) {
        return db.Daj_Poslodavce();
    }

    @GetMapping("/login")
    public @ResponseBody Prijavljen login(HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (cookie == null || !db.proveriCoveka(CookieManager.getContent(cookie)))
            return new Prijavljen(-1, false, false, false);

        return db.logovan(CookieManager.getContent(cookie));
    }

    @GetMapping("/obrisioglas")
    public String getMethodName(@RequestParam Integer id, HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (cookie != null && db.proveriCoveka(CookieManager.getContent(cookie))) {
            Prijavljen prijava = db.logovan(CookieManager.getContent(cookie));
            if (prijava.admin) {
                db.IzbrisiOglas(id);
            } else if (prijava.poslodavac) {
                if (db.jelovomoje(db.dajId(CookieManager.getContent(cookie)), id))
                    db.IzbrisiOglas(id);
            }
        }
        return "redirect:/profil";
    }

    @GetMapping("/novoglas")
    public String dodajoglas(HttpServletRequest req, HttpServletResponse res) {
        return "novOglas";
    }

    @PostMapping("/napravioglas")
    public @ResponseBody String napraviOglas(HttpServletRequest req, HttpServletResponse res,
            @RequestBody String body) {
        JSONObject js;
        Cookie cookie = CookieManager.getCookie(req);
        try {
            js = new JSONObject(body);
            if (js != null) {
                Prijavljen prijavljivanje = db.logovan(CookieManager.getContent(cookie));
                if (prijavljivanje.poslodavac == true || prijavljivanje.admin == true) {
                    db.dodajOglas(db.dajId(CookieManager.getContent(cookie)), js.getString("naslov"),
                            js.getBoolean("tip"), js.getInt("plata"), js.getString("opis"), js.getInt("mesto"));
                    return "OK";
                }
                return "BAD";
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return "BAD";
    }

    @GetMapping("/mojeprijave")
    public @ResponseBody List<Tagovi> mojeprijave(@RequestParam(required = false) Integer id, HttpServletRequest req,
            HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        Prijavljen pr = db.logovan(CookieManager.getContent(cookie));
        if (id != null && pr.admin) {
            return db.Daj_mojeprijave(id);
        }
        if (pr.prijavljen && !pr.poslodavac) {
            return db.Daj_mojeprijave(db.dajId(CookieManager.getContent(cookie)));
        }
        return null;
    }

    @PostMapping("/izbaci")
    public String izbrisiPrijavu(@RequestParam(required = false) Integer idcoveka, @RequestParam Integer id,
            HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie = CookieManager.getCookie(req);
        if (cookie != null && db.proveriCoveka(CookieManager.getContent(cookie))) {
            if (idcoveka != null) {
                if (db.proveriprijavu(idcoveka, id))
                    if (db.izbaciprijavu(idcoveka, id))
                        return "redirect:/oglas?id=" + id;
            }
            if (db.proveriprijavu(db.dajId(CookieManager.getContent(cookie)), id))
                if (db.izbaciprijavu(db.dajId(CookieManager.getContent(cookie)), id))
                    return "redirect:/profil";

        }
        return "redirect:/profil";
    }

    @GetMapping("/covek")
    public String posaljinacoveka(@RequestParam Integer id, HttpServletRequest req, HttpServletResponse res) {

        Integer i = db.dajid(id);
        if (i != null) {
            return "redirect:/profil?user=" + i;
        }
        return "redirect:/";
    }

    @GetMapping("/poslodavac")
    public @ResponseBody Prijavljen pr(@RequestParam(required = false) Integer id, HttpServletRequest req,
            HttpServletResponse res) {
        if (id == null && CookieManager.getCookie(req) != null) {
            return db.logovan(CookieManager.getContent(CookieManager.getCookie(req)));
        }
        return db.logovan(db.dajUsername(id));
    }

    @PostMapping("/izbrisiposlodavca")
    public String ripposlodavca(@RequestParam Integer id, HttpServletRequest req, HttpServletResponse res) {
        if (id != null && CookieManager.getCookie(req) != null) {
            if (db.logovan(CookieManager.getContent(CookieManager.getCookie(req))).admin) {
                db.izbrisiPoslodavca(id);
            }
        }
        return null;
    }

}
