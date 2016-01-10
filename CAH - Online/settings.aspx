<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">
    
    String email;

    //Memorizzo tramite i cookies l'email e tramite l'email faccio un controllo nel db e ricavo lo username
    protected void Page_Load(object sender, EventArgs e)
    {
        FunctionsDB.OpenConnectionDB();

        lblEmail.Text = Request.Cookies["userEmail"].Value;

        if (Request.Cookies["userEmail"] != null)
        {
            lblEmail.Text = Server.HtmlEncode(Request.Cookies["userEmail"].Value);
        }
        email = lblEmail.Text;

        String strsql = "SELECT username FROM tblAccount WHERE email = '" + email + "' ";
        List<string> resultUser = FunctionsDB.ReadUsernameDB(strsql);

        lblUserName.Text = resultUser[0];
    }
     
    void btnSalva_Click(object sender, EventArgs e)
    {
        lblUser.Text = "";
       
        var pwd = UserPass.Text;
        var user = UserName.Text;

        //Controllo che il username scelto non sia già utilizzato da altri utenti
        String strsqlUser = "SELECT username FROM tblAccount WHERE username = '" + user + "'";
        var result = FunctionsDB.CheckDB(strsqlUser);
        
        if (result)
        {
            lblUser.Text = "Questo username è già utilizzato.";
        }

        //Se il nome utente non è già stato utilizzato eseguo la query che modifica lo username e la password
        if (result == false)
        {
            strsqlUser = "UPDATE tblAccount SET username = '" + user + "' WHERE email = '" + email + "' ";
            FunctionsDB.WriteDB(strsqlUser);

            String strsqlPwd = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "') WHERE email = '" + email + "' ";
            FunctionsDB.WriteDB(strsqlPwd);
            
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
                <div class="collapse navbar-collapse">
                    <ul class="nav navbar-nav navbar-right">
                        <li>
                            <a href="index.aspx" class="nav-text">Home</a>
                        </li>
                        <li>
                            <a href="rules.aspx" class="nav-text">Rules</a>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle nav-text nav-active" data-toggle="dropdown">
                                    <asp:Label class="control-label label-form" ID="lblUserName" runat="server"></asp:Label>
                                &nbsp;<b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="profile.aspx" class="nav-text">Profile</a>
                                </li>
                                <li>
                                    <a href="settings.aspx" class="nav-text nav-border nav-active">Settings</a>
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
                    <h1 class="h1">Settings</h1>
                    <p class="p5">
                        Qui puoi modificare il tuo username e la password.
                        </p>
                    <p class="p5">
                        <br />
                    </p>
                    <div>
                        <ul>
                            <li>E-mail address:
                                <asp:Label ID="lblEmail" class="label-form" runat="server"></asp:Label>
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
