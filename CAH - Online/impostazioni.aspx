<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String strsql1, strsql2;

    protected void Page_Load(object sender, EventArgs e)
    {
        FunctionUtilitysDB.Connessione();
    }

    void btnSalva_Click(object sender, EventArgs e)
    {
        lblUser.Text = "";

        var pwd = UserPass.Text;
        var user = UserName.Text;

        strsql1 = "SELECT username FROM tblAccount WHERE username = '" + user + "'";
        var result = FunctionUtilitysDB.Verifica(strsql1);

        if (result)
        {
            lblUser.Text = "Questo username è già utilizzato.";
        }

        if (result == false)
        {
            strsql1 = "UPDATE tblAccount SET username = '" + user + "'";
            FunctionUtilitysDB.Scrivi(strsql1);
            strsql2 = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "')";
            FunctionUtilitysDB.Scrivi(strsql2);
            Response.Redirect("~/index.aspx");
        }
    }
</script>
<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<html>
<head id="Head1" runat="server">
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
                        <img src="img/logo2.png" alt="CAH - Online"></a>
                </div>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
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
                                    <a href="profilo.aspx" class="nav-text">Profilo</a>
                                </li>
                                <li>
                                    <a href="impostazioni.aspx" class="nav-text nav-border nav-active">Impostazioni</a>
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
        <div class="container">
            <div class="flat-form-setting">
                <div class="form-action-setting">
                    <h1 class="h1">Impostazioni</h1>
                    <p class="p5">
                        Qui puoi modificare il tuo username e la password.
                        </p>
                    <p class="p5">
                        <br />
                    </p>
                    <div>
                        <ul>
                            <li>E-mail address:
                                <asp:TextBox ID="UserEmail" placeholder="Email" runat="server" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator4" ControlToValidate="UserEmail" Display="Dynamic" ErrorMessage="Cannot be empty." runat="server" />
                                <asp:Label ID="lblEmail" runat="server" class="info-error"></asp:Label>
                            </li>
                        </ul>
                        <ul>
                            <li>Username:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="UserName" placeholder="Username" runat="server" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator3" ControlToValidate="UserName" Display="Dynamic" ErrorMessage="Cannot be empty." runat="server" />
                                <asp:Label ID="lblUser" runat="server" class="info-error"></asp:Label>
                            </li>
                        </ul>
                        <ul>
                            <li>Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="UserPass" TextMode="Password" placeholder="Password" runat="server" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator5" ControlToValidate="UserPass" ErrorMessage="Cannot be empty." runat="server" />
                            </li>
                            <li>
                            </li>
                        </ul>
                    </div>
                    <div>
                        <asp:Button ID="btnSalva" class="button" Text="Salva" OnClick="btnSalva_Click" runat="server" />
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
