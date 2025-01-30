<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Détails de connexion à la base de données
    String dbURL = "jdbc:mysql://localhost:3306/projet?useTimeZone=true&serverTimezone=UTC&useSSL=false&useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "2021";

    // Récupérer les données du formulaire
    request.setCharacterEncoding("UTF-8"); // Définir l'encodage des caractères pour la requête
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    // Créer un objet JSON pour stocker la réponse
    JSONObject jsonResponse = new JSONObject();

    // Vérifier si name et email ne sont pas nuls ou vides
    if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "الاسم والبريد الإلكتروني مطلوبان.");
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Charger le pilote JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Établir une connexion à la base de données
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Requête SQL pour vérifier si name et email existent dans la base de données
            String sql = "SELECT * FROM testa WHERE name = ? AND email = ?"; // Remplacez "users" par le nom de votre table
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);

            // Exécuter la requête
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Si name et email existent
                jsonResponse.put("success", true);
                jsonResponse.put("message", "تم التحقق بنجاح!");
            } else {
                // Si name et email n'existent pas
                jsonResponse.put("success", false);
                jsonResponse.put("message", "الاسم والبريد الإلكتروني غير محفوظين في قاعدة البيانات.");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "خطأ في تحميل مشغل قاعدة البيانات: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "خطأ في قاعدة البيانات: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "حدث خطأ: " + e.getMessage());
        } finally {
            // Fermer les ressources de la base de données
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Définir le type de contenu à JSON
    response.setContentType("application/json; charset=UTF-8");
    // Écrire la réponse JSON
    out.print(jsonResponse.toString());
%>