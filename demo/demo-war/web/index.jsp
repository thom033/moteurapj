<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire"%>

<%@ page import="java.io.*" %>
  
<%
    String but = "";
    String queryString = "";
    try{
        queryString = request.getQueryString();
        but = "pages/testLogin.jsp";
        if(queryString != null && !queryString.equals("")){
            but += "?" + queryString;
        }
    }
    catch(Exception ex){ %>
        <script language="JavaScript">
        alert(<%=ex.getMessage()%>);
        document.location.replace("../index.jsp");
        </script>
   <% }
%>
<!DOCTYPE html>
  <html lang="FR">
    <head>
      <meta charset="UTF-8">
      <title>Identification</title>
      <!-- Tell the browser to be responsive to screen width -->
      <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
      <link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
      <link href="${pageContext.request.contextPath}/assets/css/apj-style.css" rel="stylesheet" type="text/css" />

      <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
      <![endif]-->
    </head>
    <body class="login-page">
      <div class="row d-flex align-items-center login-container  ">
        <div class="col-lg-7 col-md-7  login-img">
            <img src="${pageContext.request.contextPath}/assets/img/login-img.png" alt="" srcset="" class="col-lg-10 col-md-8">
        </div>
        <div class="col-lg-4 col-md-4 col-sm-12  d-flex flex-column align-items-start justify-content-center">
            <div class="login-logo d-flex align-items-center">
                <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="" srcset="">
                <h3 class="">Company</h3>
            </div>
            <div class="login-txt">
                <h3>BIENVENU(E)!</h3>
                <p>Bienvenu(e) sur votre espace de travail !</p>
            </div>
            <form action="<%=but%>" method="post" class="col-lg-12 col-md-12">
                <div class="login-form ">

                        <%if (request.getParameter("error")!=null && !request.getParameter("error").equals("")){%>
                            <div class="alert alert-danger" >
                                <%=request.getParameter("error") %>
                            </div>
                        <% }%>
                        <div class="form-group">
                            <input type="text" name="identifiant" id="login-id" class="form-control" placeholder="Nom d'utilisateur" autofocus="autofocus">
                        </div>
                        <div class="form-group ">
                            <input type="password" name="passe" id="login-id" class="form-control" placeholder="Mot de passe">
                        </div>
                        <div class="form-group ">
                            <input type="submit" value="Se connecter" name="" id="login-id" class="btn btn-apj-primary" style="font-size: 28px !important;font-weight: 600">
                        </div>
                </div>
            </form>
        </div>
    </div>

      <!-- jQuery 2.1.4 -->
      <script src="${pageContext.request.contextPath}/plugins/jQuery/jQuery-2.1.4.min.js" type="text/javascript"></script>
      <!-- Bootstrap 3.3.2 JS -->
      <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
      <!-- iCheck -->
      <script src="${pageContext.request.contextPath}/plugins/iCheck/icheck.min.js" type="text/javascript"></script>
      <script>
        $(function () {
          $('input').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%' // optional
          });
        });
      </script>
    </body>
  </html>