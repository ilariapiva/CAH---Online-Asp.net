<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    Account userEmail, email;
    String pwd;

    protected void Page_Load(object sender, EventArgs e)
    {
        FunctionsDB.OpenConnectionDB();
    }

    void btnLogin_Click(object sender, EventArgs e)
    {
        userEmail = new Account();
        email = new Account();
        pwd = "";
        
        email.Email = txtEmail.Text;
        pwd = txtPassword.Text;

        //Controllo che l'email e la pwd corrispondano ad uno user registrato e poi memorizzo tramite i cookies l'email e accedo alla pagina principale
        if (FunctionsDB.Login(email, pwd))
        {
            userEmail.Email = txtEmail.Text;

            FunctionsDB.CookiesResponse(userEmail);//Memorizzo l'email nei cookies

            FormsAuthentication.RedirectFromLoginPage(userEmail.Email, CheckBoxRemember.Checked);
            Response.Redirect("~/index.aspx");
        }
        else
        {
            lblMsg.Text = "Invalid credentials. Please try again.";
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
        <div class="container">
            <div class="flat-form">
                <ul class="tabs">
                    <li><asp:HyperLink ID="hlLogin" runat="server" NavigateUrl="~/login.aspx" CssClass="active">Login</asp:HyperLink></li>
                    <li><asp:HyperLink ID="hlRegister" runat="server" NavigateUrl="~/register.aspx">Register</asp:HyperLink></li>
                    <li><asp:HyperLink ID="hlResetPassword" runat="server">Reset password</asp:HyperLink></li>
                </ul>
                <div class="form-action show">
                    <h1>CAH - Online</h1>
                    <p>Il famoso gioco di carte Cards Against Humanity in versione Online.</p>
                    <div>
                        <ul>
                            <li>E-mail address:
                                <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" />
                                <asp:RegularExpressionValidator class="info-error" ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail"/>
                            </li>
                        </ul>
                        <ul>
                            <li>Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator2" ControlToValidate="txtPassword" ErrorMessage="Cannot be empty." runat="server" />
                            </li>
                        </ul>
                        <ul>
                            <li>Remember me?
                                <asp:CheckBox ID="CheckBoxRemember" runat="server" />
                            </li>
                        </ul>
                    </div>
                    <asp:Button ID="btnLogin" class="button" OnClick="btnLogin_Click" Text="Login" runat="server" />
                    <p>
                        <asp:Label ID="lblMsg" ForeColor="Red" runat="server" />
                    </p>
                    <p>
                        <asp:Label ID="lblConnessione" runat="server"></asp:Label>
                    </p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
