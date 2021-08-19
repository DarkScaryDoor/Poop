package com.example.Project;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.boot.configurationprocessor.json.JSONException;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ProjectController {

    DatabaseConnector db = new DatabaseConnector();

    @GetMapping("/")
    public String home(HttpServletRequest req, HttpServletResponse res) {
        Cookie cookie;
        if ((cookie = CookieManager.getCookie(req)) != null) {
            if (db.nadjiUser("username", CookieManager.getContent(cookie)))
                return "index";
        }
        return "index";
    }

    @GetMapping("/oglasi")
    public String oglasi(HttpServletRequest req, HttpServletResponse res, @RequestParam(required = false) String poslodavac,@RequestParam(required = false) String mesto,@RequestParam(required = false) String radno_vreme){
        Cookie cookie;
        if ((cookie = CookieManager.getCookie(req)) != null) {
            if (db.nadjiUser("username", CookieManager.getContent(cookie)))
                return "Logovanmain";
        }
        return "sviOglasi";
    }

    @GetMapping("/potrazi")
    public @ResponseBody List<Oglas> potrazi(@RequestParam(required = false) String poslodavac,@RequestParam(required = false) String mesto,@RequestParam(required = false) String radno_vreme){
        //db.Daj_Oglase(poslodavac, Mesto, "1", radno_vreme);
        return null;

        
    }
    


    @GetMapping("/all")
    public @ResponseBody List<Oglas> all() {
        return db.sviOglasi();
    }

    @GetMapping("/signup")
    public String signup(HttpServletRequest req, HttpServletResponse res) {
        if (CookieManager.getCookie(req) != null) {
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
                    db.ubaciUsera(js.getString("user"), js.getString("pass"), js.getString("name"), js.getString("email"),js.getInt("mesto"),js.getInt("telefon"),js.getBoolean("person"));
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
                if ( body != null) {
                if (! db.proveriSignin(js.getString("user"), js.getString("pass"),js.getBoolean("rememberMe")))
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
    public String Profil(@RequestParam(required = false) String user, HttpServletRequest req,
            HttpServletResponse res) {
        if (CookieManager.getCookie(req) == null && user == null)
            return "redirect:/";
        if (CookieManager.getCookie(req) != null && user == null)
            return "Mainprofile";
        if (CookieManager.getCookie(req) == null && user != null)
            return "profil";
        if (db.dajId(CookieManager.getCookie(req).getValue()).toString() == user)
            return "Mainprofile";
        return "profil";
    }
    @GetMapping("/profile")//ovo treba da zavrsim
    public @ResponseBody List<errorCode> nazivProfila(@RequestParam(required = false) Integer user,HttpServletRequest req, HttpServletResponse res){
        Cookie cookie;
        List<errorCode> lista = new ArrayList<errorCode>();
        if ((cookie = CookieManager.getCookie(req)) != null) {
            if ( db.proveriCoveka(CookieManager.getContent(cookie), user))
                lista.add(new errorCode("OK"));
                return lista;
        }
        lista.add(new errorCode("greska"));
        return lista;
    }

    @GetMapping("/cities")
    public @ResponseBody List<Mesto> gradovi(HttpServletRequest req, HttpServletResponse res){
        List<Mesto> lista = db.Daj_gradove();
        if(lista.isEmpty()){
            lista.add(new Mesto(-1,"Nema gradova"));
        }
        return lista;
    }

    @GetMapping("/tags")
    public @ResponseBody List<errorCode> tagovi(HttpServletRequest req, HttpServletResponse res){
        List<errorCode> lista = db.Daj_tagove();
        if(lista.isEmpty()){
            lista.add(new errorCode("Nema tagova"));
        }
        return lista;
    }
}

