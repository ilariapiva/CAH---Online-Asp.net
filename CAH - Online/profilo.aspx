<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="CAHOnline" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //FunctionUtilitysDB.ApriConnessioneDB();

        String email;
        SqlConnection cn;
        SqlCommand cmd;

        
        string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        cn = new SqlConnection(strcn);
        cn.Open();
        
        lblEmail.Text = Request.Cookies["userEmail"].Value;

        if (Request.Cookies["userEmail"] != null)
        {
            lblEmail.Text = Server.HtmlEncode(Request.Cookies["userEmail"].Value);
        }
        email = lblEmail.Text;

        String strsql = "SELECT tblAccount.username, tblPartita.giocate, tblPartita.perse, tblPartita.vinte FROM tblAccount, tblPartita WHERE tblAccount.idAccount = tblPartita.idAccount AND tblAccount.email = '" + email + "' ";

        cmd = new SqlCommand(strsql, cn);
        var dr = cmd.ExecuteReader();
        while (dr.Read())
        {
            lblUsername.Text += dr["username"];
            lblPartiteGiocate.Text += dr["giocate"];
            lblPartitePerse.Text += dr["perse"];
            lblPartiteVinte.Text += dr["vinte"];
        }
        dr.Close();
        cn.Dispose();
        cmd.Dispose();
    }
</script>
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap.css.map" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/Style.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <title>CAH - Online</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <nav class="navbar navbar-inverse nav-color navbar-width" role="navigation">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a href="index.aspx">
                            <img src="img/logo2.png" alt="CAH - Online" /></a>
                    </div>
                    <div class="collapse navbar-collapse">
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a href="index.aspx" class="nav-text">Home</a>
                            </li>
                            <li>
                                <a href="regole.aspx" class="nav-text">Regole</a>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle nav-text nav-active" data-toggle="dropdown">Nome utente <b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href="profilo.aspx" class="nav-text nav-active">Profilo</a>
                                    </li>
                                    <li>
                                        <a href="impostazioni.aspx" class="nav-text nav-border">Impostazioni</a>
                                    </li>
                                    <li>
                                        <a href="login.aspx" class="nav-text">Logout</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
        <div class="container">
            <div class="flat-form-profile">
                <div class="form-action-profile">
                    <h1 class="h1">Profilo</h1>
                    <p class="p5">
                        Qui puoi vedere i tuoi risultati.
                    </p>
                    <div class="form-horizontal form-text">
                        <ul>
                            <li class="form-control-static p4">E-mail:
                                <asp:Label class="control-label label-form" ID="lblEmail" runat="server"></asp:Label>
                                &nbsp;
                            </li>
                            <li class="form-control-static p4">Username:
                                <asp:Label class="control-label label-form" ID="lblUsername" runat="server"></asp:Label>
                                &nbsp;
                            </li>
                            <li class="form-control-static p4">Partite giocate:
                                <asp:Label class="control-label label-form" ID="lblPartiteGiocate" runat="server"></asp:Label>
                                &nbsp;
                            </li>
                            <li class="form-control-static p4">Partite vinte:
                                <asp:Label class="control-label label-form" ID="lblPartiteVinte" runat="server"></asp:Label>
                                &nbsp;
                            </li>
                            <li class="form-control-static p4">Partite perse:
                                <asp:Label class="control-label label-form" ID="lblPartitePerse" runat="server"></asp:Label>
                                &nbsp;
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <footer class="footer">
            <div class="black-text p-footer">
                <p class="left-footer">Copyright &copy; Ilaria Piva</p>
                <p class="right-footer">CAH - Online 2015/2016</p>
            </div>
        </footer>
    </form>
</body>
</html>
