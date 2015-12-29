<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

protected void Page_Load(object sender, EventArgs e)
{
    FunctionUtilitysDB.ApriConnessioneDB();
}

protected void btnRegister_Click(object sender, EventArgs e)
{
    lblEmail.Text = "";
    lblUser.Text = "";

    var email = UserEmail.Text;
    var pwd = UserPass.Text;
    var user = UserName.Text;

    String strsqlEmail = "SELECT email FROM tblAccount WHERE email = '" + email + "'";
    var resultEmail = FunctionUtilitysDB.Verifica(strsqlEmail);

    if (resultEmail)
    {
        lblEmail.Text = "Questo indirizzo email è già utilizzato.";
    }

    String strsqlUser = "SELECT username FROM tblAccount WHERE username = '" + user + "'";
    var resultUser = FunctionUtilitysDB.Verifica(strsqlUser);

    if (resultUser)
    {
        lblUser.Text = "Questo username è già utilizzato.";
    }

    if ((resultEmail == false) && (resultUser == false))
    {
        String strsql = "INSERT INTO tblAccount(email, username, pwd) VALUES ('" + email + "', '" + user + "', HASHBYTES('SHA1', '" + pwd + "'))";
        FunctionUtilitysDB.ScriviDB(strsql);
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
                    <li><a href="login.aspx">Login</a></li>
                    <li class="active">Register</li>
                    <li>Reset password</li>
                </ul>
                <div class="form-action show">
                    <h1>Register</h1>
                    <p>Per iniziare a giocare a CAH - Online devi registrarti.</p>
                    <div>
                        <ul>
                            <li>E-mail address:
                                <asp:TextBox ID="UserEmail" placeholder="Email" runat="server" />
                                <asp:RegularExpressionValidator class="info-error" ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="UserEmail"/>
                                <asp:Label ID="lblEmail" runat="server" class="info-error"></asp:Label>
                            </li>
                        </ul>
                        <ul>
                            <li>Username&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                        </ul>
                    </div>
                    <asp:Button ID="btnRegister" class="button" runat="server" OnClick="btnRegister_Click" Text="Sign Up" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
