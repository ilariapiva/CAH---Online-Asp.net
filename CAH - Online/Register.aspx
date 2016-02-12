<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

protected void Page_Load(object sender, EventArgs e)
{
    FunctionsDB.OpenConnectionDB();
}

protected void btnRegister_Click(object sender, EventArgs e)
{
    lblEmail.Text = "";
    lblUser.Text = "";

    Account email = new Account();
    email.Email = txtEmail.Text;
    var pwd = txtPassword.Text;
    Account user = new Account();
    user.Username = txtUsername.Text; 

    //Controllo che l'email inserita non sia già utilizzata da altri utenti 
    
    String strsqlEmail = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "'";
    bool resultEmail = FunctionsDB.CheckDB(strsqlEmail);

    if (resultEmail)
    {
        lblEmail.Text = "Questo indirizzo email è già utilizzato.";
    }

    //Controllo che lo username inserito non sia già utilizzata da altri utenti 
    
    String strsqlUser = "SELECT username FROM tblAccount WHERE username = '" + user.Username + "'";
    bool resultUser = FunctionsDB.CheckDB(strsqlUser);

    if (resultUser)
    {
        lblUser.Text = "Questo username è già utilizzato.";
    }

    //Inserisco il nuovo account nella tabella account
    
    if ((resultEmail == false) && (resultUser == false))
    {
        String strsql = @"INSERT INTO tblAccount(email, username, pwd, matchesPlayed, matchesWon, matchesMissed) 
                        VALUES ('" + email.Email + "', '" + user.Username + "', HASHBYTES('SHA1', '" + pwd + "'), '0', '0', '0')";
        FunctionsDB.WriteDB(strsql);
        Response.Redirect("~/login.aspx");
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
<form id="form2" runat="server">
        <div class="container">
            <div class="flat-form">
                <ul class="tabs">
                    <li><asp:HyperLink ID="hlLogin" runat="server" NavigateUrl="~/login.aspx">Login</asp:HyperLink></li>
                    <li><asp:HyperLink ID="hlRegister" runat="server" NavigateUrl="~/register.aspx" CssClass="active">Register</asp:HyperLink></li>
                    <li><asp:HyperLink ID="hlResetPassword" runat="server">Reset password</asp:HyperLink></li>
                </ul>
                <div class="form-action show">
                    <h1>Register</h1>
                    <p>Per iniziare a giocare a CAH - Online devi registrarti.</p>
                    <div>
                        <ul>
                            <li>E-mail address:
                                <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" />
                                <asp:RegularExpressionValidator class="info-error" ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail"/>
                                <asp:Label ID="lblEmail" runat="server" class="info-error"></asp:Label>
                            </li>
                        </ul>
                        <ul>
                            <li>Username&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtUsername" placeholder="Username" runat="server"/>
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator3" ControlToValidate="txtUsername" Display="Dynamic" ErrorMessage="Cannot be empty." runat="server" />
                                <asp:Label ID="lblUser" runat="server" class="info-error"></asp:Label>
                            </li>
                        </ul>
                        <ul>
                            <li>Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator5" ControlToValidate="txtPassword" ErrorMessage="Cannot be empty." runat="server" />
                            </li>
                        </ul>
                    </div>
                    <asp:Button ID="btnRegister" class="button" runat="server" OnClick="btnRegister_Click" Text="Sign Up" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>