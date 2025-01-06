package user;

import bean.CGenUtil;
import bean.TypeObjet;
import historique.MapHistorique;
import historique.UtilisateurUtil;
import lc.Direction;
import mg.cnaps.log.LogService;
import mg.cnaps.utilisateur.CNAPSUser;
import utilitaire.UtilDB;

import javax.ejb.AccessTimeout;
import javax.ejb.Stateful;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.sql.Connection;
@Stateful
@AccessTimeout(10000)
@TransactionAttribute(TransactionAttributeType.SUPPORTS)
public class MyUserEjbBean extends UserEJBBean {
    @Override
    public void testLogin(String user, String pass, String interim, String service) throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn("gallois","gallois");
            c.setAutoCommit(false);
            System.out.println("INTERIM / "+interim);
            System.out.println("SERVICE / "+service);
            u = testeValide(user, pass, interim, service);
            UtilisateurUtil crt = new UtilisateurUtil();
            uVue = crt.testeValide("utilisateurVue", user, pass);
            type = u.getIdrole();
            if (type.compareToIgnoreCase(bean.Constante.getIdRoleDirecteur()) == 0) {
                Direction d[] = findDirection("", "", "", "", String.valueOf(u.getRefuser()));
                if (d.length > 0) {
                    this.setIdDirection(d[0].getIdDir());
                } else {
                    type = u.getIdrole();
                }
            }
            CNAPSUser[] cnp = (CNAPSUser[]) CGenUtil.rechercher(new CNAPSUser(), null, null, c, " and id_utilisateur = '" + u.getRefuser() + "'");

            this.cnapsUser = (cnp != null) ? cnp[0] : null;
            if (interim != null && interim.compareToIgnoreCase("1") == 0 && cnp.length > 0) {
                LogService[] ls = (LogService[]) CGenUtil.rechercher(new LogService(), null, null, c, " AND ID = '" + service + "'");
                if (ls.length == 0) {
                    throw new Exception("SERVICE INTROUVABLE");
                }
                this.cnapsUser = new CNAPSUser(cnp[0].getCode_dr(), cnp[0].getUser_init(), cnp[0].getAgent_mo(), cnp[0].getAgent_disponible(), cnp[0].getUsername(), ls[0].getCode_service(), u.getRefuser() + "");
            }

            this.listeConfig = this.findConfiguration();

            TypeObjet to = new TypeObjet();
            to.setNomTable("SOURCE");
            setListeSource((TypeObjet[]) CGenUtil.rechercher(to, null, null, c, ""));

            u.setPwduser(getAddrIp());
            MapHistorique histo = new MapHistorique("login", "login", String.valueOf(u.getRefuser()), String.valueOf(u.getRefuser()));
            histo.setObjet("mg.cnaps.utilisateur.CNAPSUser");
            histo.setAction(histo.getAction() + "-" + getAddrIp());
            histo.insertToTable();
        } catch (Exception ex) {
            if (c != null) {
                c.rollback();
            }
            ex.printStackTrace();
            throw ex;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }
}
